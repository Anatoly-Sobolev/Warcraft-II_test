# warcraft_runtime/map

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** логическая карта Warcraft II, occupancy, fog, pathfinding и
быстрый поиск units.

## Файлы

| Файл | Назначение |
|---|---|
| `warcraft_map.gd` | Tile map, dimensions, terrain flags. |
| `static_occupancy.gd` | Buildings, terrain blockers, permanent blockers. |
| `unit_occupancy.gd` | Runtime unit occupancy. |
| `movement_reservations.gd` | Temporary reservations for movement/path following. |
| `fog_of_war_grid.gd` | Visible/explored by player. |
| `unit_spatial_index.gd` | Fast unit lookup by area/tile. |
| `grid_pathfinder.gd` | Grid pathfinding. |
| `path_service.gd` | Runtime facade for path requests. |
| `path_request_queue.gd` | Budgeted path requests. |
| `path_cache.gd` | Cached paths with invalidation. |
| `group_move_planner.gd` | Group movement planning. |
| `stuck_resolver.gd` | Unstuck behavior. |
| `path_region_versions.gd` | Region versions for cache invalidation. |

## Инварианты

- Logic map and visual tiles are separate.
- Any passability change updates occupancy, cache versions and dirty buffers.
- Pathfinding/fog must be measured on target-like hardware before optimization.
