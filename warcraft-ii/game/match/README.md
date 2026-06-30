# match

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md)

**Ответственность:** один игровой сеанс. Это composition root: создает модули
матча, соединяет их порты, управляет фазой сеанса и собирает общий save snapshot.

**Владелец состояния:** конфигурация и фаза матча (`LOADING -> PLAYING -> PAUSED`,
`DIALOGUE`, `CUTSCENE`, `VICTORY`, `DEFEAT`). Номером `GameCycle` владеет
`warcraft_runtime`.

## Контракт

- **Принимает:** `MatchConfig` от campaign или skirmish setup.
- **Отдает:** `MatchResult` в campaign; `MatchSnapshot` в persistence.
- **Связывает:** input, `warcraft_runtime`, scenario, presentation, ui, services.

## Файлы

| Файл | Назначение |
|---|---|
| `match.tscn` / `match.gd` | Корневая сцена и контроллер матча. |
| `match_composition.gd` | Создание модулей и соединение портов. |
| `match_config.gd` | Карта, seed, player slots, race, difficulty. |
| `match_result.gd` | Итог матча для campaign. |
| `match_snapshot.gd` | Согласованный снимок runtime + scenario + match state. |
| `skirmish_config_builder.gd` | Сборка skirmish config из Warcraft-compatible data. |

## Инварианты

- Снимок создается только между game cycles.
- Пауза/диалог/кат-сцена блокируют продвижение runtime, если source behavior этого требует.
- Match не считает бой, добычу, AI или UI-логику.
