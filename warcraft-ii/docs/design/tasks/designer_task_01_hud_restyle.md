# Задание дизайнеру 01: HUD первого вертикального среза

## Контекст

Проект переносит Warcraft II на Godot 4.4. Игровые механики, состав интерфейса,
команды и миссионная структура должны соответствовать Warcraft II/Wargus, но
визуальный стиль должен быть новым и легальным для проекта.

Это задание не про изобретение нового RTS-интерфейса. Нужно переработать
существующий HUD Warcraft II/Wargus под новый стиль проекта.

## Материалы

Основной пакет для дизайнера:

```text
warcraft-ii/docs/design/designer_handoff/task_01_hud_restyle/
```

Дизайнеру в первую очередь передаются файлы из этой папки:

- `README.md` - как открыть материалы и откуда берутся оригинальные ассеты;
- `reference_board.md` - доска с активными изображениями после подготовки `reference_assets/`;
- `materials_checklist.md` - список обязательных PNG и screenshots/crops;
- `task.md` - короткая постановка задачи без технических Wargus-ссылок.

Технические материалы для владельца проекта/разработчика:

- `warcraft-ii/docs/design/visual_integration.md`;
- `warcraft-ii/docs/design/reference_packs/original_ui_reference_pack.md`;
- `warcraft-ii/docs/design/reference_packs/wargus_ui_materials.md`;
- `warcraft-ii/docs/gameplay/mechanics_matrix.md`, строки `UI-001` ... `UI-008`,
  `PRES-001` ... `PRES-006`, `IMP-002`, `IMP-006`.

Локальный Wargus checkout:

```text
<local Wargus checkout>
```

Главные Wargus-файлы для проверки:

```text
scripts/human/buttons.lua
scripts/icons.lua
scripts/ui.lua
scripts/human/ui.lua
scripts/human/ui_pandora.lua
scripts/widgets.lua
scripts/fonts.lua
scripts/commands.lua
scripts/menus/*.lua
campaigns/human/level01h_c.sms
```

## Reference pack

Дизайнеру нужно получить папку `reference_assets/` внутри handoff-пакета или
отдельный архив с тем же содержимым. Это должны быть реальные PNG-файлы и
screenshots/crops оригинального UI, а не список путей в коде.

Папка для локальных материалов:

```text
warcraft-ii/docs/design/designer_handoff/task_01_hud_restyle/reference_assets/
```

Они нужны для анализа, но не являются финальными ассетами проекта и не
коммитятся в Git.

Обязательные кадры:

| ID | Кадр | Цель |
| --- | --- | --- |
| ORIG-UI-001 | Human mission 01 start, full HUD | Общая композиция: карта, ресурсы, миникарта, selection/info, command panel. |
| ORIG-UI-002 | Selected Peasant | Worker commands: move, stop, attack, repair, harvest, return goods, build menus. |
| ORIG-UI-003 | Peasant basic build menu | 3x3 command grid, Farm, Barracks, Town Hall, cancel/back. |
| ORIG-UI-004 | Selected Town Hall | Train Peasant, rally commands, production/progress context. |
| ORIG-UI-005 | Selected Barracks | Train Footman and production/progress context. |
| ORIG-UI-006 | Selected Footman/group | Combat commands and group selection density. |
| ORIG-UI-007 | Tooltip/popup over command button | Hint, hotkey, cost/requirements style. |
| ORIG-UI-008 | Disabled/locked command | Disabled/locked visual state. |
| ORIG-UI-009 | Minimap with terrain/fog | Readability of terrain, fog and player colors. |
| ORIG-UI-010 | In-game menu/options/save | Menu button and modal/menu visual language. |
| ORIG-UI-011 | Human mission 01 briefing/objectives | Briefing/objectives overlay style. |

Если оригинальные screenshots/crops нельзя хранить в Git, передать их отдельно и
оставить в документах только manifest.

## Scope

Сделать дизайн-систему и макет HUD для первого вертикального среза:

- `resource_bar`;
- `minimap_panel`;
- `selection_panel`;
- `command_panel`;
- `command_button`;
- `queue/progress slot`;
- `tooltip`;
- `menu button`;
- базовый `briefing/objectives overlay` как reference direction.

## Функциональный состав HUD

Сохранить Wargus/Warcraft II структуру:

- левая колонка содержит menu button, minimap, info/selection panel,
  command panel;
- верхняя полоса содержит gold, wood, oil, supply и дополнительные счетчики;
- command panel — фиксированная 3x3 сетка с позициями `Pos = 1..9`;
- build menu использует уровни `Level = 1` и `Level = 2`;
- пустые или недоступные команды не должны сдвигать сетку;
- tooltip должен показывать hint/hotkey/cost/requirement;
- progress state должен покрывать construction/training/research/upgrade.

## Команды первого среза

Основа из `scripts/human/buttons.lua`:

| Компонент | Команды/состояния |
| --- | --- |
| Peasant base | Move, Stop, Attack, Repair, Harvest, Return Goods, Build Basic, Build Advanced. |
| Peasant build basic | Farm, Barracks, Town Hall, Lumber Mill, Blacksmith, Tower, Wall, Cancel. |
| Town Hall | Train Peasant, Upgrade to Keep, Harvest rally, Move rally, Stop rally, Attack rally. |
| Barracks | Train Footman; будущие Archer/Ranger/Ballista/Knight/Paladin могут быть disabled/future. |
| Footman | Move, Stop, Attack, Patrol, Stand Ground. |
| Group selection | Compact selected unit grid and command intersection. |

Первый playable scope проекта может реализовать не все перечисленные команды
сразу, но дизайн должен знать их места и состояния, чтобы UI не пришлось
перерисовывать через неделю.

## Состояния компонентов

Для каждого компонента показать:

- normal;
- hover/focus;
- pressed;
- disabled/locked;
- selected/current command;
- progress/cooldown;
- warning/error, например не хватает ресурсов;
- hotkey visible/hidden, потому что Wargus имеет настройку показа hotkeys.

## Deliverables

Нужно сдать:

1. Component map: какие компоненты HUD есть и к каким ORIG-UI crops они
   привязаны.
2. Один основной макет игрового экрана Human mission 01.
3. Отдельные компоненты в состояниях: resource bar, minimap frame, selection
   panel, command button, command panel, progress/queue slot, tooltip, menu
   button.
4. Build menu state для Peasant.
5. Town Hall/Barracks production state.
6. Group selection state.
7. Disabled/locked command example.
8. Motion spec: hover, press, tooltip появление, progress fill, warning pulse.
9. Asset list: какие новые иконки, рамки, панели, шрифты, textures нужно
   нарисовать.
10. Notes: какие элементы являются прямым наследованием структуры Wargus, а где
    предложен новый визуальный стиль.

## Ограничения

- Не добавлять новые игровые команды, панели или ресурсы.
- Не удалять существующие Wargus/Warcraft II UI-состояния без согласования.
- Не использовать оригинальные Warcraft II изображения как финальные runtime
  assets.
- Не переносить Wargus scripts в дизайн-спеку как готовую реализацию; фиксировать только нужные ids, размеры, states и mapping.
- Не менять игровые правила и command availability в дизайне.
- Не делать HUD как один монолитный экран без компонентной структуры.

## Критерии приемки

Задание принято, если:

- каждый компонент имеет reference из оригинального UI или Wargus metadata;
- command panel сохраняет 3x3 сетку и позиции команд;
- first-slice команды Peasant/Town Hall/Barracks/Footman покрыты;
- есть состояния disabled/progress/tooltip/group selection;
- дизайнер явно отделил reference-only материалы от новых ассетов;
- макет можно разложить в Godot по `ui/hud/*`, `ui/components/*`,
  `ui/theme/*`, `ui/animation/*`.
