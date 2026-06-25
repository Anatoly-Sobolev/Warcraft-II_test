# Onboarding за 30 минут

Короткий вход для нового разработчика. Цель - понять, что происходит в проекте,
какие правила нельзя ломать и куда идти за деталями.

## Что это за проект

Мы делаем 2D RTS Warcraft II на Godot 4.4 для слабых ПК и ОС Аврора.
Визуальный дизайн будет новым, но игровой цикл и механики ориентируются на
Warcraft II. Источники механик фиксируются в
[`mechanics_matrix.md`](../gameplay/mechanics_matrix.md).

## Что прочитать сначала

1. [`README.md`](../../../README.md) - запуск и главные документы.
2. [`AGENTS.md`](../../../AGENTS.md) - обязательные правила для ИИ и разработчиков.
3. [`architecture.md`](../architecture/architecture.md) - короткая архитектура.
4. [`architecture_details.md`](../architecture/architecture_details.md) - куда класть код.
5. README модуля, который меняешь.
6. [`workflow.md`](workflow.md) и [`prompting_rules.md`](prompting_rules.md) - как ставить задачи ИИ.

## Главная архитектурная идея

```text
Input / AI / Scenario
        |
        v
   GameCommand
        |
        v
    Simulation  ---> events / dirty buffers / ViewData
        |                              |
        v                              v
 authoritative state             Presentation / UI
```

Simulation - единственный источник правды о матче. Presentation и UI только
показывают подготовленные данные.

## Правила, которые нельзя ломать

- Игровая логика живет в `game/simulation/`.
- Юнит или здание в логике - это `EntityId` и данные в хранилищах, а не Godot Node.
- Игрок, AI и сценарий меняют мир только через `GameCommand`.
- UI, Presentation, Scenario и Input не меняют Simulation напрямую.
- Simulation не зависит от сцен, спрайтов, звука, UI, файловой системы и платформы.
- Новая Warcraft II-механика должна иметь строку или источник в `mechanics_matrix.md`.
- Сначала тест или ручная проверка, потом отчет о готовности.

## Навигатор по модулям

| Что нужно сделать | Куда идти |
| --- | --- |
| Запуск приложения, экраны, routing | [`app/`](../../app/README.md) |
| Сборка одного матча | [`game/match/`](../../game/match/README.md) |
| Ввод, выбор, жесты, команды игрока | [`game/input/`](../../game/input/README.md) |
| Правила RTS, бой, экономика, движение, AI, туман | [`game/simulation/`](../../game/simulation/README.md) |
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
`game/simulation/`, вход через `GameCommand`, проверка через тест.
