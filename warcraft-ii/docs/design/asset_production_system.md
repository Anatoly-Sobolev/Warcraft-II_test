# Asset production system

Документ фиксирует, какие визуальные, звуковые и видео-материалы нужно
создать для проекта, в каком порядке их делать и как они попадут в Godot.

Цель: дизайнер не должен гадать, рисовать ли целую карту, отдельные тайлы,
spritesheet или UI-компонент. Для каждого типа ассета есть ожидаемый формат,
reference source, место в проекте и правило интеграции.

## Главное решение по картам

Карты не рисуются одной большой картинкой.

Для производительности, редактируемости и соответствия RTS-логике карта
собирается из данных и тайлов:

```text
map data -> TileMapLayer/terrain layers -> decals/props -> units/buildings
```

Дизайнер создает:

- tileset: набор повторяемых terrain tiles;
- правила переходов: grass/water/coast/forest/rocks/road/cliff;
- props/decals: деревья, камни, следы, мелкие детали;
- palette/style guide для читаемости карты;
- несколько mockup-скриншотов участков карты для проверки стиля.

Дизайнер не создает:

- одну большую PNG-карту для runtime;
- игровые collision/navigation данные;
- расстановку юнитов как картинку;
- туман войны как вручную нарисованный слой.

Разработчик/level designer собирает карту в редакторе или из data-файлов через
TileMapLayer, catalogs и scenario data.

## Этапы производства

| Этап | Цель | Что делает дизайнер | Что делает разработчик | Результат |
| --- | --- | --- | --- | --- |
| 0. Reference pack | Понять оригинал | Смотрит Wargus/Warcraft II boards и отмечает, что перерисовывается | Извлекает reference-only материалы, генерирует boards | `designer_handoff/*/generated_boards/` |
| 1. Visual direction | Зафиксировать новый стиль | Делает style frame для HUD, terrain, unit silhouette, effects | Проверяет читаемость, размеры, бюджет | утвержденный visual direction |
| 2. UI first slice | Сделать HUD и меню первого среза | Рисует компоненты HUD и состояния | Интегрирует как отдельные Godot сцены | `ui/hud/*`, `ui/components/*`, `ui/theme/*` |
| 3. Terrain tileset | Получить карту без ручной большой картинки | Рисует tileset, transitions, props, decals | Собирает TileSet/TileMapLayer и тестовую карту | `content/assets/tilesets/*`, `content/catalogs/*` |
| 4. Units/buildings | Получить playable entities | Рисует spritesheets и construction/damage states | Создает sprite banks, animation data, presentation catalogs | `content/assets/textures/units/*`, `.../buildings/*` |
| 5. Effects/missiles | Сделать feedback действий | Рисует projectiles, impacts, spell effects | Интегрирует pooled effects | `content/assets/textures/effects/*` |
| 6. Audio | Сделать feedback и атмосферу | Передает список нужных звуков и mood references; sound designer делает WAV/OGG | Подключает audio banks | `content/assets/audio/*`, `content/catalogs/audio_banks.tres` |
| 7. Video/cinematics | Сделать заставки/briefings при необходимости | Storyboard/key art/motion references | Решает формат, playback и fallback | `content/assets/video/*` или image sequence |
| 8. Optimization pass | Уложиться в performance budget | Упрощает шум, атласы, размеры, количество вариантов | Проверяет FPS, memory, batching, draw calls | optimized asset set |

## Что уже сделано

| Область | Статус | Где смотреть | Следующее действие |
| --- | --- | --- | --- |
| Reference extraction | Сделано локально | `external/wargus_extracted/` | Не коммитить, использовать как reference-only. |
| UI reference boards | Сделано локально | `docs/design/designer_handoff/task_01_hud_restyle/generated_boards/ui_board.md` | Использовать для HUD task. |
| Full PNG catalog | Сделано локально | `generated_boards/full_png_catalog.md` | Фильтровать по задачам, не отдавать дизайнеру без контекста. |
| Animation spritesheet board | Сделано локально | `generated_boards/animation_spritesheets_board.md` | Добавить таблицу unit -> frame size -> animation states для задач по юнитам. |
| HUD task 01 | Документировано | `docs/design/tasks/designer_task_01_hud_restyle.md` | Дать дизайнеру вместе с референсами. |
| Asset structure map | Документировано | `designer_handoff/task_01_hud_restyle/asset_structure.md` | Расширять при новых типах ассетов. |
| Runtime new art | Не начато | `content/assets/` | Рисовать новые легальные ассеты после утверждения style direction. |
| Terrain tileset | Не начато | `content/assets/tilesets/` | Создать отдельное задание на tileset и карту первого сценария. |
| Unit/building spritesheets | Не начато | `content/assets/textures/units/`, `.../buildings/` | Начинать после утверждения gameplay scale и camera zoom. |
| Audio replacement | Не начато | `content/assets/audio/` | Создать audio brief и список событий. |
| Video/cinematic replacement | Не начато | `content/assets/video/` или `content/assets/textures/briefings/` | Решить, нужны ли видео в первом вертикальном срезе. |

