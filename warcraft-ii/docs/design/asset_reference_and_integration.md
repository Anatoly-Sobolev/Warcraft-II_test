# Reference-first система ассетов и внедрения

Документ описывает, как дизайнер готовит новые ассеты для порта Warcraft II и как программисты внедряют их в Godot-проект без ручного дублирования сцен и без придумывания механик заново.

Главное правило: каждый визуальный, звуковой или видео-элемент должен иметь референс, target path и способ подключения. Дизайнер делает новые материалы, но не начинает с пустого листа.

## Что считается корректным референсом

Для каждой задачи нужен reference board:

- полный screenshot или ссылка на локальный reference-only материал;
- crop конкретного элемента, который повторяется по функции;
- подпись: что это за элемент, где он используется, какие states нужны;
- целевой размер или frame size;
- список отличий, которые допустимы в новом ассете;
- ссылка на mechanics row, screen или sprint task.

Оригинальные ассеты Warcraft II и извлеченные материалы Wargus используются как справочник и не коммитятся в runtime-ассеты проекта, если нет отдельного лицензионного решения.

## Источники референсов

| Источник | Для чего использовать | Что нельзя делать |
| --- | --- | --- |
| Локальная Warcraft II BNE | Screenshots UI, юнитов, зданий, terrain, briefing, эффекты, аудио-поведение. | Коммитить оригинальные изображения, звуки, видео. |
| Локальный Wargus | Имена, states, animation directions, button mappings, script metadata. | Переносить GPL-код в проект без отдельного решения. |
| `docs/design/reference_packs/` | Готовые reference-only задания для дизайнера. | Использовать как runtime assets. |
| `content/imported/*_reference_report.md` | Сводки P4 по units/buildings/tiles/buttons/sounds. | Считать отчет заменой ассета. |
| `docs/gameplay/mechanics_matrix.md` | Понять, какие gameplay states должны быть видимы. | Добавлять механику без строки или источника. |

## Шаблон designer brief

Каждая задача дизайнера должна иметь такой brief:

```text
ID:
Sprint:
Gameplay/UI source:
Reference board:
Target asset ids:
Target folders:
Required formats:
Required sizes:
Required states:
Animation directions:
Pivot/anchor:
Integration owner:
Catalog/resource to update:
Manual check:
Known limitations:
```

Пример:

```text
ID: S04-D-001
Sprint: 04
Gameplay/UI source: ECON-HARVEST, ECON-RETURN, HUD-RESOURCES
Reference board: docs/design/designer_handoff/s04_economy/reference_board.md
Target asset ids: unit_peasant, building_town_hall, resource_gold_mine, resource_forest
Target folders: content/assets/textures/units/, content/assets/textures/buildings/, content/assets/textures/terrain/
Required formats: PNG source, WebP optional runtime export
Required sizes: unit frames 72x72 baseline, buildings by visual bounds, terrain tiles by project TileSet size
Required states: idle, walk, harvest, carry, return, deposit, selected
Animation directions: 8 directions for unit movement
Pivot/anchor: feet center for units, bottom center for buildings
Integration owner: P2 + P4
Catalog/resource to update: content/assets/animations/alliance_sprite_bank.tres, content/catalogs/sprite_banks.tres, content/catalogs/units.tres, content/catalogs/buildings.tres, content/catalogs/unit_visuals.tres, content/catalogs/building_visuals.tres
Manual check: worker selected, moves to mine/forest, returns resource, HUD updates
Known limitations: exact Warcraft II timings controlled by runtime tests, not by animation duration
```

## Папки runtime-ассетов

| Тип ассета | Runtime path | Примечание |
| --- | --- | --- |
| UI panels, frames, HUD surfaces | `warcraft-ii/content/assets/textures/ui/` | 9-slice панели, HUD frames, tooltip backgrounds. |
| Command/build/unit icons | `warcraft-ii/content/assets/textures/ui/` | Иконки хранятся в UI atlas/texture pack и связываются с command ids через catalogs. |
| Unit spritesheets | `warcraft-ii/content/assets/textures/units/` | Data-driven states и directions. |
| Building spritesheets | `warcraft-ii/content/assets/textures/buildings/` | Idle, work, damaged, construction stages. |
| Combat/economy effects | `warcraft-ii/content/assets/textures/effects/` | Hit, projectile, death, resource feedback. |
| Terrain textures | `warcraft-ii/content/assets/textures/terrain/` | Source tiles и transitions. |
| Godot TileSets | `warcraft-ii/content/assets/tilesets/` | `.tres` TileSet resources, не большая картинка карты. |
| UI audio | `warcraft-ii/content/assets/audio/sfx/` | Click, disabled, confirm. |
| Unit voices | `warcraft-ii/content/assets/audio/voice/` | Acknowledge, selected, annoyed, action. |
| Combat and alert audio | `warcraft-ii/content/assets/audio/sfx/` | Hit, attack, death, explosion, warning, alert. |
| Music | `warcraft-ii/content/assets/audio/music/` | OGG tracks и loop notes. |
| Briefing images | `warcraft-ii/content/assets/textures/ui/` или `warcraft-ii/content/assets/textures/portraits/` | PNG/WebP экраны, portraits и frames для миссий. |
| Video, если понадобится | `warcraft-ii/content/assets/video/` | WebM. Папка создается при первом реальном видео-ассете. |
| Animation specs | `warcraft-ii/content/assets/animations/` | Таблицы states, frame ranges, markers. |
| Catalogs | `warcraft-ii/content/catalogs/` | `.tres` и data resources, которые читает runtime/presentation. |
| Presentation schemas | `warcraft-ii/content/schema/presentation/` | Контракты visual ids, animation ids, effect ids. |

