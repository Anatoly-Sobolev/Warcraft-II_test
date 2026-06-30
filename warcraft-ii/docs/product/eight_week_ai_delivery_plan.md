# 8-недельный план порта Warcraft II для AI-assisted команды

Документ отвечает на практический вопрос: как за 8 недель двигаться к
полноценному порту Warcraft II на Godot 4.4/ОС Аврора, если большую часть кода
пишут студенты с помощью ИИ.

Главное уточнение: проект не создает новую RTS. Он переносит поведение Warcraft II
на новый runtime и новые ассеты. Поэтому каждый спринт должен уменьшать разрыв
между оригиналом/Wargus и нашим проектом, а не придумывать новую систему правил.

## Исходные условия

- Команда: 4 программиста-оператора ИИ, 1 дизайнер, 1 тестировщик.
- Цель: gameplay-equivalent порт Warcraft II для ОС Аврора.
- Движок: Godot 4.4, GDScript для orchestration, `.tres`/каталоги для данных,
  GDExtension/C++ только после измерений.
- Новые ассеты обязательны; правила, темп и механики должны повторять Warcraft II.
- Основной технический справочник: локальный Wargus checkout и
  `docs/gameplay/mechanics_matrix.md`.
- Каждая механика принимается только через цепочку:
  `source -> runtime mapping -> WarcraftCommand/order/rule -> test -> demo`.

## Архитектурный фокус

Раньше план был сформулирован как создание авторитетной `Simulation`. Для порта
это слишком широкая и опасная рамка: студенты начнут проектировать свою RTS.
Новая рамка - `Warcraft Runtime`.

`Warcraft Runtime` отвечает только за воспроизведение уже существующих правил:

- fixed game cycle вместо логики, завязанной на FPS;
- `WarcraftCommand` как единственный вход для игрока, AI и сценариев;
- `UnitHandle`, плоские state-хранилища и dirty-буферы для производительности;
- orders для прямого переноса команд Warcraft II/Wargus;
- rules для общих правил карты, видимости, смерти, снарядов и статусов;
- ports/ViewData для UI, Presentation и Scenario.

UI, Presentation, Input и Scenario не меняют runtime state напрямую. Они только
создают команды или читают подготовленные данные.

## Почему это ускоряет перенос механик

Студенту не нужно спрашивать: "Как нам придумать строительство?". Он получает
более узкую задачу:

1. Найти поведение строительства в Wargus/Warcraft II.
2. Зафиксировать source ID в `mechanics_matrix.md`.
3. Сопоставить его с нашим модулем в `docs/porting/wargus_runtime_mapping.md`.
4. Перенести поведение в `game/warcraft_runtime/orders/order_build.gd` и нужные
   state/rules.
5. Добавить тест на наблюдаемое поведение.
6. Показать механику в демо.

ИИ в такой схеме помогает читать и разносить существующие правила, но не получает
свободу проектировать новую RTS-архитектуру.

## Performance-gate

Производительность является критерием приемки, а не финальной полировкой.

Каждый спринт должен сохранять следующие правила:

- runtime не зависит от Godot Node tree;
- итерации по юнитам идут по плотным массивам/state-хранилищам;
- pathfinding, fog, visibility и render sync имеют отдельные dirty/incremental
  механизмы;
- UI не опрашивает весь мир каждый кадр;
- GDExtension/C++ разрешается только для измеренного узкого места;
- перед оптимизацией должен быть benchmark или ручной performance case.

Минимальные метрики для отчетов:

| Область | Что измерять |
| --- | --- |
| Runtime tick | среднее и худшее время game cycle на демо-карте |
| Pathfinding | число запросов, cache hit rate, worst path time |
| Fog/visibility | число обновленных клеток за cycle |
| Render sync | число dirty unit/view updates |
| UI | отсутствие полного пересчета панелей каждый frame |

## Роли команды

| Роль | Основная зона |
| --- | --- |
| Программист 1 | `game/warcraft_runtime`: commands, orders, state, rules, tests |
| Программист 2 | `game/presentation`, `game/input`: views, camera, selection, interpolation |
| Программист 3 | `ui`, `scenario`, `campaign`: HUD, menus, mission goals, result flow |
| Программист 4 | `content`, `tools`, `services`, import reports, save/load, benchmarks |
| Дизайнер | новые ассеты, HUD, иконки, читаемость Warcraft-like экрана |
| Тестировщик | smoke, mechanics parity tests, performance cases, sprint reports |

Каждую неделю один разработчик выполняет роль runtime reviewer: проверяет, что
механики идут через `WarcraftCommand`, а игровой state не оказался в UI/Node.