## Классы ассетов

| Класс | Что сдает дизайнер | Runtime-формат | Кто интегрирует | Источник референса |
| --- | --- | --- | --- | --- |
| HUD panels | Компоненты, states, slices | PNG/WebP, StyleBox, Theme, `.tscn` | UI | `graphics/ui/human/*`, `graphics/ui/orc/*` |
| HUD icons | Иконки команд/ресурсов | atlas PNG/WebP + icon ids | UI/content | `scripts/icons.lua`, `buttons.lua` |
| Fonts | Bitmap/vector font choice, sizes | `.ttf/.otf` or bitmap font import | UI | `graphics/ui/fonts/*` |
| Terrain tiles | Повторяемые tiles, transitions | TileSet source PNG/WebP | Presentation/content | `graphics/tilesets/*` |
| Map props | Деревья, камни, doodads, decals | atlas PNG/WebP | Presentation/content | tileset references |
| Unit sprites | Directional spritesheets | atlas PNG/WebP + animation data | Presentation/content | `graphics/*/units/*`, `scripts/*/anim.lua` |
| Building sprites | Base, construction, damage, destroyed | atlas PNG/WebP + states | Presentation/content | `graphics/*/buildings/*` |
| Effects | Missiles, impacts, spells | atlas PNG/WebP + pooled scene | Presentation | `graphics/missiles/*` |
| Portraits/briefings | Character/mission art | PNG/WebP | UI/scenario | `campaigns/*/interface/*` |
| Sounds | UI, combat, selected, ready, alerts | WAV/OGG | Services/audio | `sounds/*`, `scripts/sound.lua` |
| Music | Themes and loops | OGG | Services/audio | `music/*` |
| Video | Intro/briefing/cinematic | WebM/MP4 or image sequence | App/scenario | `videos/*`, campaign screens |

## Карты и TileMapLayer

### Правило

Для runtime-карт используем tile-based подход. Карта хранится как данные и
слои, а не как большая текстура.

Рекомендуемая структура Godot:

```text
MapRoot
  TerrainBaseTileMapLayer
  TerrainOverlayTileMapLayer
  RoadCoastCliffTileMapLayer
  PropsLayer
  FogPresentationLayer
  EntityPresentationRoot
```

Warcraft Runtime знает только grid, passability, resources и unit positions.
Presentation выбирает визуальные tiles/props через catalogs.

### Что нужно создать дизайнеру для карты

| Asset | Нужно для первого среза | Комментарий |
| --- | --- | --- |
| Base ground tiles | Да | grass/dirt/snow или выбранный biome первого сценария. |
| Water tiles | Если есть вода | Включая shoreline transitions. |
| Coast/edge transitions | Да, если есть вода/скалы | Нужны auto-tiling rules. |
| Forest/tree props | Да | Лучше prop atlas, не один тайл на каждое дерево. |
| Rock/mountain props | Да | Влияют на читаемость passability. |
| Road/path tiles | Если есть дороги | Должны читаться на minimap. |
| Resource visuals | Да | Gold mine, trees, oil patch если в сценарии есть oil. |
| Minimap color palette | Да | Цвета terrain/resource/player должны быть различимы. |
| Tile transition sheet | Да | Нужен не только “красивый grass tile”, но и края/углы. |
| Map mockup | Да | 1-2 screenshot mockups участка карты, не runtime asset. |

### Чего не делать

- Не рисовать карту целиком в Photoshop как единственный runtime background.
- Не делать уникальную текстуру для каждого экрана карты.
- Не вшивать passability в изображение.
- Не полагаться на прозрачные декоративные слои поверх всей карты без бюджета.

## Юниты и анимации

Оригинальные Wargus изображения для юнитов - это spritesheets. Например:

```text
graphics/human/units/peasant.png
graphics/human/units/footman.png
graphics/orc/units/peon.png
graphics/orc/units/grunt.png
```

Frame size и animation id задаются в:

```text
C:\Users\UZER\Coding\Projects\wargus\scripts\human\units.lua
C:\Users\UZER\Coding\Projects\wargus\scripts\human\anim.lua
C:\Users\UZER\Coding\Projects\wargus\scripts\orc\units.lua
C:\Users\UZER\Coding\Projects\wargus\scripts\orc\anim.lua
```

Новые ассеты нужно делать так же системно. Полный runtime-контракт,
производственные правила и таблицы оригинальных размеров зафиксированы в
[`data_driven_animation_system.md`](data_driven_animation_system.md).

