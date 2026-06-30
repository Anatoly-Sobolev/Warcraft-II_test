# animations assets

Папка хранит runtime-данные анимаций, а не оригинальные reference-only ассеты.

Правило проекта: анимации юнитов, зданий, снарядов и эффектов должны быть
data-driven. Основной формат описан в
[`../../../docs/design/data_driven_animation_system.md`](../../../docs/design/data_driven_animation_system.md).

## Что лежит здесь

| Файл | Назначение |
| --- | --- |
| `alliance_sprite_bank.tres` | Sprite/animation bank для Human/Alliance visual ids. |
| `horde_sprite_bank.tres` | Sprite/animation bank для Orc/Horde visual ids. |
| `building_sprite_bank.tres` | Sprite/animation bank зданий и construction/damage states. |
| `effect_sprite_bank.tres` | Sprite/animation bank снарядов, impacts и spell effects. |

## Что не лежит здесь

- оригинальные Warcraft II/Wargus spritesheets без прав;
- GIF/MP4 вместо runtime spritesheet;
- Godot-сцены, содержащие правила боя, движения или добычи;
- временные reference exports для дизайнера.

Runtime-текстуры лежат в `content/assets/textures/*`, а эта папка связывает их с
frame sizes, states и event markers.