## Sprint 01: запускаемый порт-каркас

Период: 2026-07-06 - 2026-07-10.

Цель: проект открывается в Godot, запускает путь `App -> Menu -> Match`, имеет
пустой `Warcraft Runtime` и smoke test.

| Задача | Риск | DoD |
| --- | --- | --- |
| Назначить main scene и проверить запуск Godot 4.4. | Низкий | Чистый запуск описан в README. |
| Собрать `MatchComposition` с портами runtime/input/presentation/ui/scenario. | Средний | Нет прямых зависимостей UI на runtime state. |
| Реализовать минимальный `game_cycle_runner`: fixed cycle, accumulator, catch-up limit. | Средний | Есть test/manual check fixed cycle. |
| Подготовить первую демо-карту-заглушку с новыми placeholder ассетами. | Низкий | Не используются оригинальные ассеты. |
| Заполнить Sprint 01 report и smoke test. | Низкий | Отчет не обещает неработающие фичи. |

## Sprint 02: runtime model и команды

Период: 2026-07-13 - 2026-07-17.

Цель: зафиксировать основу переноса: `UnitHandle`, registry/index, command queue,
runtime snapshot и первые ViewData.

| Задача | Риск | DoD |
| --- | --- | --- |
| Реализовать `UnitHandle`, `unit_registry`, `runtime_index`. | Средний | Тесты ID, reuse, invalid handles. |
| Реализовать `WarcraftCommand` и очередь команд по game cycle. | Высокий | Игрок/AI/scenario не обходят очередь. |
| Создать базовые state: type, position, ownership, vitals, order. | Средний | Хранилища плоские и тестируемые без сцен. |
| Создать `runtime_ui_query`, `warcraft_command_query`, `selection_query`. | Средний | UI получает только ViewData. |
| Описать mapping первых Wargus понятий в porting docs. | Низкий | Есть ссылка на mechanics matrix. |

## Sprint 03: карта, выбор и move

Период: 2026-07-20 - 2026-07-24.

Цель: игрок видит карту, выбирает юнита и отправляет команду движения, а runtime
считает результат fixed cycle.

| Задача | Риск | DoD |
| --- | --- | --- |
| Реализовать `warcraft_map`, terrain flags, static/unit occupancy. | Высокий | Карта пригодна для pathfinding и placement. |
| Перенести MVP `move` order из поведения Warcraft II/Wargus. | Высокий | Тест: команда меняет позицию по cycle. |
| Реализовать path service с cache/request queue. | Высокий | Есть performance case на демо-карте. |
| Сделать selection flow через ports. | Средний | Input не читает state напрямую. |
| Presentation синхронизирует view через dirty buffers. | Средний | View не владеет игровой логикой. |

## Sprint 04: экономика

Период: 2026-07-27 - 2026-07-31.

Цель: перенести Warcraft II loop добычи: рабочий добывает золото/дерево, несет
ресурс, сдает в Town Hall, HUD показывает результат.

| Задача | Риск | DoD |
| --- | --- | --- |
| Добавить каталоги Peasant, Town Hall, Gold Mine, Forest. | Средний | Данные лежат в content/catalogs. |
| Реализовать `order_resource` и worker/resource node state. | Высокий | Тесты harvest, carry, return goods. |
| Перенести правила вместимости, расстояний и interrupt behavior. | Высокий | Отличия от Wargus записаны явно. |
| HUD resource bar через `runtime_ui_query`. | Средний | UI не считает ресурсы сам. |
| Измерить стоимость resource cycle на демо-карте. | Средний | Есть строка в sprint report. |

## Sprint 05: строительство и производство

Период: 2026-08-03 - 2026-08-07.

Цель: игрок строит Farm/Barracks и тренирует Peasant/Footman по правилам
Warcraft II.

| Задача | Риск | DoD |
| --- | --- | --- |
| Добавить data-каталоги стоимости, времени, supply и command buttons. | Средний | Нет hardcode в UI. |
| Реализовать placement validation и building occupancy. | Высокий | Тест: нельзя строить на занятой/недопустимой клетке. |
| Перенести `order_build` с оплатой, worker state и construction progress. | Высокий | Тесты списания, cancel/finish минимум. |
| Перенести `order_train` и spawn placement. | Высокий | Юнит появляется после времени тренировки. |
| Command panel строится из данных и `warcraft_command_query`. | Средний | Доступность кнопок решает runtime/query. |

## Sprint 06: бой, туман и victory

Период: 2026-08-10 - 2026-08-14.

Цель: демо становится игрой: юниты атакуют, умирают, fog влияет на видимость, миссия
может завершиться победой или поражением.

