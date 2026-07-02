# Wargus UI materials

Это техническое приложение для владельца проекта и разработчиков. Дизайнеру не
нужно читать Wargus Lua/SMS-файлы как основной источник задачи.

Для дизайнера используется отдельная папка выдачи:

```text
warcraft-ii/docs/design/designer_handoff/task_01_hud_restyle/
```

В ней есть `reference_board.md`, `materials_checklist.md`, `task.md` и
игнорируемая папка `reference_assets/` для реальных PNG/screenshot-референсов.

Пакет фиксирует, какие материалы из локального Wargus используются как
технический справочник для первого задания дизайнеру по переработке HUD.

Локальный Wargus checkout:

```text
<local Wargus checkout>
```

Важно: этот документ не является готовой реализацией HUD. Он содержит справочную
выжимку: какие файлы смотреть, какие UI-зоны и состояния подтверждены, какие
поля данных важны для дизайна и будущей реализации.

## Что дизайнеру смотреть в первую очередь

| Тема | Wargus-файл | Что дает дизайнеру |
| --- | --- | --- |
| Human command panel | `scripts/human/buttons.lua` | Позиции кнопок, уровни меню, иконки, hotkeys, hints, allowed conditions, ForUnit. |
| Orc command panel | `scripts/orc/buttons.lua` | То же для Orc, чтобы стиль не ломал будущую вторую расу. |
| Common buttons | `scripts/buttons.lua` | Общие cancel/neutral/common actions. |
| Icon atlas mapping | `scripts/icons.lua` | Соответствие `icon-*` id кадрам иконок. |
| Common UI panels | `scripts/ui.lua` | Info panel contents, progress bars, HP/mana/resource decorations, popup types. |
| Human HUD layout | `scripts/human/ui.lua`, `scripts/human/ui_pandora.lua` | Геометрия Human HUD: minimap, info panel, command panel, resources, menu button, status line. |
| Orc HUD layout | `scripts/orc/ui.lua`, `scripts/orc/ui_pandora.lua` | Геометрия Orc HUD для будущей проверки второго skin/style. |
| Button styles | `scripts/widgets.lua` | Размеры и состояния menu/icon buttons: default, hover, clicked. |
| Fonts | `scripts/fonts.lua` | Размеры bitmap fonts и основные цвета текста. |
| In-game menus | `scripts/commands.lua`, `scripts/menus/*.lua` | Горячие клавиши и состав меню: help, options, speed, sound, diplomacy, save, load, restart, quit. |
| Mission briefing | `campaigns/human/level01h_c.sms` | Briefing image/text для Human mission 01, objectives, victory/defeat triggers. |
| Animation context | `scripts/human/anim.lua`, `scripts/anim.lua` | Состояния still/move/attack/death/harvest/repair как контекст для визуальных состояний. |
| Sound context | `scripts/sound.lua` | UI click, selection/acknowledge/attack/ready groups как контекст для feedback. |
| Resources/minimap defaults | `scripts/stratagus.lua` | `ResourcesOnUI`, `SetTrainingQueue(true)`, `MinimapWithTerrain`, player colors. |

## Что есть в Wargus repository как файлы

В локальном checkout нет полного легального runtime-пакета оригинальных Warcraft
II ассетов для коммита в наш проект. Есть:

- Lua/SMS metadata и scripts;
- campaign/map scripts;
- `wartool.*` и `scripts/extract.lua` как tooling/extraction references;
- `contrib/*.png` с дополнительными UI-like helper images;
- map preview PNG для части пользовательских карт;
- ссылки из scripts на ожидаемые extracted paths вроде `ui/human/*.png`,
  `ui/gold,wood,oil,mana.png`, `ui/fonts/*.png`.

Для дизайнерской задачи это означает:

- Wargus scripts используются как source of structure.
- Скриншоты оригинального UI нужно готовить отдельно из легального запуска
  оригинала/Wargus, не коммитя оригинальные изображения без прав.
- В задачу дизайнеру передаются paths, manifest и выжимка по структуре, а не
  готовая реализация UI.

## Human HUD layout summary

Источник: `scripts/human/ui.lua` загружает `scripts/human/ui_pandora.lua`.

Ключевые зоны Human HUD из `ui_pandora.lua`:

| Зона | Подтвержденная структура |
| --- | --- |
| Left column | Filler/background, menu button, minimap, info panel, command panel. |
| Map area | Starts after left column: `MapArea.X = 176`, top resource strip at `Y = 0..16`. |
| Minimap | `X = 24`, `Y = 26`, `W = 128`, `H = 128`. |
| Info panel | `X = 0`, `Y = 160`, size asset `176 x 176`. |
| Command panel | `X = 0`, `Y = 336`, 3x3 icon grid. |
| Resource bar | Gold/wood/oil on top from `X = 176`; supply/score/workers on the right side. |
| Status line | Bottom line from `X = 178` to right edge. |
| Menu button | `X = 24`, `Y = 2`, text `Menu (F10)`. |

