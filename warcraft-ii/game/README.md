# game

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md)

**Ответственность:** всё, что живет внутри игрового сеанса. `game/` не является
одним модулем: состояние распределено между дочерними модулями, а авторитетный
игровой мир находится в `warcraft_runtime/`.

## Подмодули

| Модуль | Ответственность | README |
|---|---|---|
| `campaign` | Прогресс между миссиями, открытие миссий | [→](campaign/README.md) |
| `match` | Сборка и жизненный цикл одного матча | [→](match/README.md) |
| `input` | Жесты, выбор, hotkeys, превращение действий в `WarcraftCommand` | [→](input/README.md) |
| `warcraft_runtime` | **Авторитетное ядро порта Warcraft II/Wargus** | [→](warcraft_runtime/README.md) |
| `scenario` | Objectives, briefing, dialogue, tutorial оболочки | [→](scenario/README.md) |
| `presentation` | Спрайты, камера, туман, миникарта, игровой звук | [→](presentation/README.md) |

## Поток внутри матча

```text
input ───────────────┐
scenario/mission ────┼── WarcraftCommand ──► warcraft_runtime
runtime AI ──────────┘                         ├── events ───► scenario/audio
                                                ├── dirty ────► presentation
                                                └── snapshots ► ui/save
```

`match` создает эти модули и соединяет их типизированными портами. Модули не ищут
друг друга через дерево сцен.
