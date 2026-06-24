# Документация проекта

Эта папка хранит не только справку по модулям, но и документы, нужные для управления спринтами, оценки, тестирования и соответствия Warcraft II.

## С чего начинать

| Документ | Назначение |
| --- | --- |
| [`../../README.md`](../../README.md) | Входная точка репозитория и быстрый запуск. |
| [`../../AGENTS.md`](../../AGENTS.md) | Правила для ИИ-агентов и разработчиков. |
| [`../../ARCHITECTURE.md`](../../ARCHITECTURE.md) | Короткая архитектура проекта. |
| [`../../ARCHITECTURE_DETAILS.md`](../../ARCHITECTURE_DETAILS.md) | Подробная архитектура и рабочие правила. |
| [`architecture/architecture.md`](architecture/architecture.md) | Локальный указатель на архитектурные документы. |

## Документы по оценке и спринтам

| Документ | Что закрывает |
| --- | --- |
| [`evaluation/season_2026_alignment.md`](evaluation/season_2026_alignment.md) | Соответствие требованиям сезона 2026 и чеклист против 0 баллов. |
| [`testing/test_strategy.md`](testing/test_strategy.md) | Тест-план первого спринта и правила тест-кейсов для спринтов 2-8. |
| [`product/user_story_map.md`](product/user_story_map.md) | User Story Map для продуктовой оценки. |
| [`sprints/sprint_report_template.md`](sprints/sprint_report_template.md) | Шаблон отчета каждого спринта. |
| [`sprints/sprint_01_report.md`](sprints/sprint_01_report.md) | Стартовый отчет первого спринта. |

## Документы по игре

| Документ | Что фиксирует |
| --- | --- |
| [`gameplay/mechanics_matrix.md`](gameplay/mechanics_matrix.md) | Матрица механик Warcraft II, источников, статусов и тестов. |
| [`gameplay/gameplay_spec.md`](gameplay/gameplay_spec.md) | Будущая игровая спецификация на основе матрицы механик. |
| [`content/content_pipeline.md`](content/content_pipeline.md) | Будущий процесс подготовки контента и импорта данных. |
| [`input/touch_ux_spec.md`](input/touch_ux_spec.md) | Будущая спецификация сенсорного управления. |
| [`performance/target_device.md`](performance/target_device.md) | Будущее описание целевого слабого устройства. |
| [`performance/performance_budgets.md`](performance/performance_budgets.md) | Будущие бюджеты FPS, памяти и количества сущностей. |
| [`persistence/save_format.md`](persistence/save_format.md) | Будущая спецификация сохранений. |
| [`platform/aurora_build.md`](platform/aurora_build.md) | Будущая инструкция сборки под ОС Аврора. |

## Правило актуальности

Документ обновляется в том же изменении, которое меняет соответствующее поведение. Если код, тесты и документация расходятся, приоритет у работающего кода, а документ нужно исправить до сдачи спринта.
