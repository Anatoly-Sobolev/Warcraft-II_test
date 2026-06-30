# Wargus runtime mapping

Документ фиксирует соответствие между Wargus/Stratagus concepts и новой структурой
проекта. Это основной справочник для студентов перед переносом mechanics.

## Concept mapping

| Wargus/Stratagus | Godot project |
| --- | --- |
| `UnitType` / `DefineUnitType` | `content/schema/gameplay/*`, `content/catalogs/*`, `model/unit_factory.gd` |
| Runtime unit | `state/*`, `model/unit_handle.gd`, `model/unit_registry.gd` |
| Player slot / race / resources | `state/player_state.gd`, `match_config.gd` |
| Command button | catalogs + `ports/warcraft_command_query.gd` |
| Player command | `model/warcraft_command.gd`, `ports/warcraft_command_sink.gd` |
| Unit order | `model/warcraft_order.gd`, `orders/order_*.gd` |
| Game cycle | `game_cycle_runner.gd`, `model/cycle_scheduler.gd` |
| Map field / tile flags | `map/warcraft_map.gd`, `map/static_occupancy.gd` |
| Unit occupancy | `map/unit_occupancy.gd`, `map/unit_spatial_index.gd` |
| Pathfinding | `map/path_service.gd`, `map/grid_pathfinder.gd` |
| Fog/explored | `rules/visibility_rules.gd`, `map/fog_of_war_grid.gd` |
| Missile | `state/missile_state.gd`, `rules/missile_rules.gd` |
| AI call/directive | `ai/ai_directive.gd`, `ai/build_order_planner.gd`, `ai/attack_wave_planner.gd` |
| Campaign trigger/action | `scripting/`, then `scenario/` for UI-facing state |
| Save game state | `runtime_snapshot.gd`, `services/persistence/` |

## Order mapping

| Wargus action/order | Runtime file |
| --- | --- |
| `move`, `stop`, `patrol`, `explore` | `orders/order_move.gd` |
| `attack`, `attack-ground`, return fire, hold/stand behavior | `orders/order_attack.gd` |
| `harvest`, `return-goods`, oil tanker resource cycle | `orders/order_resource.gd` |
| `build`, `repair`, `cancel-build` | `orders/order_build.gd` |
| `train-unit`, `research`, `upgrade-to`, queue cancel | `orders/order_train.gd` |
| `cast-spell` | `orders/order_spell.gd` |
| `unload`, transport behavior | `orders/order_transport.gd` |

## GameCycle rule

Перенос порядка исполнения делается не “как удобно”, а по reference:

1. Commands accepted for current/next cycle.
2. Unit orders update.
3. Shared rules update: terrain, missiles, status, visibility, lifecycle.
4. AI budgeted work.
5. Events/dirty buffers/snapshots published.

Если Wargus source показывает другой порядок для конкретной механики, это
фиксируется в строке механики или known issues и имеет приоритет над общей схемой.

## Performance rule

Семантика переносится из Wargus, но хранение и исполнение могут быть оптимизированы:

- `Unit` может быть представлен handle + arrays/native structs.
- Lua/scripts могут использоваться для data/mission decisions, но не для массового
  per-unit hot loop.
- Native/GDExtension допустим для pathfinding, fog, mass orders and combat после
  benchmark.
