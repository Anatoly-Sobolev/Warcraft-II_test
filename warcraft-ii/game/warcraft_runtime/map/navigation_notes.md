# warcraft_runtime/map navigation notes

Navigation is part of the Warcraft runtime map layer. It exists to support
Warcraft II orders, not to become a standalone pathfinding framework.

## Scope

- Build paths for `order_move`, `order_attack`, `order_resource`, `order_build`
  and `order_transport`.
- Respect Warcraft movement layers: land, naval and fly.
- Use passability and occupancy from `warcraft_map.gd`, `static_occupancy.gd` and
  `unit_occupancy.gd`.
- Keep path work budgeted by `path_request_queue.gd`.

## Performance

Pathfinding is a primary native-code candidate. Before moving it to GDExtension,
add or update a benchmark in `tests/performance/benchmark_pathfinding.gd`.
