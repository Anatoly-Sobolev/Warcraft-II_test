# warcraft_runtime/native

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** будущие C++/GDExtension реализации горячих участков.

## Кандидаты

- Pathfinding and path cache.
- Fog/visibility recalculation.
- Mass order update.
- Missile/combat batch.
- Snapshot serialization.

## Инварианты

- Native code добавляется только после benchmark или явного performance риска.
- Native API должен сохранять те же Warcraft runtime semantics.
- Godot-facing boundary остается через runtime facade and ports.
