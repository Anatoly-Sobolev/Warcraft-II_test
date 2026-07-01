# Архитектура: рабочие детали порта

*Этот документ отвечает на практический вопрос: куда студенту класть код, если он
переносит конкретную механику Warcraft II/Wargus в Godot. Проект больше не
проектируется как новая RTS; он строится как Warcraft II-compatible runtime с
новыми ассетами и жестким performance budget.*

Первая, короткая часть: [architecture.md](architecture.md).

---

## Как читать

Для любой задачи используем один маршрут:

1. Найти строку механики в `docs/gameplay/mechanics_matrix.md`.
2. Найти Wargus/original source: Lua, SMS/SMP/PUD, installed game data или
   проверенный ручной reference.
3. Определить Wargus concept: `UnitType`, `Button`, `Order`, `Spell`, `Trigger`,
   `AI directive`, `Map`, `Player`.
4. Положить код в соответствующий модуль. Gameplay rules и runtime state идут в
   `game/warcraft_runtime/`; UI, Presentation, Scenario, Content, Services и
   Tools остаются в своих слоях и не меняют runtime state напрямую.
5. Добавить reference report, тест или ручной test case.

Если задача начинается словами «придумать систему», формулировку нужно переписать.
Правильная формулировка: «перенести concept X из Wargus source Y».

## Минимальный путь переноса механики

Архитектура полная, но реализация идет через минимальный вертикальный путь. Не
нужно заполнять все папки заранее.

```text
mechanics_matrix row
  -> Wargus/Warcraft source
  -> WarcraftCommand или runtime script step
  -> order/rule в game/warcraft_runtime/
  -> runtime state change
  -> test/manual reference check
  -> UI/Presentation hook только если нужен для демо
```

Если задача требует больше слоев, сначала дробим ее. Например, не берем
«сделать экономику»; берем «перенести harvest gold для Peasant из source X».
Не берем «сделать боевую систему»; берем «Footman attack target: cooldown,
damage, death check».

Reserved/future зоны (`native/`, полноценный Lua/SMS runtime в `scripting/`,
широкий AI, универсальный import pipeline, расширенные dirty buffers) включаются
только под конкретную механику, benchmark или demo need.

---

## Структура папок

```text
warcraft-ii/                  (res://)
├── app/                      запуск, экраны, жизненный цикл
├── game/
│   ├── campaign/             прогресс между миссиями
│   ├── match/                сборка одного матча
│   ├── input/                ввод игрока -> WarcraftCommand
│   ├── warcraft_runtime/     портируемое ядро Warcraft II/Wargus
│   ├── scenario/             briefing, objectives, tutorial оболочки
│   └── presentation/         отображение мира
├── ui/                       HUD, command panel, меню, оверлеи
├── services/                 сохранения, настройки, платформа, ресурсы
├── content/                  runtime data, каталоги, новые ассеты
├── tools/                    import/reference/validation pipeline
├── tests/                    unit / integration / reference / performance
├── debug/                    отладочные оверлеи
└── docs/                     спецификации
```

---

## Каталог модулей

### `app/`

**Роль:** вход в приложение, крупные экраны, жизненный цикл.

**Ключевые файлы:** `app.tscn`, `app.gd`, `bootstrap.gd`, `scene_router.gd`,
`app_lifecycle.gd`, `app_state.gd`.

**Нельзя:** считать правила Warcraft II, хранить состояние матча.

### `game/campaign/`

**Роль:** прогресс между миссиями и кампаниями.

**Ключевые файлы:** `campaign_controller.gd`, `campaign_state.gd`,
`campaign_progression.gd`, `campaign_view_data.gd`.

**Нельзя:** исполнять миссию, менять runtime напрямую. Campaign получает
`match_result` и обновляет доступность миссий.

### `game/match/`

**Роль:** один игровой сеанс и composition root.

**Ключевые файлы:**

- `match.tscn`, `match.gd` — корень матча.
- `match_composition.gd` — создает input, `warcraft_runtime`, scenario,
  presentation, ui, services и соединяет их портами.
- `match_config.gd` — карта, seed, player slots, race, difficulty.
- `match_snapshot.gd` — общий снимок runtime + scenario + match shell.
- `match_result.gd` — итог для campaign.
- `skirmish_config_builder.gd` — сборка схватки из Warcraft-compatible данных.

**Нельзя:** считать бой, экономику, pathfinding, AI или UI-логику.

