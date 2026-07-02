# Warcraft II logic porting plan

Документ фиксирует, как переносить логику Warcraft II/Wargus в текущий проект.
Цель - gameplay-equivalent порт с новыми ассетами, простой для студентов и
достаточно быстрый для мобильных устройств на ОС «Аврора».

## Главный принцип

Не строим новую RTS-архитектуру поверх Godot. Строим Warcraft II-compatible runtime:

```text
reference source -> runtime concept -> order/rule/adapter -> test/reference case
```

Где:

- **reference source** — Wargus Lua/C++/SMS/SMP/PUD, локально установленная игра,
  проверенный ручной reference;
- **runtime concept** — `UnitType`, `Unit`, `Player`, `Order`, `Map`, `GameCycle`,
  `Trigger`, `AI directive`;
- **order/rule/adapter** — код в `game/warcraft_runtime/`;
- **test/reference case** — unit/integration/performance/manual проверка.

Wargus source используется как технический reference. В проект попадает
собственная реализация в понятном runtime/adapter слое с source metadata.

## Где лежит runtime-логика

| Область | Основное место | Что туда попадает |
| --- | --- | --- |
| Unit, Player, Command, Order, Event | `game/warcraft_runtime/model/` | Warcraft-compatible concepts and handles. |
| Runtime state | `game/warcraft_runtime/state/` | Units, players, orders, combat, worker, production, spells, missiles. |
| Unit behavior | `game/warcraft_runtime/orders/` | Move, attack, harvest, build, train, spell, transport behavior. |
| Shared rules | `game/warcraft_runtime/rules/` | Terrain, visibility, missiles, status effects, lifecycle. |
| Map/path/fog | `game/warcraft_runtime/map/` | Logical map, occupancy, pathfinding, fog grids. |
| AI | `game/warcraft_runtime/ai/` | Wargus-style AI directives, build orders, attack waves. |
| Lua/SMS adapters | `game/warcraft_runtime/scripting/` | Mission trigger/action mapping, script adapters. |
| Native hot paths | `game/warcraft_runtime/native/` | GDExtension/C++ only after benchmark. |
| Runtime ports | `game/warcraft_runtime/ports/` | Input/UI/Presentation/Scenario boundary. |
| UI-facing mission shell | `game/scenario/` | Objectives, briefing, dialogue, tutorial overlays. |
| Runtime data | `content/schema/gameplay/`, `content/catalogs/` | UnitType, buildings, attacks, technologies, maps, factions. |
| Visual/audio mapping | `content/schema/presentation/`, `content/catalogs/` | Visual ids, sprite banks, animation banks, audio banks. |
| Import/validation | `tools/import/`, `content/imported/` | Reference readers, converted reports, validation. |

## Портинговая таблица

