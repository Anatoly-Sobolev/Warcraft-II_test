# Warcraft II — карта проекта

Одиночная 2D-RTS на Godot 4.4 (GL Compatibility) для ОС «Аврора». Цель — 30 FPS на слабом железе.

- 🏛 **Архитектура и «почему»:** [`../ARCHITECTURE.md`](../ARCHITECTURE.md) — начни отсюда.
- 🧭 **Рабочие детали:** [`../ARCHITECTURE_DETAILS.md`](../ARCHITECTURE_DETAILS.md) — куда класть код, папки, этапы.

## Быстрый запуск

1. Открыть [`project.godot`](project.godot) в Godot 4.4.
2. Запустить main scene проекта.
3. Если main scene еще не назначена, открыть и запустить `res://app/app.tscn`.
4. Перед сдачей пройти smoke test из [`docs/testing/test_strategy.md`](docs/testing/test_strategy.md).

## Сдача спринта

Перед пятничной проверкой должны быть актуальны:

- [`../AGENTS.md`](../AGENTS.md) - обязательные правила для ИИ и разработчиков;
- [`docs/README.md`](docs/README.md) - индекс проектной документации;
- [`docs/evaluation/season_2026_alignment.md`](docs/evaluation/season_2026_alignment.md) - чеклист требований сезона;
- [`docs/testing/test_strategy.md`](docs/testing/test_strategy.md) - тест-план и формат тест-кейсов;
- [`docs/product/user_story_map.md`](docs/product/user_story_map.md) - user stories, которые закрывает демо;
- [`docs/gameplay/mechanics_matrix.md`](docs/gameplay/mechanics_matrix.md) - источник Warcraft II-механик;
- [`docs/sprints/sprint_01_report.md`](docs/sprints/sprint_01_report.md) или отчет текущего спринта.

## Главная идея за 10 секунд

Мир разделён на два слоя: **Simulation** (вся правда об игре — только данные, без
сцен) и **Presentation/UI** (рисуют готовое состояние). Общение — через узкие порты:
**команды внутрь, подготовленные данные наружу**.

## Слои и модули

| Модуль | Ответственность | README |
|---|---|---|
| **app** | Запуск, экраны, жизненный цикл приложения | [→](app/README.md) |
| **game/campaign** | Прогресс между миссиями | [→](game/campaign/README.md) |
| **game/match** | Сборка одного матча (composition root) | [→](game/match/README.md) |
| **game/input** | Жесты, выбор, создание команд | [→](game/input/README.md) |
| **game/simulation** | **Вся логика и правда о матче** | [→](game/simulation/README.md) |
| **game/scenario** | Миссии, сюжет, обучение | [→](game/scenario/README.md) |
| **game/presentation** | Спрайты, камера, туман, миникарта, звук | [→](game/presentation/README.md) |
| **ui** | Меню, HUD, панели | [→](ui/README.md) |
| **services** | Сохранения, настройки, ресурсы, платформа | [→](services/README.md) |
| **content** | Схемы данных, каталоги, кампании, карты, ассеты | [→](content/README.md) |
| **tests** | unit / integration / performance | [→](tests/README.md) |
| **debug** | Оверлеи отладки (вне релиза) | [→](debug/README.md) |
| **tools** | Валидация контента, запекание карт | [→](tools/README.md) |

## Поток данных (кратко)

```
Input/AI/Scenario ──GameCommand──► Simulation ──┬── события ───► Scenario
                                                ├── dirty-буферы► Presentation
                                                └── ViewData ───► UI
```

Где искать состояние: всё авторитетное — в `game/simulation/`. Кто чем владеет —
в таблице README каждого модуля, в `ARCHITECTURE.md` и в `ARCHITECTURE_DETAILS.md`.