### `game/input/`

**Роль:** перевод кликов, касаний и hotkeys в Warcraft II commands.

**Ключевые файлы:**

- `input_controller.gd` — вход событий Godot.
- `gesture_recognizer.gd` — мобильные жесты.
- `input_state.gd` — выбранные `UnitHandle`, активный command mode.
- `selection_controller.gd` — выбор через `warcraft_runtime/ports/selection_query`.
- `command_composer.gd` — сборка `WarcraftCommand`.
- `camera_intent.gd` — намерение камеры.
- `selection_presentation_data.gd` — подсветка выбранного для Presentation.

**Нельзя:** решать, доступна ли команда. Это делает `warcraft_runtime`.

### `game/warcraft_runtime/`

**Роль:** авторитетный Warcraft II-compatible runtime. Это самое горячее место
проекта и главный слой переноса механик.

**Корневые файлы:**

- `warcraft_runtime.gd` — фасад ядра: состояние, game cycle, ports.
- `game_cycle_runner.gd` — фиксированный Warcraft `GameCycle`, catch-up лимиты.
- `runtime_config.gd` — частоты, лимиты, флаги Lua/native режимов.
- `runtime_snapshot.gd` — сохраняемое состояние match runtime.

**Контракт:**

- принимает `WarcraftCommand`, mission script steps и AI directives;
- отдает events, dirty buffers, UI snapshots, save snapshot;
- не зависит от Godot scenes, UI, Presentation, audio и platform services;
- в горячем цикле не создает лишний мусор и не исполняет тяжелый Lua per-unit.

#### `game/warcraft_runtime/model/`

**Роль:** Wargus-compatible понятия и легкие handle-типы.

**Файлы:**

- `unit_handle.gd` — безопасная ссылка на runtime unit: index + generation.
- `unit_registry.gd` — создание, reuse и освобождение unit slots.
- `runtime_index.gd` — плотные индексы для быстрых проходов.
- `unit_factory.gd` — создание unit/building/missile из `UnitType`/catalog data.
- `warcraft_command.gd` — намерение игрока, AI или mission script.
- `command_queue.gd` — команды по `GameCycle`.
- `warcraft_order.gd` — длительный приказ unit: move, attack, harvest, build...
- `runtime_event.gd`, `event_buffer.gd` — завершившиеся факты runtime.
- `runtime_random.gd` — сохраняемый RNG.
- `cycle_scheduler.gd` — редкие проверки по расписанию циклов.

**Нельзя:** добавлять сюда новую механику без Wargus concept/source.

#### `game/warcraft_runtime/state/`

**Роль:** состояние матча в производительной форме. Названия близки к Warcraft
concepts, но хранение может быть data-oriented.

**Файлы:**

- `unit_type_state.gd` — runtime refs на `UnitType`, flags, visual ids.
- `position_state.gd` — tile/subtile position, direction, movement layer.
- `ownership_state.gd` — owner player, team/diplomacy refs.
- `unit_vitals_state.gd` — HP, mana, armor, death flags.
- `order_state.gd` — текущий и saved order, target, phase, timers.
- `movement_state.gd` — speed, path, stuck state.
- `combat_state.gd` — attack profile, range, cooldown, target.
- `worker_state.gd` — carried resource, harvest target, return depot.
- `building_state.gd` — footprint, construction progress, rally point.
- `resource_node_state.gd` — gold mine, oil patch, forest/resource counters.
- `terrain_state.gd` — изменяемые terrain flags и depleted cells.
- `production_state.gd` — train/research/upgrade queues.
- `spell_state.gd`, `status_effect_state.gd` — mana, effects, durations.
- `missile_state.gd` — Warcraft missile/projectile runtime data.
- `transport_state.gd` — passengers, unload state.
- `player_state.gd` — до 8 players: race, controller, resources, supply, tech.
- `vision_state.gd` — sight sources.
- `score_state.gd` — statistics and result counters.

**Нельзя:** отдавать изменяемые массивы наружу.

#### `game/warcraft_runtime/orders/`

**Роль:** основное место переноса поведения Warcraft II units. Большинство правил
должно попадать сюда, потому что Wargus/Stratagus mechanics часто живут в orders.

**Файлы:**

