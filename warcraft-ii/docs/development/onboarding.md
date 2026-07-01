# Onboarding первого дня

Короткий вход для участника команды. Цель - за 30 минут понять, что происходит в
проекте, какие правила нельзя ломать, что читать именно своей роли и куда идти
за деталями.

## Что это за проект

Мы делаем порт Warcraft II на Godot 4.4 для слабых ПК и ОС Аврора.
Визуальный дизайн будет новым, но игровой цикл, основные механики, лор, сюжетная
линия и миссии должны воспроизводить Warcraft II. Источники механик фиксируются в
[`mechanics_matrix.md`](../gameplay/mechanics_matrix.md).

Цель - gameplay-equivalent порт, а не byte-perfect реконструкция. Отдельные
технические отличия допустимы, потому что проект адаптируется под ОС Аврора и
мобильный формат.

## Маршрут первого дня

1. Открой [`README.md`](../../../README.md) и проверь, что Godot-проект
   запускается.
2. Прочитай [`AGENTS.md`](../../../AGENTS.md): это обязательные правила для ИИ,
   разработчиков и документов.
3. Прочитай этот onboarding до конца и выбери маршрут своей роли ниже.
4. Открой актуальный sprint report в `docs/sprints/` и найди задачу недели.
5. Перед задачей открой [`workflow.md`](workflow.md): он описывает, как довести
   одну задачу от reference до проверки.
6. Если задача касается механик, карт, UI, ассетов или reference checks,
   проверь [`pre_start_checklist.md`](../porting/pre_start_checklist.md) и
   [`local_reference_setup.md`](../porting/local_reference_setup.md).

Не нужно читать всю папку `docs/` подряд. Сначала прочитай общий минимум, потом
документы своей роли и README модуля, который реально меняешь.

## Документы по ролям

| Кому | Читать обязательно | Открывать по задаче |
| --- | --- | --- |
| Все | [`README.md`](../../../README.md), [`AGENTS.md`](../../../AGENTS.md), этот onboarding, [`workflow.md`](workflow.md) | Актуальный sprint report, README изменяемого модуля |
| P1-P4, программисты | [`architecture.md`](../architecture/architecture.md), [`architecture_details.md`](../architecture/architecture_details.md), [`mechanics_matrix.md`](../gameplay/mechanics_matrix.md) | [`warcraft2_logic_porting_plan.md`](../porting/warcraft2_logic_porting_plan.md), [`wargus_runtime_mapping.md`](../porting/wargus_runtime_mapping.md), module README |
| D, дизайнер | [`asset_reference_and_integration.md`](../design/asset_reference_and_integration.md), [`visual_integration.md`](../design/visual_integration.md), [`local_reference_setup.md`](../porting/local_reference_setup.md) | `docs/design/reference_packs/`, `docs/design/tasks/`, designer handoff |
| Q, тестировщик | [`test_strategy.md`](../testing/test_strategy.md), [`bug_report_template.md`](bug_report_template.md), sprint report | [`markdown_link_check.md`](markdown_link_check.md), reference reports, affected module README |
| M, менеджер | [`eight_week_ai_delivery_plan.md`](../product/eight_week_ai_delivery_plan.md), [`season_2026_alignment.md`](../evaluation/season_2026_alignment.md), sprint report | [`user_story_map.md`](../product/user_story_map.md), known issues, QA evidence |

## Типы документов

| Тип | Зачем нужен |
| --- | --- |
| `README.md` | Как открыть проект и где главные входы. |
| `AGENTS.md` | Жесткие правила для изменений и ИИ. |
| `onboarding.md` | Быстрый маршрут первого дня и навигация по документам. |
| `workflow.md` | Как выполнить одну задачу в порте Warcraft II. |
| `pre_start_checklist.md` | Что закрыть перед переносом механики или reference-heavy задачей. |
| `eight_week_ai_delivery_plan.md` | Предложение менеджеру и план недельного scope. |
| `docs/sprints/sprint_XX_report.md` | Что реально делаем и проверяем в текущем спринте. |

## Что скачать перед началом

Для обычного запуска Godot-проекта ничего из оригинальной Warcraft II скачивать
не нужно: проект должен открываться без `external/`, Wargus и установленной игры.

Если ты работаешь с переносом механик, карт, UI, ассетов, дизайном или reference
checks, нужны локальные reference-файлы:

1. Wargus source: [Wargus/wargus](https://github.com/Wargus/wargus).

   ```powershell
   git clone https://github.com/Wargus/wargus.git <local Wargus checkout>
   ```

2. Установочные файлы Warcraft II из командной папки:
   [Warcraft II / Облако Mail](https://cloud.mail.ru/public/U1db/ujYBepiMq).
   Скачай их только в локальную неотслеживаемую папку, например
   `external/installers/`, затем установи или распакуй игру локально.
3. Если в проекте уже подготовлен `external/` с reference materials, для
   ежедневной работы обычно достаточно его. Установленная игра нужна только для
   новых скриншотов, переизвлечения файлов или спорной ручной проверки.
4. Реальные абсолютные пути запиши только в приватный
   `warcraft-ii/docs/local_reference_paths.local.md` или локальные переменные.
   Этот файл игнорируется Git.

Нельзя коммитить установщики, распакованную игру, оригинальные sprites/sounds,
video, maps и личные абсолютные пути. В Git попадают только наши reports,
schemas, catalogs, tests, docs и новые разрешенные ассеты. Подробности:
[`local_reference_setup.md`](../porting/local_reference_setup.md).

## Главная архитектурная идея

```text
Input / AI / Scenario
        |
        v
   WarcraftCommand
        |
        v
    Warcraft Runtime  ---> events / dirty buffers / ViewData
        |                              |
        v                              v
 authoritative state             Presentation / UI
```

Warcraft Runtime - единственный источник правды о матче. Presentation и UI только
показывают подготовленные данные.

## Правила, которые нельзя ломать

- Игровая логика живет в `game/warcraft_runtime/`.
- Юнит или здание в логике - это `UnitHandle` и данные в хранилищах, а не Godot Node.
- Игрок, AI и сценарий меняют мир только через `WarcraftCommand`.
- UI, Presentation, Scenario и Input не меняют Warcraft Runtime напрямую.
- Warcraft Runtime не зависит от сцен, спрайтов, звука, UI, файловой системы и платформы.
- Новая Warcraft II-механика должна иметь строку или источник в `mechanics_matrix.md`.
- Сначала тест или ручная проверка, потом отчет о готовности.

## Как взять первую механику

Бери маленький вертикальный перенос, а не большую систему:

| Не так | Так |
| --- | --- |
| Сделать экономику. | Перенести `harvest gold` для Peasant: source, command, order, state, HUD check. |
| Сделать боевую систему. | Перенести Footman attack target: cooldown, damage, death check. |
| Сделать AI. | Перенести одну Wargus AI directive или одну scripted attack wave. |
| Сделать импорт Warcraft II. | Подготовить один reference report: units/buttons/map/mission. |
| Сделать туман войны. | Перенести visibility grid для одного игрока и проверить UI не видит скрытые units. |

Рабочий коридор:

```text
mechanics_matrix row -> Wargus/Warcraft source -> command/order/rule -> state
-> test/manual check -> UI/Presentation hook только если нужен
```

## Навигатор по модулям

| Что нужно сделать | Куда идти |
| --- | --- |
| Запуск приложения, экраны, routing | [`app/`](../../app/README.md) |
| Сборка одного матча | [`game/match/`](../../game/match/README.md) |
| Ввод, выбор, жесты, команды игрока | [`game/input/`](../../game/input/README.md) |
| Правила RTS, бой, экономика, движение, AI, туман | [`game/warcraft_runtime/`](../../game/warcraft_runtime/README.md) |
| Миссии, цели, триггеры, обучение | [`game/scenario/`](../../game/scenario/README.md) |
| Спрайты, камера, туман на экране, звук матча | [`game/presentation/`](../../game/presentation/README.md) |
| HUD, меню, панели, overlay | [`ui/`](../../ui/README.md) |
| Сохранения, настройки, ресурсы, платформа | [`services/`](../../services/README.md) |
| Баланс, каталоги, карты, данные игры | [`content/`](../../content/README.md) |
| Unit/integration/performance проверки | [`tests/`](../../tests/README.md) |
| Отладочные overlay | [`debug/`](../../debug/README.md) |
| Инструменты вне runtime | [`tools/`](../../tools/README.md) |

## Если работаешь с ИИ

Используй шаблоны:

- [`ai_task_template.md`](ai_task_template.md) - задача для ИИ;
- [`sprint_task_template.md`](sprint_task_template.md) - задача спринта;
- [`bug_report_template.md`](bug_report_template.md) - баг-репорт.

Хорошая задача для ИИ всегда говорит:

- какой модуль меняется;
- какие файлы нельзя трогать;
- кто владеет состоянием;
- какой reference/source подтверждает поведение;
- какой тест или ручная проверка нужна;
- какой документ обновить.

## Перед сдачей изменения

Проверь:

1. Проект запускается по README или ограничение записано явно.
2. Демо-сценарий, затронутый задачей, повторяется.
3. Тест или ручной тест-кейс записан.
4. Документы обновлены.
5. Локальные ссылки проверены по [`markdown_link_check.md`](markdown_link_check.md).
6. В sprint report нет обещаний, которые нельзя запустить.

## Самая короткая памятка

Если сомневаешься, куда класть код: сначала открой
[`architecture_details.md`](../architecture/architecture_details.md), потом README
нужного модуля. Если меняется игровое правило - почти всегда это
`game/warcraft_runtime/`, вход через `WarcraftCommand`, проверка через test или
manual reference check.
