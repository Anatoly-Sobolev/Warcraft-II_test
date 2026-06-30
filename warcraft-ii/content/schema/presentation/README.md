# presentation schema

Папка хранит Resource-схемы для визуального слоя. Эти схемы связывают gameplay
ids с тем, как сущности отображаются, но не содержат правил Warcraft Runtime.

## Animation contract

Анимации должны следовать data-driven системе из
[`../../../docs/design/data_driven_animation_system.md`](../../../docs/design/data_driven_animation_system.md).

Минимальный набор будущих схем:

| Схема | Назначение |
| --- | --- |
| `sprite_bank.gd` | Texture/atlas, frame size, frame rects, animation states, markers. |
| `unit_visual_definition.gd` | Связь unit gameplay id с visual id, shadow, selection, animation bank. |
| `building_visual_definition.gd` | Связь building gameplay id с visual id, construction/damage/death states. |
| `map_visual_definition.gd` | TileSet/terrain visual ids и minimap palette. |
| `audio_bank.gd` | Звуковые groups и варианты для UI, units, combat, alerts. |

Запрещено добавлять в эти схемы урон, pathfinding, экономику или правила команд.
Warcraft Runtime отдает state/events, а Presentation выбирает кадры и markers по данным.