- `command_dispatcher.gd` — проверка команды и назначение initial order.
- `order_move.gd` — move, stop, patrol movement phase.
- `order_attack.gd` — attack, attack-ground, return fire, hold/stand behavior.
- `order_resource.gd` — harvest, return-goods, gold/wood/oil cycle.
- `order_build.gd` — build placement, construction, cancel-build, repair.
- `order_train.gd` — train-unit, research, upgrade-to, queue/cancel.
- `order_spell.gd` — cast-spell, mana, target validation, spell launch.
- `order_transport.gd` — load/unload/passenger behavior.

**Нельзя:** писать “удобное” поведение без reference. Если Wargus order ведет себя
странно, фиксируем странность и переносим ее или явно записываем допустимое отличие.

#### `game/warcraft_runtime/rules/`

**Роль:** общие правила, которые обслуживают orders и не принадлежат одному приказу.

**Файлы:**

- `terrain_rules.gd` — passability, forest/rocks, buildable flags.
- `visibility_rules.gd` — visible/explored/shared vision.
- `missile_rules.gd` — missile movement and hit resolution.
- `status_effect_rules.gd` — buff/debuff durations, stacking, expiration.
- `lifecycle_rules.gd` — death, corpse/removal, cleanup, score events.

**Нельзя:** превращать `rules/` в “новую систему RTS”. Если правило завязано на
конкретный order, оно живет в `orders/`.

#### `game/warcraft_runtime/map/`

**Роль:** карта, занятость, pathfinding, fog grids.

**Файлы:**

- `warcraft_map.gd` — logical tiles, terrain flags, map dimensions.
- `static_occupancy.gd`, `unit_occupancy.gd` — buildings/terrain и units.
- `movement_reservations.gd` — временные reservations.
- `fog_of_war_grid.gd` — visible/explored.
- `unit_spatial_index.gd` — быстрый поиск units.
- `grid_pathfinder.gd`, `path_service.gd`, `path_request_queue.gd`,
  `path_cache.gd`, `group_move_planner.gd`, `stuck_resolver.gd`.
- `path_region_versions.gd` — invalidation для path cache.

**Performance note:** pathfinding/fog первыми уходят в native code, если бенчмарк
не проходит на целевом устройстве.

#### `game/warcraft_runtime/ai/`

**Роль:** AI переносится как Warcraft II/Wargus directives, build orders and waves.

**Файлы:**

- `ai_controller.gd` — координация AI players.
- `ai_cycle_scheduler.gd` — распределение AI work по `GameCycle`.
- `ai_state.gd` — plans, cooldowns, known targets.
- `ai_directive.gd` — переносимые AI calls/directives.
- `build_order_planner.gd` — `AiNeed`, `AiSet`, worker/resource priorities.
- `attack_wave_planner.gd` — groups, attack waves, waits.

**Нельзя:** AI не пишет state напрямую, кроме своего планировочного состояния. Для
мира он создает `WarcraftCommand` или runtime-recognized directive.

#### `game/warcraft_runtime/scripting/`

**Роль:** адаптация Wargus Lua/SMS/campaign scripts. Этот слой нужен, чтобы не
переписывать mission logic вручную.

**Что сюда добавлять:**

- Lua loader или converter adapters;
- mission script adapter;
- trigger/action mapping;
- safety wrappers для runtime API.

**Performance note:** scripting слой не должен исполняться для каждого unit каждый
cycle. Он запускает mission/AI decisions, а массовые операции выполняет runtime.

#### `game/warcraft_runtime/native/`

**Роль:** будущие C++/GDExtension реализации горячих участков.

**Кандидаты:**

- pathfinding;
- fog/visibility;
- mass unit order update;
- missile/combat batch;
- save/load serialization hot path.

Нельзя переносить сюда “на всякий случай”. Сначала бенчмарк, потом native.

#### `game/warcraft_runtime/ports/`

**Роль:** единственные двери наружу.

**Вход:** `warcraft_command_sink.gd`.

**Запросы:** `selection_query.gd`, `warcraft_command_query.gd`, `mission_query.gd`,
`runtime_ui_query.gd`, `runtime_event_reader.gd`.

**Данные наружу:** `selection_view_data.gd`, `runtime_ui_data.gd`,
`render_change_buffer.gd`, `terrain_change_buffer.gd`, `fog_change_buffer.gd`,
`minimap_change_buffer.gd`.

**Нельзя:** возвращать изменяемые массивы `state/` или map grids.

### `game/scenario/`

**Роль:** тонкая оболочка над mission runtime: objectives, briefing, tutorial,
dialogue, UI-facing mission state.

