# 8-недельный production-план порта Warcraft II

Документ заменяет общий план AI-assisted разработки на рабочий план производства порта. Цель проекта - сделать полноценный порт игрового поведения Warcraft II на новую архитектуру Godot-проекта, но с новыми ассетами и без разработки "новой RTS с похожими правилами".

Ключевые приоритеты:

1. Максимально упростить перенос уже существующих механик Warcraft II/Wargus.
2. Сохранять `game/warcraft_runtime/` единственным источником правды о матче.
3. Не писать отдельную "красивую" механику, если ее можно перенести как data-driven правило, каталог, таблицу или order handler.
4. Держать производительность как обязательный критерий Definition of Done.
5. Давать студентам маленькие задачи с понятным входом, ожидаемым результатом, оценкой сложности в промптах и уровнем проверки тимлидом.
6. Давать дизайнеру задания только от референсов: каждый графический, звуковой или видео-элемент должен иметь источник, crop/reference board и точку внедрения.

## Команда и роли

| Роль | Зона ответственности | Основные папки |
| --- | --- | --- |
| P1, Runtime | Правила Warcraft II, order handlers, economy, combat, fog, AI, детерминированные тесты. | `warcraft-ii/game/warcraft_runtime/`, `warcraft-ii/tests/warcraft_runtime/`, `warcraft-ii/docs/gameplay/` |
| P2, Presentation/Input | Камера, выбор, карта, render sync, эффекты матча, адаптация под сенсорное управление. | `warcraft-ii/game/presentation/`, `warcraft-ii/game/input/`, `warcraft-ii/docs/input/` |
| P3, UI/Scenario/Campaign | HUD, меню, briefing, objectives, сценарные события, прогресс кампании. | `warcraft-ii/ui/`, `warcraft-ii/game/scenario/`, `warcraft-ii/game/campaign/` |
| P4, Content/Tools/Services/QA | Каталоги, import reports, валидация контента, сохранения, настройки, performance checks, sprint reports. | `warcraft-ii/content/`, `warcraft-ii/tools/`, `warcraft-ii/services/`, `warcraft-ii/docs/sprints/` |
| D, Designer | Референсы, новые ассеты, HUD/components, tilesets, spritesheets, icons, effects, audio/video briefs. | `warcraft-ii/docs/design/`, `warcraft-ii/content/assets/`, `warcraft-ii/content/catalogs/` |

Один из программистов каждую неделю выполняет роль технического ревьюера по своей зоне. Ревью не означает переписывание за автора: тимлид проверяет, что задача не ломает архитектуру порта, не обходит `WarcraftCommand`, не кладет игровую логику в UI/Presentation и не создает лишнюю систему вместо переноса механики.

## Шкала задач

Оценка в промптах нужна не для красоты, а чтобы студент понимал реальный размер AI-assisted задачи. Один промпт - это один осмысленный цикл: постановка ИИ, чтение результата, локальная правка или проверка. Если задача требует больше 18 промптов, ее нужно делить.

| Размер | Промптов | Когда применять |
| --- | ---: | --- |
| XS | 1-2 | Малый документ, правка каталога, один тест-кейс, один UI state. |
| S | 3-5 | Небольшой модуль, один обработчик команды, один компонент HUD, один ассет-пак. |
| M | 6-10 | Вертикальная функция из runtime + tests + presentation hook. |
| L | 11-18 | Несколько связанных модулей, например build/train или fog + minimap. |
| XL | 19+ | Нельзя брать как одну задачу. Делить на несколько карточек. |

| Review | Значение |
| --- | --- |
| R0 | Тимлид не нужен, достаточно самопроверки и peer check. |
| R1 | Быстрое ревью тимлида после реализации. |
| R2 | Обязательное ревью до merge, потому что задача касается архитектуры, runtime state, производительности или импорта ассетов. |
| R3 | Пошаговое ревью: сначала интерфейс/контракт, потом реализация, потом тесты. Задачу нужно дробить, если она распухает. |

| Риск | Значение |
| --- | --- |
| Low | Изолированная задача, мало связей. |
| Medium | Есть интеграция с соседним слоем или каталогами. |
| High | Может сломать core loop, производительность, сохранения или сценарии. |
| Critical | Нельзя делать без предварительного дизайна решения и отдельного ревью. |

## Что считаем портом за 8 недель

За 8 недель команда должна получить не "всю Warcraft II", а честный вертикальный срез порта, показывающий перенос основных систем:

- один playable сценарий уровня Human mission 01-like;
- fixed-step runtime loop;
- выбор юнитов, команды move/harvest/build/train/attack;
- ресурсы, здания, производство юнитов;
- combat, fog of war, условия победы/поражения;
- простая AI-волна или scripted opponent;
- HUD, command panel, briefing/objectives/result screen;
- новые ассеты вместо оригинальных, но сделанные по референсам;
- измеримые performance checks и список известных ограничений.

Не входит в 8 недель:

- полный набор кампаний;
- мультиплеер;
- полноценный редактор карт;
- перенос всех рас, всех юнитов и всех апгрейдов;
- полная совместимость со всеми Lua/Wargus-скриптами;
- финальный коммерческий polish всех ассетов.

## Управление логом задач

Каждая рабочая карточка должна иметь ID:

- `S01-P1-001` - sprint 01, programmer 1, первая задача;
- `S04-D-002` - sprint 04, designer, вторая задача;
- `S08-P4-003` - sprint 08, programmer 4, третья задача.

Для каждой карточки фиксируются:

- исполнитель;
- задача и результат;
- ссылка на механику из `docs/gameplay/mechanics_matrix.md` или на design/reference документ;
- оценка в промптах;
- риск;
- уровень ревью;
- тест, manual check или performance check;
- факт выполнения в отчете спринта.

Актуальный статус задач ведется в `warcraft-ii/docs/sprints/sprint_XX_report.md`. Этот документ задает план и исходный backlog, а sprint report фиксирует, что реально было сделано.

## Еженедельный ритм

| День | Что происходит |
| --- | --- |
| Понедельник | Команда берет карточки недели, уточняет acceptance criteria, дизайнер собирает reference board. |
| Вторник-среда | Основная реализация. Для задач R2/R3 сначала согласуется контракт, затем код. |
| Четверг | Интеграция, smoke test, обновление docs, performance spot checks. |
| Пятница | Демо, обновление sprint report, фиксация ограничений и перенос хвостов. |

## Sprint 01 - каркас порта и правила работы

Цель недели: проект запускается, есть пустой матч на fixed-step runtime loop, понятна вертикальная структура порта, дизайнер выдает первый референсный пакет HUD и ассетов первого среза.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S01-P1-001 | P1 | Собрать минимальный `WarcraftRuntime` с fixed-step tick, command queue и пустым `RuntimeSnapshot`. | Runtime тикает без Godot Node-логики, тест фиксирует стабильный tick. | `architecture/architecture.md`, `mechanics_matrix.md` SYS rows | 6-10 | High | R2 |
| S01-P2-001 | P2 | Подключить пустую карту, камеру, render shell и placeholder layer для сущностей. | Demo match показывает карту-заглушку и камеру без игровой логики в Presentation. | `visual_integration.md`, `input/touch_ux_spec.md` | 6-10 | Medium | R1 |
| S01-P3-001 | P3 | Собрать маршрут App -> Main Menu -> Demo Match -> HUD shell. | Можно открыть демо-сценарий из меню, HUD пока показывает пустые панели. | `warcraft-ii/README.md`, UI docs | 6-10 | Medium | R1 |
| S01-P4-001 | P4 | Подготовить content skeleton, import report template и smoke-test checklist. | Есть папки каталогов, шаблон отчета импорта и ручной smoke test для недели. | `content/content_pipeline.md`, `testing/test_strategy.md` | 6-10 | Medium | R2 |
| S01-D-001 | D | Собрать reference board первого HUD: viewport, minimap, command panel, resource bar, selection panel. | В design handoff лежат screenshots/crops и список target elements. | `design/reference_packs/`, локальная Warcraft II/Wargus reference-only база | 3-5 | Medium | R1 |
| S01-D-002 | D | Сформировать asset inventory вертикального среза. | Таблица: UI, icons, terrain, units, buildings, effects, audio, briefing screens. | `asset_reference_and_integration.md` | 3-5 | Low | R1 |

Definition of Done:

- проект открывался в Godot 4.4;
- demo route запускался;
- runtime tick был покрыт тестом или ручным логом;
- дизайнерские референсы были сохранены как reference-only материалы;
- sprint report содержал реальные проверки и ограничения.

## Sprint 02 - состояние сущностей и UI-контракт

