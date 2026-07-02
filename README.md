# Warcraft II на Godot

Проект — порт Warcraft II на Godot 4.4 для мобильных устройств на ОС «Аврора». Мы переносим
механики, темп, команды, кампании и миссии Warcraft II, используя Wargus/Stratagus
и локально установленную игру как reference. Это **порт с новыми ассетами**, а не
новая RTS “по мотивам”.

Цель проекта — gameplay-equivalent порт. Byte-perfect реконструкция не требуется,
но ключевые правила Warcraft II должны переноситься из источников, фиксироваться в
`mechanics_matrix.md` и проверяться test/reference cases.

Основной Godot-проект находится в [`warcraft-ii/`](warcraft-ii/). Архитектура
описана в [`architecture.md`](warcraft-ii/docs/architecture/architecture.md) и
[`architecture_details.md`](warcraft-ii/docs/architecture/architecture_details.md).

## Быстрый старт

1. Установить Godot 4.4.
2. Прочитать [`warcraft-ii/docs/development/onboarding.md`](warcraft-ii/docs/development/onboarding.md) -
   маршрут первого дня по ролям.
3. Открыть проект: [`warcraft-ii/project.godot`](warcraft-ii/project.godot).
4. Запустить основную сцену проекта. Если main scene еще не назначена, открыть и
   запустить `res://app/app.tscn`.
5. Перед сдачей пройти smoke test из
   [`warcraft-ii/docs/testing/test_strategy.md`](warcraft-ii/docs/testing/test_strategy.md).

## Главные документы

| Документ | Зачем нужен |
| --- | --- |
| [`AGENTS.md`](AGENTS.md) | Обязательные правила для ИИ-агентов и разработчиков. |
| [`warcraft-ii/docs/development/onboarding.md`](warcraft-ii/docs/development/onboarding.md) | Маршрут первого дня: что читать всем, что читать по ролям и что скачать для reference-задач. |
| [`warcraft-ii/docs/architecture/architecture.md`](warcraft-ii/docs/architecture/architecture.md) | Короткое объяснение архитектуры порта. |
| [`warcraft-ii/docs/architecture/architecture_details.md`](warcraft-ii/docs/architecture/architecture_details.md) | Рабочая структура модулей и правила размещения кода. |
| [`warcraft-ii/docs/porting/warcraft2_logic_porting_plan.md`](warcraft-ii/docs/porting/warcraft2_logic_porting_plan.md) | Как переносить механику из Warcraft II/Wargus. |
| [`warcraft-ii/docs/gameplay/mechanics_matrix.md`](warcraft-ii/docs/gameplay/mechanics_matrix.md) | Контрольный список механик и источников. |
| [`warcraft-ii/docs/testing/test_strategy.md`](warcraft-ii/docs/testing/test_strategy.md) | Формат проверок, reference tests и smoke tests. |
| [`warcraft-ii/docs/product/user_story_map.md`](warcraft-ii/docs/product/user_story_map.md) | Пользовательские сценарии и вертикальные срезы. |
| [`warcraft-ii/docs/sprints/sprint_report_template.md`](warcraft-ii/docs/sprints/sprint_report_template.md) | Шаблон отчета спринта. |

## Главное правило переноса

```text
Wargus/Warcraft source -> Runtime concept -> маленький order/rule -> test
```

Центральный модуль runtime: [`warcraft-ii/game/warcraft_runtime/`](warcraft-ii/game/warcraft_runtime/).
Godot Node, UI и Presentation не считаются источником игровой правды.

## Правило сдачи

Каждый спринт должен оставлять в GitVerse полный след:

- код и runtime data проекта;
- актуальный README с инструкцией запуска;
- отчет спринта в `warcraft-ii/docs/sprints/`;
- тест-план или test/reference cases;
- список известных ограничений;
- проверенный запуск демо.

Если демо не запускается или ссылки не открываются, остальные сильные стороны
проекта не помогут при оценивании. Запускаемость и честная инструкция запуска имеют
высший приоритет.