| Задача | Риск | DoD |
| --- | --- | --- |
| Перенести `order_attack`: target rules, cooldown, range, damage. | Высокий | Тесты attack/cooldown/death. |
| Реализовать missile/status/lifecycle rules для MVP боя. | Высокий | Смерть освобождает selection/view/state корректно. |
| Реализовать fog/explored grid и visibility rules. | Высокий | Presentation получает fog buffers. |
| Добавить scenario victory/defeat через runtime ports. | Средний | Scenario не меняет state напрямую. |
| Измерить бой + fog на демо-сцене. | Средний | Performance report обновлен. |

## Sprint 07: миссия, AI и save/load

Период: 2026-08-17 - 2026-08-21.

Цель: собрать не песочницу, а маленькую миссию Warcraft II-типа: briefing,
стартовые условия, enemy behavior, сохранение и загрузка.

| Задача | Риск | DoD |
| --- | --- | --- |
| Описать demo mission data: старт, цели, враг, ресурсы. | Средний | Миссия воспроизводима из clean checkout. |
| Перенести минимальный AI loop через обычные `WarcraftCommand`. | Высокий | AI не пишет в state напрямую. |
| Реализовать `RuntimeSnapshot` для MVP state. | Высокий | Save/load восстанавливает текущую миссию. |
| Добавить briefing/objective/result flow. | Средний | Игрок понимает цель и результат. |
| Регрессия: экономика, строительство, бой после load. | Высокий | Тест/ручной кейс записан. |

## Sprint 08: parity, performance, stabilization

Период: 2026-08-24 - 2026-08-28.

Цель: не расширять scope, а доказать, что порт запускается, механики работают,
ограничения честно описаны, производительность измерена.

| Задача | Риск | DoD |
| --- | --- | --- |
| Пройти smoke/regression из чистого состояния. | Средний | README и sprint report совпадают с демо. |
| Провести mechanics parity pass по `mechanics_matrix.md`. | Средний | Для каждой заявленной механики есть статус. |
| Оптимизировать только измеренные узкие места. | Высокий | До/после метрики записаны. |
| Проверить Aurora/mobile profile или ближайший слабый профиль. | Высокий | Есть FPS/tick report. |
| Финализировать новые ассеты демо без изменения правил. | Средний | Визуал не маскирует неготовые механики. |

## Что сознательно не делать в первые 8 недель

| Не делать | Почему |
| --- | --- |
| Своя RTS-экономика, альтернативный бой, новый command model | Это разрушает цель порта. |
| Полная кампания сразу | Сначала нужна одна проверяемая миссия. |
| Multiplayer/network sync | Требует отдельного детерминизма и протокола. |
| Полный Lua runtime | Сначала достаточно адаптеров и data import reports. |
| C++ ядро "на всякий случай" | Нужны измерения, иначе усложним обучение студентов. |
| Редактор карт | Не нужен для доказательства порта. |

## Шаблон задачи для ИИ

```text
Задача: перенести <mechanic id> из Warcraft II/Wargus.

Источник:
- mechanics_matrix.md: <ID>
- Wargus files/functions: <пути/имена>
- наблюдаемое поведение: <коротко>

Изменять:
- game/warcraft_runtime/<orders|rules|state|map>/...
- tests/<unit|integration|performance>/...
- docs/sprints/<актуальный отчет>.md

Нельзя:
- писать игровую логику в UI/Presentation/Input;
- обходить WarcraftCommand;
- менять state из Scenario напрямую;
- добавлять новую трактовку механики без записи отличия.

Проверка:
- unit/integration/performance/manual case;
- что именно должно совпасть с Warcraft II/Wargus;
- какие ограничения остаются.
```

## Минимальный Definition of Done

- Изменение связано с ID в `mechanics_matrix.md`.
- Есть mapping к `game/warcraft_runtime`.
- Действие игрока, AI или сценария идет через `WarcraftCommand`.
- Runtime остается тестируемым без Godot-сцены.
- UI/Presentation получают только ViewData/events/dirty buffers.
- Есть тест или ручной сценарий.
- Если затронута производительность, есть измерение.
- Ограничения и отличия от Warcraft II/Wargus записаны явно.

## Главный вывод

Самый прямой путь - не проектировать новую RTS, а сделать удобный слой переноса:
`Warcraft Runtime` с теми же понятиями, что у Warcraft II/Wargus, но с
Godot-совместимой подачей данных и performance-friendly хранилищами. Это снижает
сложность для студентов: они переносят конкретные orders/rules и проверяют их
тестами, а не изобретают боевую, экономическую и сценарную системы с нуля.
