# Документация проекта

Эта папка хранит не только справку по модулям, но и документы, нужные для управления спринтами, оценки, тестирования и соответствия Warcraft II.

## С чего начинать

| Документ | Назначение |
| --- | --- |
| [`../../README.md`](../../README.md) | Входная точка репозитория и быстрый запуск. |
| [`../../AGENTS.md`](../../AGENTS.md) | Правила для ИИ-агентов и разработчиков. |
| [`development/onboarding.md`](development/onboarding.md) | Короткий вход для нового разработчика: принципы, модули, ссылки. |
| [`architecture/architecture.md`](architecture/architecture.md) | Короткая архитектура проекта. |
| [`architecture/architecture_details.md`](architecture/architecture_details.md) | Подробная архитектура и рабочие правила. |

## Документы по оценке и спринтам

| Документ | Что закрывает |
| --- | --- |
| [`evaluation/grading_rules_2026.md`](evaluation/grading_rules_2026.md) | Исходные правила оценивания сезона 2026, перенесенные в Markdown. |
| [`evaluation/season_2026_alignment.md`](evaluation/season_2026_alignment.md) | Соответствие требованиям сезона 2026 и чеклист против 0 баллов. |
| [`testing/test_strategy.md`](testing/test_strategy.md) | Тест-план первого спринта и правила тест-кейсов для спринтов 2-8. |
| [`product/user_story_map.md`](product/user_story_map.md) | User Story Map для продуктовой оценки. |
| [`product/eight_week_ai_delivery_plan.md`](product/eight_week_ai_delivery_plan.md) | 8-недельный план задач, USM и оценка рисков для AI-assisted разработки. |
| [`sprints/sprint_report_template.md`](sprints/sprint_report_template.md) | Шаблон отчета каждого спринта. |
| [`sprints/sprint_01_report.md`](sprints/sprint_01_report.md) | Стартовый отчет первого спринта. |
| [`sprints/sprint_02_report.md`](sprints/sprint_02_report.md) - [`sprints/sprint_08_report.md`](sprints/sprint_08_report.md) | Рабочие заготовки отчетов спринтов 2-8. |

## Документы по процессу разработки

| Документ | Что фиксирует |
| --- | --- |
| [`development/onboarding.md`](development/onboarding.md) | Быстрый маршрут входа в проект для человека и ИИ. |
| [`development/workflow.md`](development/workflow.md) | Как брать задачу, работать с ИИ, проверять и сдавать результат. |
| [`development/prompting_rules.md`](development/prompting_rules.md) | Правила постановки задач ИИ и антипримеры. |
| [`development/ai_task_template.md`](development/ai_task_template.md) | Шаблон задачи для AI-assisted разработки. |
| [`development/sprint_task_template.md`](development/sprint_task_template.md) | Шаблон задачи внутри недельного спринта. |
| [`development/bug_report_template.md`](development/bug_report_template.md) | Шаблон баг-репорта. |
| [`development/repo_structure.md`](development/repo_structure.md) | Карта репозитория и правила размещения новых файлов. |
| [`development/markdown_link_check.md`](development/markdown_link_check.md) | Ручная процедура проверки локальных Markdown-ссылок. |

## Документы по игре

| Документ | Что фиксирует |
| --- | --- |
| [`gameplay/mechanics_matrix.md`](gameplay/mechanics_matrix.md) | Матрица механик Warcraft II, источников, статусов и тестов. |
| [`gameplay/gameplay_spec.md`](gameplay/gameplay_spec.md) | Будущая игровая спецификация на основе матрицы механик. |
| [`design/visual_integration.md`](design/visual_integration.md) | Правила интеграции дизайна, UI, presentation, ассетов и анимаций. |
| [`content/content_pipeline.md`](content/content_pipeline.md) | Будущий процесс подготовки контента и импорта данных. |
| [`input/touch_ux_spec.md`](input/touch_ux_spec.md) | Будущая спецификация сенсорного управления. |
| [`performance/target_device.md`](performance/target_device.md) | Будущее описание целевого слабого устройства. |
| [`performance/performance_budgets.md`](performance/performance_budgets.md) | Будущие бюджеты FPS, памяти и количества сущностей. |
| [`persistence/save_format.md`](persistence/save_format.md) | Будущая спецификация сохранений. |
| [`platform/aurora_build.md`](platform/aurora_build.md) | Будущая инструкция сборки под ОС Аврора. |

## Правило актуальности

Документ обновляется в том же изменении, которое меняет соответствующее поведение. Если код, тесты и документация расходятся, приоритет у работающего кода, а документ нужно исправить до сдачи спринта.