Цель недели: в runtime появляется базовая модель сущностей и команд, а UI и Presentation получают данные только через snapshot/view data.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S02-P1-001 | P1 | Ввести `EntityId`, unit/building/resource storages, `WarcraftCommand` и command validation. | Сущности живут в data stores, команды не меняют состояние напрямую из UI. | `architecture_details.md`, `mechanics_matrix.md` CMD/UNIT rows | 8-12 | High | R2 |
| S02-P2-001 | P2 | Сделать selection intent, click/touch adapter и синхронизацию выделения через snapshot. | Игрок может выделить placeholder entity, Presentation не хранит gameplay state. | `input/touch_ux_spec.md`, `visual_integration.md` | 6-10 | Medium | R1 |
| S02-P3-001 | P3 | Собрать HUD data binding: resources, selected unit, command buttons как ViewData. | HUD умеет показывать пустые/disabled states по данным runtime. | `visual_integration.md` | 6-10 | Medium | R1 |
| S02-P4-001 | P4 | Создать первые catalogs и validation script для unit/building/button definitions. | Неверный catalog ломается в проверке, а не в рантайме. | `content/content_pipeline.md`, Wargus metadata | 6-10 | Medium | R2 |
| S02-D-001 | D | Отрисовать HUD component kit по референсам: panels, slots, button states, tooltip frame. | Экспортированы новые PNG/WebP UI-компоненты и спецификация размеров. | `asset_reference_and_integration.md`, S01-D-001 | 6-10 | Medium | R1 |
| S02-D-002 | D | Подготовить command icon style sheet. | Есть 6-10 тестовых иконок states: normal/hover/pressed/disabled. | Warcraft II button refs, Wargus button names | 3-5 | Low | R1 |

Definition of Done:

- все действия игрока шли через `WarcraftCommand`;
- HUD не менял runtime state;
- catalog validation запускался;
- designer handoff содержал размеры, states и target paths;
- sprint report обновил статус задач.

## Sprint 03 - карта, выбор и перемещение

Цель недели: первый интерактивный gameplay loop - карта, выделение юнита, команда move, визуальное движение.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S03-P1-001 | P1 | Реализовать `OrderMove`, простую grid/path service и movement tick. | Юнит детерминированно перемещается по карте, есть runtime tests. | `mechanics_matrix.md` MOVE/PATH rows, Wargus movement refs | 8-12 | High | R2 |
| S03-P2-001 | P2 | Подключить map renderer, selection ring, movement interpolation и camera bounds. | На экране виден движущийся юнит-заглушка, камера не выходит за карту. | `visual_integration.md` | 8-12 | Medium | R1 |
| S03-P3-001 | P3 | Связать command panel с move command, hotkey/click states и error feedback. | UI показывает доступность команды и ошибку при невозможной цели. | `mechanics_matrix.md` CMD rows | 6-10 | Medium | R1 |
| S03-P4-001 | P4 | Подготовить map/content import report: tiles, passability, start positions, resources. | Есть report по первой карте и тест passability. | Wargus map/script refs, `content_pipeline.md` | 6-10 | Medium | R2 |
| S03-D-001 | D | Сделать terrain reference board и первый tileset package. | Есть новые terrain tiles, transitions и спецификация TileSet. | Original terrain screenshots, Wargus tileset names | 8-12 | Medium | R1 |
| S03-D-002 | D | Подготовить unit placeholder spritesheet spec для Peasant/Footman scale. | Согласованы frame size, pivot, directions и states. | `data_driven_animation_system.md` | 3-5 | Low | R1 |

Definition of Done:

- move работал через runtime order;
- визуальное движение было производным от snapshot;
- passability имела тест;
- tileset не был одной большой картинкой;
- performance spot check зафиксировал FPS на demo map.

## Sprint 04 - экономика: сбор и возврат ресурсов

