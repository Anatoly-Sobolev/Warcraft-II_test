# Warcraft II на Godot

Проект — порт Warcraft II на Godot 4.4 с прицелом на слабые ПК и ОС Аврора. Механики, лор, сюжетная линия и миссии должны воспроизводить Warcraft II; новым будет визуальное оформление.

Цель проекта — gameplay-equivalent порт, а не byte-perfect реконструкция. Отдельные технические отличия допустимы, особенно из-за мобильной платформы, если сохраняются ключевой игровой цикл, основные механики и сюжет.

Основной Godot-проект находится в [`warcraft-ii/`](warcraft-ii/). Архитектурные решения описаны в [`architecture.md`](warcraft-ii/docs/architecture/architecture.md) и [`architecture_details.md`](warcraft-ii/docs/architecture/architecture_details.md).

## Быстрый старт

1. Установить Godot 4.4.
2. Открыть проект: [`warcraft-ii/project.godot`](warcraft-ii/project.godot).
3. Запустить основную сцену проекта. Если main scene еще не назначена в настройках Godot, открыть и запустить `res://app/app.tscn`.
4. Перед сдачей спринта проверить запуск по чеклисту из [`warcraft-ii/docs/evaluation/season_2026_alignment.md`](warcraft-ii/docs/evaluation/season_2026_alignment.md).

## Главные документы

| Документ | Зачем нужен |
| --- | --- |
| [`AGENTS.md`](AGENTS.md) | Правила для ИИ-агентов и разработчиков перед любыми изменениями. |
| [`warcraft-ii/docs/development/onboarding.md`](warcraft-ii/docs/development/onboarding.md) | Короткий вход для нового разработчика: принципы, модули, ссылки. |
| [`warcraft-ii/docs/architecture/architecture.md`](warcraft-ii/docs/architecture/architecture.md) | Короткое объяснение архитектуры и ключевых запретов. |
| [`warcraft-ii/docs/architecture/architecture_details.md`](warcraft-ii/docs/architecture/architecture_details.md) | Рабочая детализация модулей, папок и подходов. |
| [`warcraft-ii/README.md`](warcraft-ii/README.md) | Карта Godot-проекта и ссылки на модули. |
| [`warcraft-ii/docs/README.md`](warcraft-ii/docs/README.md) | Индекс проектной документации. |
| [`warcraft-ii/docs/gameplay/mechanics_matrix.md`](warcraft-ii/docs/gameplay/mechanics_matrix.md) | Матрица механик Warcraft II и источников. |
| [`warcraft-ii/docs/testing/test_strategy.md`](warcraft-ii/docs/testing/test_strategy.md) | Тест-план первого спринта и правила тест-кейсов для следующих. |
| [`warcraft-ii/docs/product/user_story_map.md`](warcraft-ii/docs/product/user_story_map.md) | User Story Map для продуктовой оценки. |
| [`warcraft-ii/docs/sprints/sprint_report_template.md`](warcraft-ii/docs/sprints/sprint_report_template.md) | Шаблон отчета спринта. |

## Правило сдачи

Каждый спринт должен оставлять в GitVerse полный след:

- код и контент проекта;
- актуальный README с инструкцией запуска;
- отчет спринта в `warcraft-ii/docs/sprints/`;
- тест-план или тест-кейсы;
- список известных ограничений;
- проверенный запуск демо.

Если демо не запускается или ссылки не открываются, остальные сильные стороны проекта не помогут при оценивании. Поэтому запускаемость и понятная инструкция запуска имеют высший приоритет.
