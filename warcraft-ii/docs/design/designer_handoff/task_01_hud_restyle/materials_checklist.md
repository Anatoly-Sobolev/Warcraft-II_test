# Чеклист материалов

Эти материалы нужны дизайнеру как реальные визуальные референсы. После извлечения или подготовки screenshots/crops они должны лежать в `reference_assets/`.

## Обязательные PNG из Wargus extraction

| ID | Файл в `reference_assets/` | Зачем нужен |
| --- | --- | --- |
| REF-HUD-001 | `ui/human/infopanel.png` | Оригинальная зона selection/info panel. |
| REF-HUD-002 | `ui/human/buttonpanel.png` | Оригинальная зона command panel. |
| REF-HUD-003 | `ui/human/menubutton.png` | Кнопка меню и стиль маленьких HUD-кнопок. |
| REF-HUD-004 | `ui/gold,wood,oil,mana.png` | Пиктограммы/полоса ресурсов. |
| REF-HUD-005 | `ui/food.png` | Food/supply indicator. |
| REF-HUD-006 | `ui/score.png` | Score indicator, если файл есть после extraction. |
| REF-HUD-007 | `ui/workers.png` | Workers indicator, если файл есть после extraction. |
| REF-HUD-008 | `campaigns/human/interface/introscreen1.png` | Briefing/objectives стиль Human mission 01. |

## Обязательные screenshots/crops

Если их нельзя получить как отдельные PNG, сделать снимки из запущенного Warcraft II или Wargus и положить в `reference_assets/screenshots/`.

| ID | Файл | Что должно быть видно |
| --- | --- | --- |
| ORIG-UI-001 | `screenshots/human_mission_01_full_hud.png` | Полный HUD: карта, ресурсы, миникарта, selection/info, command panel. |
| ORIG-UI-002 | `screenshots/selected_peasant.png` | Peasant commands. |
| ORIG-UI-003 | `screenshots/peasant_basic_build_menu.png` | Build Basic menu и сетка 3x3. |
| ORIG-UI-004 | `screenshots/selected_town_hall.png` | Train Peasant, rally/progress context. |
| ORIG-UI-005 | `screenshots/selected_barracks.png` | Train Footman и production/progress context. |
| ORIG-UI-006 | `screenshots/selected_footman_or_group.png` | Combat commands and group density. |
| ORIG-UI-007 | `screenshots/tooltip_command.png` | Tooltip/popup over command button. |
| ORIG-UI-008 | `screenshots/disabled_command.png` | Disabled/locked command state. |
| ORIG-UI-009 | `screenshots/minimap_terrain_fog.png` | Minimap readability with terrain/fog. |
| ORIG-UI-010 | `screenshots/game_menu.png` | In-game menu/options/save visual style. |
| ORIG-UI-011 | `screenshots/briefing_objectives.png` | Briefing/objectives screen. |

## Проверка перед передачей дизайнеру

- `reference_board.md` показывает картинки, а не битые ссылки.
- В `reference_assets/` нет исходников кода, только изображения и локальный manifest.
- Материалы передаются как reference-only.
- Финальный дизайн должен быть новым, а не копией оригинальных файлов.