Если миссионная логика уже есть в Wargus `.sms`/Lua, сначала делается adapter в
`warcraft_runtime/scripting/`, а `scenario/` показывает цели и диалоги.

**Нельзя:** править `warcraft_runtime/state/` напрямую.

### `game/presentation/`

**Роль:** показать игровой мир и звук матча по snapshots/events.

**Ключевые файлы:** `world_view.tscn`, `world_view.gd`,
`presentation_controller.gd`, `render_sync.gd`, `camera_control_port.gd`,
`camera_snapshot.gd`.

**Нельзя:** считать урон, путь, экономику, видимость или доступность команд.

### `ui/`

**Роль:** HUD, command panel, selection panel, minimap panel, menus, overlays.

UI берет данные из runtime ports и content catalogs. UI не хранит правду о мире.

Ключевые папки:

- `ui_root.tscn`, `ui_root.gd` — корень UI-слоя матча/приложения.
- `screens/` — main menu, campaign/mission select, skirmish setup, settings,
  pause, loading, result screens.
- `hud/` — HUD матча: resources, selection, command panel, minimap, queue,
  objectives.
- `components/` — переиспользуемые UI-компоненты: icon button, tooltip, modal,
  progress, unit icon.
- `overlays/` — dialogue, tutorial, notifications.
- `theme/` — Godot theme resources and constants.
- `animation/` — UI animation notes/resources.

**Нельзя:** кнопка UI не создает gameplay result напрямую. Она может инициировать
input flow, который собирает `WarcraftCommand`.

### `services/`

**Роль:** инфраструктура: persistence, settings, assets, audio, localization,
platform, diagnostics, jobs.

Services не принимают игровых решений.

Ключевые папки:

- `assets/` — loading/cache/manifest для ресурсов проекта.
- `audio/` — audio service and player pools.
- `diagnostics/` — logging, content validation, performance monitoring.
- `jobs/` — фоновые/распределенные задачи вне gameplay decisions.
- `localization/` — runtime access to translated text.
- `persistence/` — save/load, headers, migrations, autosave policy.
- `platform/` — platform abstraction, including Aurora-specific service.
- `settings/` — пользовательские настройки.

### `content/`

**Роль:** runtime data и новые ассеты.

Ключевые папки:

- `schema/gameplay/` — UnitType, attacks, abilities, tech, map logic.
- `schema/presentation/` — visual/audio mappings.
- `schema/scenario/` — mission/objective/trigger/dialogue definitions.
- `schema/campaign/` — campaign progression definitions.
- `catalogs/` — `.tres` catalogs.
- `balance/` — общие balance/rules resources.
- `campaigns/`, `skirmish/`, `tutorial/` — mission/map data для режимов.
- `imported/` — reference reports from Wargus/original install.
- `assets/` — новые или разрешенные runtime assets.
- `localization/` — строки UI, briefing, tutorial и подсказок.

**Нельзя:** хранить здесь оригинальные Warcraft II assets без прав. `external/`
и установленная игра являются локальными reference sources, а не частью runtime
content.

### `tools/`

**Роль:** перенос и проверка reference data.

Нужные подпапки/инструменты:

- `tools/import/` — readers/converters for Wargus Lua, SMS/SMP/PUD, installed data.
- `content_validation_tool.gd` — проверка catalogs и source metadata.
- `atlas_validation_tool.gd` — проверка новых visual assets.
- `map_baker.gd` — bake maps into runtime-friendly resources.

### `tests/`

**Роль:** unit, integration, reference and performance checks.

Ключевые папки:

- `unit/` — отдельные runtime orders/rules/adapters and pure services.
- `integration/` — flow между input, match, runtime, scenario, presentation,
  UI and persistence.
- `performance/` — benchmarks для pathfinding, fog, mass orders, combat, render
  sync, save/load.
- `fixtures/` — small catalogs, maps, missions and snapshots for tests.

### `debug/`

**Роль:** отладочные overlay и диагностические контроллеры для разработки.

Ключевые файлы и зоны:

- `world_debug_overlay.tscn`, `world_debug_overlay.gd` — overlay мира.
- `performance_overlay.tscn`, `performance_overlay.gd` — FPS/tick/debug metrics.
- `path_debugger.gd`, `terrain_debugger.gd`, `visibility_debugger.gd` — проверка
  карты, путей и видимости.
