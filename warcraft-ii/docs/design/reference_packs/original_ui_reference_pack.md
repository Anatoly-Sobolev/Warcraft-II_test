# Original UI reference pack

Этот manifest описывает, какие материалы оригинальной Warcraft II нужно
подготовить перед постановкой задачи дизайнеру. Цель пакета — показать, что
именно перерабатывается в новый стиль, не превращая дизайн-задачу в свободное
изобретение нового интерфейса.

## Правовой статус

Оригинальные скриншоты, crop-изображения, аудио и ассеты Warcraft II являются
reference-only материалами, если для них нет отдельного права на хранение в
репозитории. Они не должны попадать в runtime, `content/assets/` или Git без
явного решения по правам.

Если права есть, нужно обновить `docs/content/content_pipeline.md` и указать:

- источник материалов;
- какие типы файлов разрешено хранить;
- где они лежат;
- кто отвечает за проверку прав;
- как отличить reference-only материалы от runtime-ассетов.

## Обязательные скриншоты и crops

| ID | Материал | Что снять | Связанные строки матрицы |
| --- | --- | --- | --- |
| ORIG-UI-001 | Full HUD, Human mission 01 start | Полный экран с картой, ресурсами, миникартой, нижней панелью | `UI-001`, `UI-002`, `UI-005` |
| ORIG-UI-002 | Single Peasant selected | Selection panel, portrait/icon, команды рабочего | `UI-001`, `UI-003`, `UI-007` |
| ORIG-UI-003 | Unit group selected | Group selection panel, плотность иконок | `UI-003` |
| ORIG-UI-004 | Town Hall selected | Команды здания, production context, supply/resource context | `UI-001`, `UI-002`, `UI-004` |
| ORIG-UI-005 | Barracks selected | Train Footman, queue/progress/cancel state | `UI-001`, `UI-004` |
| ORIG-UI-006 | Peasant build menu open | Многоуровневый command panel строительства | `UI-001`, `BUILD-001`, `BUILD-002` |
| ORIG-UI-007 | Command tooltip | Hint, hotkey, cost/requirements text | `UI-001`, `UI-007` |
| ORIG-UI-008 | Disabled command | Disabled visual state and reason | `UI-001` |
| ORIG-UI-009 | Minimap with fog | Terrain/fog/player color readability | `UI-005`, `PRES-006` |
| ORIG-UI-010 | Pause/options/save menu | Внутриигровые меню и их layout | `UI-006` |
| ORIG-UI-011 | Briefing/objective/dialogue | Миссионные overlay/экраны | `UI-008`, `SCEN-005` |

## Wargus metadata sources

Эти файлы использовать как справочник по структуре UI, mapping-данным и
поведению. Нельзя копировать GPL-код напрямую в Godot без отдельного решения по
лицензии.

```text
scripts/human/buttons.lua
scripts/orc/buttons.lua
scripts/buttons.lua
scripts/icons.lua
scripts/ui.lua
scripts/commands.lua
scripts/menus/*.lua
scripts/sound.lua
scripts/human/anim.lua
scripts/orc/anim.lua
scripts/anim.lua
scripts/missiles.lua
scripts/tilesets/*.lua
```

## Локальные project visuals

Показывать дизайнеру как текущую техническую базу проекта:

```text
content/assets/textures/ui/ui_atlas.png
content/assets/textures/portraits/portraits_atlas.png
content/assets/textures/units/alliance_units_atlas.png
content/assets/textures/units/horde_units_atlas.png
content/assets/textures/buildings/alliance_buildings_atlas.png
content/assets/textures/buildings/horde_buildings_atlas.png
content/assets/textures/effects/effects_atlas.png
content/assets/textures/effects/projectiles_atlas.png
content/assets/textures/terrain/forest_atlas.png
content/assets/animations/alliance_sprite_bank.tres
content/assets/animations/horde_sprite_bank.tres
content/assets/animations/building_sprite_bank.tres
content/assets/animations/effect_sprite_bank.tres
content/assets/tilesets/forest_tileset.tres
content/catalogs/sprite_banks.tres
content/catalogs/unit_visuals.tres
content/catalogs/building_visuals.tres
```

## Формулировка задачи дизайнеру

```text
Перед началом изучи reference pack оригинального Warcraft II UI:
ORIG-UI-001 ... ORIG-UI-011. Задача — не придумать новый HUD, а переработать
существующий состав интерфейса под новый визуальный стиль проекта.

Нужно подготовить:
- карту компонентов HUD с привязкой к crop-референсам;
- новый visual direction без копирования оригинальных ассетов;
- состояния компонентов: normal, hover/focus, pressed, disabled, selected,
  progress, warning/error;
- layout rules для desktop 16:9 и малого экрана;
- motion spec для UI-анимаций;
- список новых ассетов, которые нужно нарисовать или заменить placeholder.

Нельзя:
- добавлять новые панели и игровые функции без отдельной задачи;
- использовать оригинальные Warcraft II изображения как финальные runtime-ассеты;
- менять состав команд, хоткеев и состояний без сверки с mechanics_matrix.md.
```