| Ассет юнита | Что сдает дизайнер | Что добавляет разработчик |
| --- | --- | --- |
| Still/idle | Кадры idle и direction policy | animation state `idle` |
| Move | Walk/move loop | movement playback speed и интерполяцию |
| Attack | Windup, hit frame, recover | hit/sound/projectile markers |
| Death | Death sequence/corpse state | corpse/despawn visual mapping |
| Work/harvest/repair | Worker action frames | command-state mapping и work markers |
| Carry resource | Gold/wood variants if needed | visual variant condition |
| Selection/outline | Selection ring/outline if styled | selection presentation |

Дизайнеру не нужно самому писать animation controller, но нужно сдать кадры и
таблицу states: какие frames относятся к idle/move/attack/death/work, где pivot,
какая сетка, какие markers запускают звук, удар, снаряд или рабочее действие.

## Здания

Здания не являются игровыми Node в Warcraft Runtime. В Warcraft Runtime это entity data, а
Presentation показывает состояние.

Дизайнер создает:

- base building sprite;
- construction stages;
- damaged/burning states;
- destroyed/ruins state, если нужен;
- selection/placement preview;
- footprint visual hint.

Разработчик создает:

- building visual catalog;
- construction progress mapping;
- placement feedback scene;
- dirty-buffer/ViewData binding.

## UI и HUD

HUD всегда компонентный:

```text
ui/hud/resource_bar/
ui/hud/minimap_panel/
ui/hud/selection_panel/
ui/hud/command_panel/
ui/components/icon_button/
ui/components/tooltip/
```

Дизайнер сдает:

- component map;
- normal/hover/pressed/disabled/selected/progress states;
- slicing rules;
- icons and atlas naming;
- motion notes.

Разработчик не должен собирать HUD как одну гигантскую сцену.

## Звук

Audio assets должны идти от событий, а не от “папки звуков”.

| Группа событий | Примеры | Что сдает дизайнер/sound designer | Интеграция |
| --- | --- | --- | --- |
| UI | click, hover, error, confirm | короткие SFX | `audio_banks.tres` |
| Unit voice | selected, ready, acknowledge, annoyed | WAV/OGG variants | unit audio bank |
| Combat | sword, arrow, impact, building hit | SFX variants | combat event mapping |
| Work/economy | harvest, repair, construction complete | SFX/voice | command feedback |
| Alerts | under attack, not enough resources | voice/SFX | UI alert system |
| Music | menu, human battle, orc battle, victory/defeat | loops/stingers | music service |

Для первого среза достаточно UI click/error, selected/acknowledge для Peasant,
Footman, Town Hall/Barracks feedback, combat hit и construction complete.

## Видео и заставки

Видео не должно быть обязательным для первого playable slice. Если нужно
передать briefing mood, сначала делаем статичный key art/briefing screen.

| Type | First slice policy | Runtime note |
| --- | --- | --- |
| Intro video | Не обязательно | Лучше отложить до стабильного вертикального среза. |
| Mission briefing | Да, как статичный экран | PNG/WebP + text/audio. |
| Victory/defeat | Можно статично | Позже заменить video/motion. |
| Logo/campaign video | Не приоритет | Не должно блокировать gameplay. |

## Performance-правила

- Карты собираются из tiles и props, не из одной огромной картинки.
- Повторяемые ассеты пакуются в atlases.
- UI panels режутся на reusable parts, где это экономит память.
- Animated units используют spritesheets с ограниченным frame count.
- Effects должны быть короткими и pooled.
- Не добавлять уникальную текстуру там, где достаточно tile/prop reuse.
- Размеры ассетов фиксируются до production: tile size, unit frame size,
  UI scale, camera zoom.
- Каждый новый визуальный набор получает memory/FPS smoke check.

## Как ставить задачи дизайнеру

Каждая задача дизайнеру должна содержать:

1. Reference board: что именно переделываем.
2. Scope: какие asset classes входят.
3. Runtime target: UI scene, TileSet, spritesheet, audio bank, video screen.
4. Required states: normal/hover/pressed или idle/move/attack/death.
5. Format and size: frame size, tile size, atlas constraints.
6. Performance constraints.
7. What not to invent: какие gameplay rules и layout нельзя менять.
8. Delivery checklist.

## Рекомендуемый порядок заданий

| Номер | Задание | Почему так |
| --- | --- | --- |
| 1 | HUD first slice restyle | Сразу закрывает главный playable интерфейс. |
| 2 | Terrain tileset для Human mission 01 | Без tileset нельзя нормально делать карту. |
| 3 | Peasant/Footman/Town Hall/Barracks visual set | Это минимальный набор первого сценария. |
| 4 | Command icons and effects first slice | Делает команды читаемыми. |
| 5 | Audio feedback first slice | Без звука RTS ощущается пустой. |
| 6 | Briefing/objectives screen | Нужен для campaign loop. |
| 7 | Orc visual direction | Второй skin/race после Human baseline. |