- `event_log.gd`, `debug_controller.gd` — developer-facing diagnostics.

**Нельзя:** debug layer не должен становиться gameplay dependency или условием
работы release build.

---

## Wargus concept -> проект

| Wargus/Warcraft concept | Основное место |
| --- | --- |
| `DefineUnitType`, unit/building stats | `content/schema/gameplay/`, `content/catalogs/`, `warcraft_runtime/model/unit_factory.gd` |
| Unit runtime object | `warcraft_runtime/state/*`, `model/unit_handle.gd`, `model/unit_registry.gd` |
| Player/side/resources/supply | `warcraft_runtime/state/player_state.gd` |
| Button action/hotkey | `content/catalogs/`, `input/command_composer.gd`, `ports/warcraft_command_query.gd` |
| Player/AI/mission command | `model/warcraft_command.gd`, `ports/warcraft_command_sink.gd` |
| Unit order | `model/warcraft_order.gd`, `orders/order_*.gd` |
| Movement/pathfinding | `orders/order_move.gd`, `map/path_service.gd` |
| Combat/attack response | `orders/order_attack.gd`, `rules/missile_rules.gd`, `rules/lifecycle_rules.gd` |
| Harvest/return/repair/build | `orders/order_resource.gd`, `orders/order_build.gd` |
| Train/research/upgrade | `orders/order_train.gd`, `state/production_state.gd` |
| Spell/status | `orders/order_spell.gd`, `rules/status_effect_rules.gd` |
| Fog/shared vision/minimap | `rules/visibility_rules.gd`, `map/fog_of_war_grid.gd`, `ports/*fog*`, `ports/*minimap*` |
| Campaign trigger/SMS action | `scripting/`, then `scenario/` for UI-facing state |
| AI build orders/waves | `ai/`, `model/warcraft_command.gd` |
| Save/load | `runtime_snapshot.gd`, `services/persistence/` |
| Hot path optimization | `warcraft_runtime/native/` after benchmark |

---

## Куда класть новый код

| Что добавляем | Куда класть |
| --- | --- |
| Поле из Wargus `UnitType` | `content/schema/gameplay/` + `content/catalogs/` |
| Runtime состояние этого поля | `game/warcraft_runtime/state/` |
| Новый Warcraft command | `model/warcraft_command.gd`, `ports/warcraft_command_sink.gd`, `orders/command_dispatcher.gd` |
| Новый unit order | `model/warcraft_order.gd`, `orders/order_*.gd` |
| Общая функция rules, не принадлежащая одному order | `warcraft_runtime/rules/` |
| Карта, passability, pathfinding, fog grid | `warcraft_runtime/map/` |
| AI directive/build order/wave | `warcraft_runtime/ai/` |
| Mission trigger/script adapter | `warcraft_runtime/scripting/` |
| Данные для HUD/command panel | `warcraft_runtime/ports/*ui*`, `ports/warcraft_command_query.gd` |
| Данные для рендера мира | `warcraft_runtime/ports/*change_buffer.gd` |
| Сцена/спрайт/камера/миникарта | `game/presentation/` |
| HUD/menu/overlay | `ui/` |
| Новый visual/audio mapping | `content/schema/presentation/`, `content/catalogs/` |
| Новый runtime asset | `content/assets/` |
| Reference report/importer | `tools/import/`, `content/imported/` |
| Unit/reference test | `tests/unit/` или `tests/integration/` |
| Performance benchmark | `tests/performance/` |
| Test fixture/snapshot | `tests/fixtures/` |
| Debug overlay/diagnostics | `debug/` |

---

## Как строить проект

1. **Reference pipeline:** научиться получать reports по units/buttons/map/mission
   из локального Wargus и установленной игры.
2. **Runtime skeleton:** `UnitHandle`, `UnitType`, `Player`, `WarcraftCommand`,
   `WarcraftOrder`, `GameCycle`, snapshot.
3. **Первый playable slice:** Human mission 01: peasant, farm, town hall, barracks,
   footman, gold/wood, build/train/move/attack, objectives.
4. **Расширение orders:** repair, patrol, attack-ground, transport, oil, spells.
5. **Campaign/AI:** mission scripts, AI build orders, attack waves, difficulty.
6. **Performance pass:** benchmark, native candidates, memory/FPS budget.

Дальше следующего этапа не идем, пока текущий не запускается, не имеет test/reference
case и не описан в sprint/report docs.