Цель недели: рабочий цикл Peasant -> Gold Mine/Forest -> Town Hall -> ресурсы в HUD.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S04-P1-001 | P1 | Реализовать `OrderHarvest`, carry resource state, return/drop-off и resource storage. | Worker собирает и возвращает ресурс, баланс проверяется тестами. | `mechanics_matrix.md` ECON rows, Wargus economy refs | 11-18 | High | R2 |
| S04-P2-001 | P2 | Подключить визуальные states worker/resource node/drop-off и minimap resource markers. | Игрок видит добычу, перенос и возврат ресурса без logic в Presentation. | `visual_integration.md` | 6-10 | Medium | R1 |
| S04-P3-001 | P3 | Сделать resource HUD, messages и disabled command reasons для economy. | HUD обновляет Gold/Lumber/Oil/Food, показывает ошибки команд. | Warcraft II HUD refs | 6-10 | Medium | R1 |
| S04-P4-001 | P4 | Добавить catalogs для Peasant, Town Hall, Gold Mine, Forest и economy regression tests. | Data-driven параметры ресурсов не зашиты в UI. | Wargus unit/building/script refs | 8-12 | High | R2 |
| S04-D-001 | D | Подготовить новые ассеты Peasant, Town Hall, Gold Mine, Forest по референсам. | Экспортированы spritesheets/tiles с pivots и state sheet для sprite banks. | `asset_reference_and_integration.md`, original/Wargus refs | 11-18 | Medium | R1 |
| S04-D-002 | D | Подготовить audio brief для resource feedback. | Описаны нужные UI click, acknowledgement, deposit feedback sounds. | Warcraft II audio refs, no original audio commit | 3-5 | Low | R1 |

Definition of Done:

- economy loop работал в demo;
- значения ресурсов были runtime truth, а не UI mock;
- новые ассеты имели reference board и target paths;
- проверка производительности фиксировала число workers/resources.

## Sprint 05 - строительство и производство юнитов

Цель недели: игрок строит здание, после завершения тренирует боевого юнита.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S05-P1-001 | P1 | Реализовать `OrderBuild`: placement validation, cost, construction progress, cancel. | Здание строится детерминированно, ресурсы списываются корректно. | `mechanics_matrix.md` BUILD rows | 11-18 | High | R2 |
| S05-P1-002 | P1 | Реализовать `OrderTrain` и production queue для Barracks. | Barracks производит Footman, tests фиксируют queue/progress. | `mechanics_matrix.md` TRAIN rows | 8-12 | High | R2 |
| S05-P2-001 | P2 | Сделать placement ghost, construction visual states и rally/queue visual hooks. | Игрок видит valid/invalid placement и стадии строительства. | `visual_integration.md` | 8-12 | Medium | R1 |
| S05-P3-001 | P3 | Собрать build/train UI flow: command panel, queue, progress, hotkeys. | HUD управляет build/train через команды, без прямого state mutation. | Warcraft II command panel refs | 8-12 | Medium | R1 |
| S05-P4-001 | P4 | Расширить catalogs зданиями Farm/Barracks/Footman и добавить content validation. | Параметры cost/time/commands берутся из каталогов. | Wargus unit/button refs | 6-10 | Medium | R2 |
| S05-D-001 | D | Подготовить ассеты Farm, Barracks, Footman, construction stages и icons. | Новый visual pack готов к подключению в catalogs/sprite bank. | Original/Wargus refs, `data_driven_animation_system.md` | 11-18 | Medium | R1 |

Definition of Done:

- build/train loop работал в demo;
- placement не ломал passability;
- UI не обходил command queue;
- все cost/time/commands были data-driven;
- ассеты имели frame specs и проверку в сцене предпросмотра.

## Sprint 06 - бой, туман войны и условия победы

Цель недели: юниты атакуют, видимость ограничена fog of war, сценарий может завершиться победой или поражением.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S06-P1-001 | P1 | Реализовать `OrderAttack`, target acquisition, damage, death, corpse/removal policy. | Footman атакует цель, combat tests покрывают damage и death. | `mechanics_matrix.md` COMBAT rows | 11-18 | High | R2 |
| S06-P1-002 | P1 | Добавить fog/visibility runtime model для игроков. | Snapshot отдает видимость без раскрытия скрытых сущностей. | `mechanics_matrix.md` FOG rows | 8-12 | High | R2 |
| S06-P2-001 | P2 | Подключить fog renderer, combat effects, hit flashes, death animation hooks. | Игрок видит видимую область, удары и смерть сущностей. | `visual_integration.md` | 8-12 | Medium | R1 |
| S06-P3-001 | P3 | Сделать objective tracker и result screen для victory/defeat. | Сценарий показывает победу/поражение и кнопку возврата. | `game/scenario/`, Warcraft II mission refs | 6-10 | Medium | R1 |
| S06-P4-001 | P4 | Ввести combat/fog performance checks и regression scenario. | Есть сценарий с N entities, FPS/tick time фиксируются в отчете. | `performance/performance_budgets.md` | 8-12 | High | R2 |
| S06-D-001 | D | Подготовить combat effects, selection feedback, hit/death audio brief и result screen refs. | Есть новые effects sheets, UI frames и sound list. | Original/Wargus refs, no original audio commit | 8-12 | Medium | R1 |