Component implications for our Godot project:

- `ui/hud/resource_bar/` must keep the top-strip role.
- `ui/hud/minimap_panel/` must preserve a compact square minimap.
- `ui/hud/selection_panel/` maps to Wargus info panel and selected/training slots.
- `ui/hud/command_panel/` is a 3x3 command grid with `Pos = 1..9`.
- `ui/components/icon_button/` should support default, hover, pressed, disabled,
  selected/autocast/progress overlays.

## Panel contents summary

Источник: `scripts/ui.lua`.

| Panel/content id | Designer meaning |
| --- | --- |
| `panel-general-contents` | Unit/building name, HP bar/text, resource-left state, construction progress. |
| `panel-building-contents` | Supply/demand info for supply buildings. |
| `panel-center-contents` | Town hall/center production resource info. |
| `panel-resimrove-contents` | Lumber/oil production improvement state. |
| `panel-all-unit-contents` | Damage, armor, sight, range, research/training/upgrade progress, carried resource. |
| `panel-attack-unit-contents` | Opponent/attack unit presentation and mana bar. |
| `popup-human-commands` | Tooltip/popup style for command actions. |
| `popup-human-building` | Tooltip/popup style for build commands. |
| `popup-human-unit` | Tooltip/popup style for train-unit commands. |
| `popup-human-upgrade` | Tooltip/popup style for upgrade/spell commands. |

## First vertical slice command buttons

Источник: `scripts/human/buttons.lua`. Эта таблица нужна дизайнеру для command
panel первого среза. Строка Wargus указана как ссылка для проверки, но код не
копируется.

| Wargus line | Context | Pos | Level | Icon | Action | Value | Key | Hint | State notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 39 | Peasant/Footman/group | 1 | 0 | `icon-move-peasant` | `move` |  | `m` | MOVE | Basic command. |
| 50 | Peasant/Footman/group | 2 | 0 | `icon-human-shield1` | `stop` |  | `s` | STOP | Basic command. |
| 77 | Peasant/Footman/group | 3 | 0 | `icon-sword1` | `attack` |  | `a` | ATTACK | Basic command. |
| 120/129 | Footman/group | 4 | 0 | `icon-human-patrol-land` | `patrol` |  | `p` | PATROL | Not required for first mission MVP unless command is implemented. |
| 142 | Footman/group | 5 | 0 | `icon-human-stand-ground` | `stand-ground` |  | `t` | STAND GROUND | Not required for first mission MVP unless command is implemented. |
| 230 | Peasant | 4 | 0 | `icon-repair` | `repair` |  | `r` | REPAIR | Worker-specific command. |
| 235 | Peasant | 5 | 0 | `icon-harvest` | `harvest` |  | `h` | HARVEST LUMBER/MINE GOLD | Worker-specific command. |
| 240 | Peasant | 6 | 0 | `icon-return-goods-peasant` | `return-goods` |  | `g` | RETURN WITH GOODS | Visible/usable when carrying goods. |
| 247 | Peasant | 7 | 0 | `icon-build-basic` | `button` | level 1 | `b` | BUILD BASIC STRUCTURE | Opens build menu. |
| 252 | Peasant | 8 | 0 | `icon-build-advanced` | `button` | level 2 | `v` | BUILD ADVANCED STRUCTURE | Has allowed condition; design disabled/locked state. |
| 260 | Peasant build basic | 1 | 1 | `icon-farm` | `build` | `unit-farm` | `f` | BUILD FARM | First mission objective. |
| 265 | Peasant build basic | 2 | 1 | `icon-human-barracks` | `build` | `unit-human-barracks` | `b` | BUILD BARRACKS | First mission objective. |
| 270 | Peasant build basic | 3 | 1 | `icon-town-hall` | `build` | `unit-town-hall` | `h` | BUILD TOWN HALL | Included for build-menu layout. |
| 275 | Peasant build basic | 4 | 1 | `icon-elven-lumber-mill` | `build` | `unit-elven-lumber-mill` | `l` | BUILD ELVEN LUMBER MILL | Future/disabled candidate. |
| 280 | Peasant build basic | 5 | 1 | `icon-human-blacksmith` | `build` | `unit-human-blacksmith` | `s` | BUILD BLACKSMITH | Future/disabled candidate. |
| 285 | Peasant build basic | 7 | 1 | `icon-human-watch-tower` | `build` | `unit-human-watch-tower` | `t` | BUILD TOWER | Future/disabled candidate. |
| 290/296 | Peasant build basic | 8 | 1 | `icon-human-wall` | `build` | `unit-human-wall` | `w` | BUILD WALL | Network/debug gated in Wargus; mark as not first-slice. |
| 302 | Peasant build basic | 9 | 1 | `icon-cancel` | `button` | level 0 | `ESC` | ESC CANCEL | Returns to base commands. |
| 349 | Peasant build advanced | 9 | 2 | `icon-cancel` | `button` | level 0 | `ESC` | ESC CANCEL | Returns to base commands. |
| 363 | Town Hall | 1 | 0 | `icon-peasant` | `train-unit` | `unit-peasant` | `p` | TRAIN PEASANT | Training button. |
| 371 | Town Hall | 2 | 0 | `icon-keep` | `upgrade-to` | `unit-keep` | `k` | UPGRADE TO KEEP | Future/disabled candidate. |
| 385 | Town Hall | 5 | 0 | `icon-harvest` | `harvest` |  | `h` | SET HARVEST LUMBER/MINE GOLD | Rally/work behavior context. |
| 390 | Town Hall/Barracks | 7 | 0 | `icon-move-peasant` | `move` |  | `m` | SET MOVE | Rally command context. |
| 396 | Town Hall/Barracks | 8 | 0 | `icon-human-shield1` | `stop` |  | `z` | SET ZTOP | Wargus typo preserved as source; do not copy typo into final UX without decision. |
| 402 | Town Hall/Barracks | 9 | 0 | `icon-sword1` | `attack` |  | `e` | SET ATTACK | Rally/attack context. |
| 415 | Barracks | 1 | 0 | `icon-footman` | `train-unit` | `unit-footman` | `f` | TRAIN FOOTMAN | First-slice production. |