Reference-only материалы хранятся отдельно от runtime assets:

- `warcraft-ii/docs/design/reference_packs/`;
- `warcraft-ii/docs/design/designer_handoff/`;
- `warcraft-ii/content/imported/*_reference_report.md`.

## Форматы и размеры

| Тип | Формат | Размеры |
| --- | --- | --- |
| Source images | PNG | Без потери качества, transparency там, где нужна. |
| Runtime UI/icons | PNG или WebP | Базовые command icons 48x48 внутри UI atlas/texture pack, при необходимости 32x32/64x64 variants. |
| HUD panels | PNG/WebP + 9-slice notes | Размеры по UI-компонентам, не одним fullscreen изображением. |
| Unit spritesheets | PNG/WebP | Для первого среза baseline frame 72x72, если asset spec не требует другого. |
| Projectiles | PNG/WebP | 16x16, 24x24 или 32x32 по читаемости. |
| Effects | PNG/WebP | 32x32, 48x48 или 64x64, frame count фиксируется в spec. |
| Terrain tiles | PNG/WebP + TileSet `.tres` | Один выбранный tile size на карту: 32x32 или 64x64. Смешивать размеры нельзя. |
| Voices/SFX source | WAV | 44.1/48 kHz, mono для voices/SFX, нормализация loudness. |
| Voices/SFX runtime | OGG Vorbis или WAV | OGG для длинных/повторяемых файлов, WAV для коротких UI clicks при необходимости. |
| Music | OGG Vorbis | Loop points описываются в notes/catalog. |
| Video | WebM | Для первого среза предпочтительнее static briefing images, если видео не критично. |

Точные frame sizes по анимациям фиксируются в `docs/design/data_driven_animation_system.md` или отдельном animation asset spec.

## Как программист подключает ассет

### UI

1. D кладет panels/icons в `content/assets/textures/ui/`.
2. P3 обновляет reusable UI scene/component, например HUD panel или command button.
3. P4 обновляет button/icon catalog, если иконка связана с command id.
4. P3 проверяет empty/hover/pressed/disabled states в демо.

UI может иметь Godot-сцены, потому что это слой интерфейса. Но игровая логика команды остается в `WarcraftCommand`, а не в кнопке.

### Юниты и здания

1. D экспортирует spritesheet и asset spec: state, direction, frame range, pivot.
2. P4 обновляет `content/assets/animations/*_sprite_bank.tres`, `content/catalogs/sprite_banks.tres` и visual catalogs.
3. P2 подключает visual id в reusable entity view.
4. P1 не добавляет визуальные длительности в runtime rules. Runtime использует свои timings, animation следует за state.

Не нужно создавать отдельную Godot-сцену с игровой логикой для каждого Peasant, Footman или Barracks. Юнит или здание в логике - это `EntityId` и данные в stores.

### Terrain и карты

1. D готовит tiles и transitions.
2. P4 собирает TileSet resource и map content report.
3. P2 отображает карту через TileMapLayer.
4. P1 использует passability/map data из runtime-структур, а не из визуального слоя.

Карта не должна быть одним большим изображением. Иначе невозможно нормально держать fog, pathfinding, selection и performance.

### Effects и audio

1. D готовит effect spritesheet или sound list с референсами.
2. P4 добавляет effect/audio catalog, обычно `content/catalogs/audio_banks.tres` для звуков.
3. P2 запускает effect/audio через presentation event.
4. Runtime только сообщает событие или state change, но не управляет Node/audio напрямую.

### Briefing/video

1. D готовит static briefing images или WebM.
2. P3 добавляет screen flow.
3. P4 связывает миссию с briefing assets в scenario/campaign data.
4. P1 не зависит от briefing assets.

## Что нельзя делать

- Нельзя коммитить оригинальные Warcraft II assets как runtime content.
- Нельзя отдавать дизайнеру задачу без reference board.
- Нельзя подключать новый unit/building как отдельную gameplay Node-сцену.
- Нельзя хранить gameplay parameters в UI scene.
- Нельзя менять runtime state из Presentation, UI, Input или Scenario напрямую.
- Нельзя смешивать разные tile sizes в одной runtime-карте.
- Нельзя оптимизировать ассет "на глаз" без хотя бы одного manual/performance check.

## Checklist приемки ассета

Перед merge задачи с ассетом проверяется:

- есть reference board;
- есть target path;
- есть формат, размер, states и pivot/anchor;
- ассет лежит в runtime папке, если он нужен игре;
- original/reference-only материалы не попали в runtime папки;
- catalog или `.tres` обновлен, если нужен;
- сцена предпросмотра или demo scenario показывает ассет;
- sprint report фиксирует, что реально проверялось.
