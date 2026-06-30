# warcraft_runtime/ai

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** перенос Wargus/Warcraft II AI directives, build orders,
worker/resource priorities and attack waves.

AI не является отдельным “умным” движком. Он должен воспроизводить source behavior
настолько близко, насколько нужно для gameplay-equivalent порта.

## Файлы

| Файл | Назначение |
|---|---|
| `ai_controller.gd` | Координация AI players. |
| `ai_cycle_scheduler.gd` | Budgeted AI work by `GameCycle`. |
| `ai_state.gd` | Plans, cooldowns, known targets. |
| `ai_directive.gd` | Wargus-style AI calls/directives. |
| `build_order_planner.gd` | Build/research/upgrade/resource plans. |
| `attack_wave_planner.gd` | Army groups, waves, waits, attack targets. |

## Инварианты

- AI changes world state only via `WarcraftCommand` or approved runtime directive.
- Campaign AI scripts and skirmish AI are not mixed without explicit adapter.
- AI work is budgeted; no long Lua/script loop in a frame without benchmark.
