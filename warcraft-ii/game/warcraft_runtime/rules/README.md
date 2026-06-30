# warcraft_runtime/rules

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** общие Warcraft II правила, которые обслуживают orders и не
принадлежат одному приказу.

## Файлы

| Файл | Назначение |
|---|---|
| `terrain_rules.gd` | Passability, buildable flags, forest/rocks/resource terrain. |
| `visibility_rules.gd` | Visible/explored/shared vision and fog invalidation. |
| `missile_rules.gd` | Missile movement, impact, splash/payload handoff. |
| `status_effect_rules.gd` | Buff/debuff duration, stacking, expiration. |
| `lifecycle_rules.gd` | Death, cleanup, slot release, score/stat events. |

## Инварианты

- Если правило является фазой конкретного приказа, оно живет в `orders/`.
- Rules работают с runtime state, но не с UI/Presentation.
- Любая массовая операция получает benchmark, если попадает в hot path.
