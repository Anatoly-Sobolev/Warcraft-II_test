# Warcraft II — карта проекта

Порт Warcraft II на Godot 4.4 (GL Compatibility) для ОС «Аврора». Проект
нацелен на **gameplay-equivalent порт**, а не на новую RTS: механики, темп,
команды, кампании и AI переносятся из Warcraft II/Wargus/Stratagus reference.
Финальные визуальные и звуковые ассеты проекта — новые или легально разрешенные.

- 🏛 **Архитектура порта:** [`docs/architecture/architecture.md`](docs/architecture/architecture.md)
- 🧭 **Рабочие детали и структура:** [`docs/architecture/architecture_details.md`](docs/architecture/architecture_details.md)
- 🧩 **Перенос механик:** [`docs/porting/warcraft2_logic_porting_plan.md`](docs/porting/warcraft2_logic_porting_plan.md)
- 🎞 **Анимации и visual mapping:** [`docs/design/data_driven_animation_system.md`](docs/design/data_driven_animation_system.md)

## Быстрый запуск

1. Открыть [`project.godot`](project.godot) в Godot 4.4.
2. Запустить main scene проекта.
3. Если main scene еще не назначена, открыть и запустить `res://app/app.tscn`.
4. Перед сдачей пройти smoke test из [`docs/testing/test_strategy.md`](docs/testing/test_strategy.md).

## Главная идея за 10 секунд

Godot отвечает за приложение, ввод, UI и отображение. Игровые правила живут в
`game/warcraft_runtime/` — Wargus/Stratagus-compatible runtime:

```text
Input / Mission / AI -> WarcraftCommand -> Warcraft Runtime -> Presentation/UI
```

Runtime мыслит понятиями Warcraft II:

```text
UnitType, Unit, Player, Order, Map, GameCycle, Trigger, AI directive
```

Студент не проектирует новую механику. Он берет source/reference из Wargus или
оригинальной игры, переносит конкретный concept в runtime и добавляет test/reference
case.

## Слои и модули

| Модуль | Ответственность | README |
|---|---|---|
| **app** | Запуск, экраны, жизненный цикл приложения | [→](app/README.md) |
| **game/campaign** | Прогресс между миссиями | [→](game/campaign/README.md) |
| **game/match** | Сборка одного матча | [→](game/match/README.md) |
| **game/input** | Жесты, выбор, hotkeys, `WarcraftCommand` | [→](game/input/README.md) |
| **game/warcraft_runtime** | **Авторитетное ядро порта Warcraft II** | [→](game/warcraft_runtime/README.md) |
| **game/scenario** | Objectives, briefing, tutorial, mission UI | [→](game/scenario/README.md) |
| **game/presentation** | Спрайты, камера, туман, миникарта, игровой звук | [→](game/presentation/README.md) |
| **ui** | HUD, command panel, selection panel, меню | [→](ui/README.md) |
| **services** | Сохранения, настройки, ресурсы, платформа | [→](services/README.md) |
| **content** | Runtime data, каталоги, кампании, карты, новые ассеты | [→](content/README.md) |
| **tools** | Import/reference/validation pipeline | [→](tools/README.md) |
| **tests** | Unit / integration / reference / performance | [→](tests/README.md) |
| **debug** | Оверлеи отладки | [→](debug/README.md) |

## Поток данных

```text
Wargus Lua / SMS / SMP / PUD / installed game data
        ↓
tools/import -> content/imported/reference reports
        ↓
content/catalogs + warcraft_runtime adapters
        ↓
warcraft_runtime -> events / dirty buffers / UI snapshots
        ↓
presentation + ui
```

Где искать авторитетное состояние: `game/warcraft_runtime/`. Кто чем владеет и
куда класть код — в [`docs/architecture/architecture_details.md`](docs/architecture/architecture_details.md).

## Сдача спринта

Перед пятничной проверкой должны быть актуальны:

- [`../AGENTS.md`](../AGENTS.md) - обязательные правила для ИИ и разработчиков;
- [`docs/README.md`](docs/README.md) - индекс проектной документации;
- [`docs/evaluation/season_2026_alignment.md`](docs/evaluation/season_2026_alignment.md);
- [`docs/testing/test_strategy.md`](docs/testing/test_strategy.md);
- [`docs/product/user_story_map.md`](docs/product/user_story_map.md);
- [`docs/gameplay/mechanics_matrix.md`](docs/gameplay/mechanics_matrix.md);
- актуальный отчет в `docs/sprints/`.