Design implication: the command panel is a fixed 3x3 grid with holes. Empty
positions must remain stable; buttons must not reflow when some commands are
unavailable.

## Icon ids for first slice

Источник: `scripts/icons.lua`.

| Icon id | Frame index | Use |
| --- | --- | --- |
| `icon-peasant` | 0 | Town Hall train Peasant, selection icon. |
| `icon-footman` | 2 | Barracks train Footman, selection icon. |
| `icon-farm` | 38 | Build Farm. |
| `icon-town-hall` | 40 | Build/selected Town Hall. |
| `icon-human-barracks` | 42 | Build/selected Barracks. |
| `icon-move-peasant` | 83 | Move/rally move. |
| `icon-repair` | 85 | Repair. |
| `icon-harvest` | 86 | Harvest/rally harvest. |
| `icon-build-basic` | 87 | Open basic build menu. |
| `icon-build-advanced` | 88 | Open advanced build menu. |
| `icon-return-goods-peasant` | 89 | Return goods. |
| `icon-cancel` | 91 | Cancel/back. |
| `icon-sword1` | 116 | Attack/rally attack. |
| `icon-human-shield1` | 164 | Stop/rally stop. |
| `icon-human-patrol-land` | 178 | Patrol. |
| `icon-human-stand-ground` | 180 | Stand ground. |

## Button and text style facts

Источник: `scripts/widgets.lua`, `scripts/fonts.lua`.

| Element | Wargus facts designer should preserve conceptually |
| --- | --- |
| Command icon button | `icon` style uses 46x38 button area, text/hotkey position in bottom-right. |
| Main menu button | `main` style uses 128x20. |
| Game menu buttons | `gm-half` 106x28, `gm-full` 224x28. |
| Text colors | Normal/hover often switch yellow/white; font colors include yellow, white, grey, red/green/blue variants. |
| Fonts | `large`, `small`, `game`, title fonts are bitmap-font based in Wargus; our design may replace them but must keep RTS readability. |

## In-game menu references

Источник: `scripts/commands.lua` and `scripts/menus/*.lua`.

| Shortcut/source | Menu |
| --- | --- |
| `F1` | Help. |
| `F5` | Game options. |
| `F6` | Speeds. |
| `F7` | Sound options. |
| `F8` | Preferences. |
| `F9` | Diplomacy. |
| `F10`, `Alt+M`, Backspace | Game menu. |
| `F11`, `Alt+S` | Save menu. |
| `F12`, `Alt+L` | Load menu. |
| `Ctrl/Alt+Q` | Quit to menu confirmation. |
| `Ctrl/Alt+R` | Restart confirmation. |
| `Ctrl/Alt+X` | Exit confirmation. |

First designer task only needs visual treatment for menu button and one
pause/options/save reference state, not full implementation of every menu.

## Mission 01 briefing and objectives references

Источник: `campaigns/human/level01h_c.sms`.

| Wargus line | Meaning |
| --- | --- |
| 5 | Calls `Briefing(...)`. |
| 8 | Uses briefing image path `../campaigns/human/interface/introscreen1.png`. |
| 9 | Uses briefing text `campaigns/human/level01h.txt`. |
| 14-17 | Victory condition: at least 4 farms and 1 human barracks. |
| 18-20 | Defeat condition: player has no units. |
| 49 | Loads `campaigns/human/level01h.sms`. |

Design implication: first task must include a small briefing/objectives visual
reference, even if implementation starts from HUD.

## Source limitations

- Do not treat Wargus Lua snippets as the final Godot UI implementation.
- Original Warcraft II extracted assets go into `content/assets/` only as
  manifest-tracked `original_placeholder` files until replaced.
- Wargus paths in this document are source references for analysis and review.
- Designer deliverables must be new visual work or clearly labeled reference
  screenshots/crops.
