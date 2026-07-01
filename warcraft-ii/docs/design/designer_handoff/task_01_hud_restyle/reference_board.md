# Reference board

Оригинальные Warcraft II/Wargus PNG были извлечены из купленной
`Warcraft II: Battle.net Edition` через Wargus `wartool`.

Исходник:

```text
<local Warcraft II install>
```

Результат extraction:

```text
external\wargus_extracted
```

Для обновления короткой доски выполнить:

```powershell
.\collect_reference_assets.ps1 -ExtractedRoot "external\wargus_extracted"
```

Для обновления полного каталога выполнить:

```powershell
.\build_designer_asset_catalog.ps1 -ExtractedRoot "external\wargus_extracted"
```

Полные доски:

- [`generated_boards/ui_board.md`](generated_boards/ui_board.md)
- [`generated_boards/campaign_board.md`](generated_boards/campaign_board.md)
- [`generated_boards/world_graphics_board.md`](generated_boards/world_graphics_board.md)
- [`generated_boards/full_png_catalog.md`](generated_boards/full_png_catalog.md)

## Available now from local Wargus checkout

Эти PNG реально найдены в `<local Wargus checkout>\contrib` и
скопированы в ignored-папку `reference_assets/wargus_contrib/`.

Они не являются полным оригинальным HUD. Это только доступные сейчас Wargus
contrib-изображения.

### Wargus contrib: food

![Wargus contrib food](reference_assets/wargus_contrib/food.png)

### Wargus contrib: score

![Wargus contrib score](reference_assets/wargus_contrib/score.png)

### Wargus contrib: workers

![Wargus contrib workers](reference_assets/wargus_contrib/workers.png)

## Extracted UI files

### REF-HUD-001: Human info panel

![Human info panel](reference_assets/graphics/ui/human/infopanel.png)

### REF-HUD-002: Human command panel

![Human command panel](reference_assets/graphics/ui/human/buttonpanel.png)

### REF-HUD-003: Human menu button

![Human menu button](reference_assets/graphics/ui/human/menubutton.png)

### REF-HUD-004: Resource icons

![Resource icons](reference_assets/graphics/ui/gold,wood,oil,mana.png)

### REF-HUD-005: Food indicator

![Food indicator](reference_assets/wargus_contrib/food.png)

### REF-HUD-006: Score indicator

![Score indicator](reference_assets/wargus_contrib/score.png)

### REF-HUD-007: Workers indicator

![Workers indicator](reference_assets/wargus_contrib/workers.png)

### REF-HUD-008: Human mission 01 briefing image

![Human mission 01 briefing](reference_assets/campaigns/human/interface/introscreen1.png)

## Screenshots and crops

### ORIG-UI-001: Full HUD

![Full HUD](reference_assets/screenshots/human_mission_01_full_hud.png)

### ORIG-UI-002: Selected Peasant

![Selected Peasant](reference_assets/screenshots/selected_peasant.png)

### ORIG-UI-003: Peasant Build Basic menu

![Peasant Build Basic](reference_assets/screenshots/peasant_basic_build_menu.png)

### ORIG-UI-004: Selected Town Hall

![Selected Town Hall](reference_assets/screenshots/selected_town_hall.png)

### ORIG-UI-005: Selected Barracks

![Selected Barracks](reference_assets/screenshots/selected_barracks.png)

### ORIG-UI-006: Footman or group selection

![Footman or group selection](reference_assets/screenshots/selected_footman_or_group.png)

### ORIG-UI-007: Tooltip command

![Tooltip command](reference_assets/screenshots/tooltip_command.png)

### ORIG-UI-008: Disabled command

![Disabled command](reference_assets/screenshots/disabled_command.png)

### ORIG-UI-009: Minimap terrain and fog

![Minimap terrain and fog](reference_assets/screenshots/minimap_terrain_fog.png)

### ORIG-UI-010: Game menu

![Game menu](reference_assets/screenshots/game_menu.png)

### ORIG-UI-011: Briefing and objectives

![Briefing and objectives](reference_assets/screenshots/briefing_objectives.png)
