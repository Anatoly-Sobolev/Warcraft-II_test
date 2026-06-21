# match

> ↑ [game](../README.md) · 🏛 [Архитектура](../../../ARCHITECTURE.md)

**Ответственность:** один игровой сеанс. **Composition root** — создаёт все модули
матча, соединяет их порты, управляет фазой сеанса и собирает общий снимок сохранения.
**Владелец состояния:** конфигурация и фаза матча (`LOADING → PLAYING ↔ PAUSED`, а также `DIALOGUE/CUTSCENE/VICTORY/DEFEAT`). Номером тика **не** владеет — им владеет `simulation`.

## Контракт
- **Принимает:** `MatchConfig` (от `campaign` или `skirmish_config_builder`).
- **Отдаёт:** `MatchResult` в `campaign`; собирает `MatchSnapshot` для `services/persistence`.
- **Связывает:** передаёт `TutorialInputRules` в `input`, `InputActionSummary` в `scenario/tutorial`.

## Зависит от
- `input`, `simulation`, `scenario`, `presentation`, `ui`, `services` — создаёт и связывает.

## Файлы
| Файл | Назначение |
|---|---|
| `match.tscn` / `match.gd` | Корневая сцена и контроллер матча. |
| `match_composition.gd` | Создание модулей и соединение портов. |
| `match_config.gd` | Карта, сложность, seed, до 8 слотов. |
| `match_result.gd` | Итог матча для `campaign`. |
| `match_snapshot.gd` | Согласованный снимок всего матча. |
| `skirmish_config_builder.gd` | Проверка и сборка `MatchConfig` для схватки. |

## Инварианты
- Снимок создаётся только в «безопасной точке» (между тактами, см. архитектуру).
- При фазах `PAUSED/DIALOGUE/CUTSCENE/VICTORY/DEFEAT` догоняющие такты не запускаются.