Definition of Done:

- attack/death работали через runtime;
- fog не раскрывал скрытые данные в UI;
- result screen запускался от сценарного условия;
- performance check был записан в sprint report.

## Sprint 07 - сценарий, AI и сохранения

Цель недели: вертикальный срез становится миссией: briefing, objectives, scripted AI, save/load базового состояния.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S07-P1-001 | P1 | Реализовать простые AI directives: gather, build/train subset или attack wave. | AI действует через те же `WarcraftCommand`, что игрок. | `mechanics_matrix.md` AI rows, Wargus AI refs | 11-18 | High | R2 |
| S07-P2-001 | P2 | Проверить восстановление Presentation после load/snapshot reset. | После загрузки нет зависших selection/effects/camera states. | `visual_integration.md`, save docs | 6-10 | Medium | R1 |
| S07-P3-001 | P3 | Собрать mission briefing, objectives, scripted triggers и campaign progress. | Demo mission имеет вход, цели, победу и переход назад в меню. | `game/scenario/`, `game/campaign/` | 11-18 | High | R2 |
| S07-P4-001 | P4 | Реализовать `RuntimeSnapshot` save/load subset и content compatibility checks. | Можно сохранить и загрузить состояние demo mission. | `persistence/save_format.md` | 11-18 | High | R2 |
| S07-D-001 | D | Подготовить briefing screen, objective icons, AI/enemy visual placeholders и audio mix list. | Есть briefing assets и список звуков для событий миссии. | Original mission refs, Wargus script names | 8-12 | Medium | R1 |
| S07-D-002 | D | Провести визуальный review всех ассетов vertical slice. | Список polish-задач S08 с приоритетом: gameplay clarity -> UI -> effects. | `asset_reference_and_integration.md` | 3-5 | Low | R1 |

Definition of Done:

- mission flow запускался от меню до результата;
- AI не менял runtime state напрямую;
- save/load не требовал Presentation state;
- briefing и objectives использовали новые ассеты;
- sprint report фиксировал оставшиеся несоответствия порту.

## Sprint 08 - стабилизация, производительность и сдача

Цель недели: убрать расхождения vertical slice, стабилизировать производительность, подготовить финальное демо и документацию.

| ID | Исполнитель | Задача | Результат | Источник | Промпты | Риск | TL |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| S08-P1-001 | P1 | Закрыть runtime parity gaps по matrix rows vertical slice. | Для каждой перенесенной механики есть статус, тест или limitation. | `mechanics_matrix.md` | 8-12 | High | R2 |
| S08-P2-001 | P2 | Оптимизировать render sync, fog, effects и camera/mobile profile. | FPS/tick budget попадает в целевые рамки или ограничения описаны. | `performance/performance_budgets.md` | 8-12 | High | R2 |
| S08-P3-001 | P3 | Полировать UX финального demo: menu, HUD, result, error states, accessibility basics. | Demo можно показать без debug-ручек и непонятных экранов. | UI refs, test strategy | 6-10 | Medium | R1 |
| S08-P4-001 | P4 | Собрать regression pack, финальный sprint report, build notes и GitVerse links. | Есть список проверок, сборочных шагов, известных ограничений и материалов. | `testing/test_strategy.md`, `season_2026_alignment.md` | 8-12 | High | R2 |
| S08-D-001 | D | Финальный polish ассетов: атласы, контраст, читаемость, audio levels, missing icons. | Все ассеты vertical slice лежат в правильных папках и каталогах. | `asset_reference_and_integration.md` | 8-12 | Medium | R1 |
| S08-ALL-001 | All | Финальный smoke test и запись демо. | Команда подтверждает, что демо запускается из чистого состояния. | `testing/test_strategy.md` | 3-5 на человека | High | R2 |

Definition of Done:

- проект открывался в Godot 4.4 из чистого checkout;
- демо-миссия проходилась от меню до victory/defeat;
- performance checks были записаны;
- документация, sprint reports и limitations были актуальны;
- оригинальные ассеты Warcraft II не были закоммичены;
- все новые ассеты имели reference board и integration path.

## Как дизайнер получает задачи

Дизайнер не придумывает элементы "с нуля". Любая задача дизайнера должна начинаться с brief, где указано:

- gameplay/mechanics row или UI/screen, которому нужен ассет;
- reference board: full screenshot, crop конкретного элемента, заметки по состояниям;
- target folder в `content/assets/`;
- формат, размер, pivot, states или animation markers;
- кто из программистов подключает ассет;
- какой manual check подтверждает, что ассет внедрен.

Источники задач дизайнера:

1. Таблицы sprint plan выше.
2. `warcraft-ii/docs/gameplay/mechanics_matrix.md` - какие механики и состояния нужно показать.
3. `warcraft-ii/docs/design/asset_reference_and_integration.md` - как оформлять brief, куда класть результат и как программист подключает ассет.
4. `warcraft-ii/docs/design/reference_packs/` - подготовленные reference-only материалы.
5. Локальная установка Warcraft II и Wargus - только как reference-only источник, без коммита оригинальных ассетов.
6. `warcraft-ii/content/imported/*_reference_report.md` - отчеты импорта, если они уже подготовлены P4.

Минимальный набор дизайнерских выдач каждую неделю:

- reference board;
- список ассетов и states;
- exported runtime-ready files;
- integration notes;
- список спорных мест и недостающих референсов.

## Как программисты внедряют ассеты

Базовое правило: новая графика, звук и видео подключаются через каталоги, `.tres`, sprite banks, audio banks, UI scenes и presentation definitions. Нельзя вручную создавать отдельную gameplay scene на каждый юнит или здание, если достаточно data-driven ресурса.

| Тип | Куда класть | Как подключать |
| --- | --- | --- |
| UI panels/buttons/icons | `content/assets/textures/ui/` | Через UI scenes/components, UI atlas и button/icon ids в каталогах. |
| Unit spritesheets | `content/assets/textures/units/` | Через `content/assets/animations/*_sprite_bank.tres`, `content/catalogs/sprite_banks.tres` и `unit_visuals.tres`; entity view читает visual id. |
| Building spritesheets | `content/assets/textures/buildings/` | Через `building_sprite_bank.tres`, `building_visuals.tres` и construction states. |
| Effects/projectiles | `content/assets/textures/effects/` | Через effect catalog и presentation event. |
| Terrain tiles | `content/assets/textures/terrain/`, `content/assets/tilesets/` | Через TileSet/TileMapLayer, passability отдельно в map data. |
| Audio | `content/assets/audio/sfx/`, `content/assets/audio/voice/`, `content/assets/audio/music/` | Через `content/catalogs/audio_banks.tres` и event mapping. |
| Briefing/video | `content/assets/textures/ui/`, `content/assets/textures/portraits/`, при необходимости `content/assets/video/` | Через scenario/campaign data и UI screen. |
| Catalogs | `content/catalogs/` | `.tres`/data resources, валидируются P4. |

Подробный контракт хранится в `warcraft-ii/docs/design/asset_reference_and_integration.md`.

## Подготовительный этап перед первой неделей

Перед тем как команда начнет sprint 01, нужно сделать следующее:

1. Назначить реальные имена на роли P1-P4 и D.
2. Проверить, что у всех открывается Godot 4.4 и проект стартует.
3. Убедиться, что у всех есть локальный reference-only доступ к Wargus и/или установленной Warcraft II, но оригинальные ассеты не попадают в Git.
4. Создать или актуализировать `content/imported/*_reference_report.md` для UI, units, buildings, tilesets, sounds.
5. Подготовить первый дизайнерский handoff по HUD и asset inventory.
6. Согласовать, где ведется task log: sprint report, issue tracker или оба. В любом случае ID задач должны совпадать с этим планом.
7. Пройти smoke test из `docs/testing/test_strategy.md` на чистом checkout.
8. Зафиксировать performance baseline: пустая карта, N placeholder entities, tick time, FPS.
9. Подготовить шаблон review checklist для R1/R2/R3 задач.

## Признаки, что план начал расходиться с архитектурой

План нужно пересматривать сразу, если появляется один из признаков:

- UI или Presentation меняют состояние матча напрямую;
- механика добавляется без строки в `mechanics_matrix.md`;
- новая система создается вместо переноса существующего правила Warcraft II/Wargus;
- ассет подключается как отдельная gameplay scene вместо catalog/sprite bank/TileSet;
- задача растет выше 18 промптов и не делится;
- performance check откладывается "на потом" после внедрения тяжелой механики;
- дизайнер получает формулировку "нарисуй как-нибудь", без reference board.