| Warcraft II область | Reference source | Наши данные | Runtime module | Проверка |
| --- | --- | --- | --- | --- |
| Match/session, players, teams, races | `scripts/wc2.lua`, map `.sms/.smp` | `match_config`, `factions.tres`, map definitions | `game/match/`, `state/player_state.gd` | Same player slots, race, resources, diplomacy. |
| Map, terrain, start view | `.sms/.smp/.pud`, `scripts/tilesets/*.lua` | `map_logic_definition.gd`, baked arrays | `map/warcraft_map.gd`, `map/*occupancy*` | Same size, passability, start positions. |
| Unit/building definitions | `scripts/*/units.lua`, `scripts/units.lua` | `units.tres`, `buildings.tres`, `attacks.tres` | `model/unit_factory.gd`, `state/*` | Created unit has expected runtime fields and footprint. |
| Command buttons | `scripts/*/buttons.lua`, `scripts/buttons.lua` | button/action catalog | `input/command_composer`, `ports/warcraft_command_query.gd` | Same available commands/hotkeys for selection. |
| Move/stop/patrol | Wargus order behavior, unit speed, map passability | movement definitions | `orders/order_move.gd`, `map/path_service.gd` | Unit path and blocked tiles match reference scenario. |
| Attack/attack-ground/response | unit attack fields, missiles, armor/damage | attacks, projectiles | `orders/order_attack.gd`, `rules/missile_rules.gd` | Cooldown, target filters, hit/death events. |
| Harvest/return resources | worker commands, resource metadata | worker/resource definitions | `orders/order_resource.gd`, `state/worker_state.gd` | Worker cycle changes player resources. |
| Build/repair/cancel-build | building definitions, requirements, costs | building definitions | `orders/order_build.gd`, `rules/terrain_rules.gd` | Placement, cost, progress, completion, cancel. |
| Train/research/upgrade | train/research/upgrade buttons and tech data | production queues, technologies | `orders/order_train.gd`, `state/production_state.gd` | Queue progresses by GameCycle and unlocks content. |
| Spells/status effects | `scripts/spells.lua` | abilities, status effects | `orders/order_spell.gd`, `rules/status_effect_rules.gd` | Mana, target, duration, effect behavior. |
| Transport/naval/oil | unit scripts, buttons, campaign maps | transport/oil data | `orders/order_transport.gd`, `orders/order_resource.gd`, `map/` | Load/unload, oil tanker cycle, naval pathing. |
| Fog/visibility/minimap | view range, fog behavior | vision definitions | `rules/visibility_rules.gd`, `map/fog_of_war_grid.gd` | Visible/explored buffers change correctly. |
| AI | `scripts/ai/*`, campaign `_c.sms` AI calls | AI directives, difficulty profiles | `ai/` | AI emits commands/directives and respects budgets. |
| Scenario/triggers | campaign `.sms`, briefing steps, trigger calls | mission/action/condition definitions | `scripting/`, then `scenario/` | Victory/defeat/objectives match mission source. |
| Animation mapping | `scripts/*/anim.lua`, unit `Image` fields | animation banks, visual definitions | `presentation/render/animation_clock.gd` | Presentation follows runtime state/events. |
| Sound groups | `scripts/sound.lua` | `audio_banks.tres` | `presentation/audio`, `services/audio` | Runtime events map to correct sound groups. |

## Этапы переноса

1. **Reference reports:** units, buttons, map, mission 01. Никакой ручной перенос
   “по памяти”.
2. **Runtime concepts:** `UnitHandle`, `Player`, `WarcraftCommand`,
   `WarcraftOrder`, `GameCycle`, `runtime_snapshot`.
3. **Human mission 01 slice:** peasant, farm, town hall, barracks, footman,
   gold/wood, move/harvest/build/train/attack, objectives.
4. **Order expansion:** patrol, repair, attack-ground, transport, oil, spells.
5. **Campaign/AI:** mission script adapters, AI build orders, attack waves.
6. **Performance pass:** benchmark hot paths, move selected parts to native if
   needed.

## Что добавлять в структуру

```text
docs/porting/wargus_runtime_mapping.md
tools/import/
content/imported/
game/warcraft_runtime/scripting/
game/warcraft_runtime/native/
```

`tools/import/` читает локальные sources и генерирует reports/converted drafts.
`content/imported/` хранит коммитируемые reports. `scripting/` содержит adapters,
если выгоднее исполнять/адаптировать старые script concepts. `native/` остается
для горячих участков после измерений.

## Запрещено

- Добавлять оригинальные Warcraft II PNG/WAV/SMK/SMS/PUD/extracted assets как
  финальные ассеты проекта; они допускаются только как временные placeholders
  через manifest/catalog.
- Встраивать gameplay rules в UI, Presentation или Godot Node.
- Делать импорт так, чтобы release-сборке требовался локальный путь к купленной игре.
- Придумывать behavior без source/reference, если source существует.
- Переносить Lua/script behavior в hot per-unit loop без benchmark.

## Definition of Done для переноса механики

Механика считается перенесенной, если:

- есть строка или источник в `mechanics_matrix.md`;
- есть source metadata или reference report;
- runtime data лежит в `content/schema/*` и `content/catalogs/*`, если это data;
- behavior реализован в правильном `warcraft_runtime` order/rule/adapter;
- вход идет через `WarcraftCommand`/order/script API;
- выход идет через events, dirty buffers или snapshots;
- есть test/reference/manual case;
- ограничения и отличия от Wargus/original записаны явно.
