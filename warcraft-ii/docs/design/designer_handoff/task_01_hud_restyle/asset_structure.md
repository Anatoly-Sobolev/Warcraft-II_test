# Asset structure map

Этот документ объясняет, где в Wargus extraction лежат изображения и как
понимать анимационные PNG.

## Корни материалов

| Папка | Назначение |
| --- | --- |
| `external/wargus_extracted/graphics/ui/` | HUD, меню, кнопки, курсоры, шрифты, панели Human/Orc. |
| `external/wargus_extracted/graphics/human/units/` | Human unit spritesheets: Peasant, Footman, Archer, Knight, ships, flying units. |
| `external/wargus_extracted/graphics/orc/units/` | Orc unit spritesheets: Peon, Grunt, Axethrower, Ogre, ships, flying units. |
| `external/wargus_extracted/graphics/neutral/units/` | Neutral/extra unit spritesheets: corpses, daemon, skeleton. |
| `external/wargus_extracted/graphics/human/buildings/` | Human construction-site spritesheets. |
| `external/wargus_extracted/graphics/orc/buildings/` | Orc construction-site spritesheets. |
| `external/wargus_extracted/graphics/neutral/buildings/` | Neutral building spritesheets. |
| `external/wargus_extracted/graphics/missiles/` | Projectile and spell effect spritesheets. |
| `external/wargus_extracted/graphics/tilesets/` | Terrain tiles and tileset-specific world graphics. |
| `external/wargus_extracted/campaigns/*/interface/` | Campaign briefing/intermission illustrations. |
| `external/wargus_extracted/sounds/` | Voice, UI, spell and combat WAV files. |
| `external/wargus_extracted/music/` | Music WAV/MID files. |
| `external/wargus_extracted/videos/` | SMK videos. |

## Где именно изображения для анимации

Анимационные изображения - это не отдельные `walk_01.png`, `walk_02.png`.
Обычно это один spritesheet на сущность:

```text
graphics/human/units/peasant.png
graphics/human/units/footman.png
graphics/orc/units/peon.png
graphics/orc/units/grunt.png
graphics/missiles/fireball.png
graphics/missiles/explosion.png
```

Пример:

| Entity | Spritesheet | Frame size | Sheet size | Meaning |
| --- | --- | --- | --- | --- |
| Peasant | `graphics/human/units/peasant.png` | `72 x 72` | `360 x 936` | 5 columns x 13 rows, states are selected by Wargus animation script. |
| Footman | `graphics/human/units/footman.png` | `72 x 72` | `360 x 864` | 5 columns x 12 rows. |
| Peon | `graphics/orc/units/peon.png` | `72 x 72` | `360 x 936` | Orc worker equivalent. |
| Grunt | `graphics/orc/units/grunt.png` | `72 x 72` | `360 x 864` | Orc melee unit equivalent. |

## Где правила кадров

PNG сам по себе не говорит, какие кадры являются idle, move, attack или death.
Это описано в Wargus Lua metadata:

| Что нужно понять | Wargus source |
| --- | --- |
| Какой PNG и размер кадра у юнита | `<local Wargus checkout>\scripts\human\units.lua`, `scripts/orc/units.lua` |
| Какие кадры входят в idle/move/attack/death/repair/harvest | `<local Wargus checkout>\scripts\human\anim.lua`, `scripts/orc/anim.lua`, `scripts/anim.lua` |
| Звуки selected/ready/attack/acknowledge | `<local Wargus checkout>\scripts\sound.lua` |
| Кнопки команд и иконки | `scripts/human/buttons.lua`, `scripts/orc/buttons.lua`, `scripts/icons.lua` |

Пример связи:

```text
scripts/human/units.lua
  unit-peasant
  Image = human/units/peasant.png
  size = 72 x 72
  Animations = animations-peasant

scripts/human/anim.lua
  DefineAnimations("animations-peasant", ...)
```

То есть дизайнер смотрит spritesheet как визуальный reference, а разработчик
использует `units.lua` и `anim.lua`, чтобы понять нарезку и playback states.

## Доски для просмотра

После запуска `build_designer_asset_catalog.ps1` доступны:

| Board | Что смотреть |
| --- | --- |
| `generated_boards/ui_board.md` | HUD, меню, панели, cursors, fonts. |
| `generated_boards/animation_spritesheets_board.md` | Юниты, construction sites, missiles, spell effects. |
| `generated_boards/world_graphics_board.md` | Все gameplay/world graphics без UI. |
| `generated_boards/campaign_board.md` | Campaign/intermission illustrations. |
| `generated_boards/full_png_catalog.md` | Полный список PNG. |

## Как отдавать дизайнеру

Для задачи по HUD дизайнеру в первую очередь нужны:

1. `generated_boards/ui_board.md`.
2. `reference_board.md`.
3. Только если стиль затрагивает юнитовые портреты/иконки/эффекты:
   `generated_boards/animation_spritesheets_board.md`.

Для задачи по анимации юнитов дизайнеру нужны:

1. `generated_boards/animation_spritesheets_board.md`.
2. Таблица unit -> spritesheet -> animation id из `scripts/*/units.lua`.
3. Список состояний из `scripts/*/anim.lua`: `Still`, `Move`, `Attack`,
   `Death`, `Harvest`, `Repair`, `SpellCast`, если состояние есть.

Оригинальные изображения остаются reference-only и не коммитятся в Git.
