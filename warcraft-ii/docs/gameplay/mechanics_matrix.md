# Матрица механик Warcraft II

Этот документ нужен как контрольный список, чтобы при переносе Warcraft II в Godot не потерять игровую механику, лор, сюжетную линию и миссии. В него нельзя добавлять механику "по ощущениям". Каждая строка должна иметь источник в Warcraft II, Wargus/Stratagus, официальных/справочных материалах или проверку в оригинальной игре.

Цель проекта - gameplay-equivalent порт Warcraft II для ОС Аврора, а не byte-perfect реконструкция. Мы не занимаемся reverse engineering оригинальной игры. Отдельные технические отличия допустимы, особенно из-за мобильного формата, если сохраняются ключевые механики, темп, лор, сюжет и структура миссий.

## Правила источников

Основной локальный технический источник фактов сейчас: `C:\Users\UZER\Coding\Projects\wargus`.

Используем Wargus как справочник по правилам и структуре Warcraft II:


| Источник                                                                                                                       | Что из него брать                                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| `scripts/human/units.lua`, `scripts/orc/units.lua`, `scripts/units.lua`                                                        | Юниты, здания, нейтральные объекты, стоимость, HP, скорость, тип движения, атаки, цели, supply/demand, building rules. |
| `scripts/human/buttons.lua`, `scripts/orc/buttons.lua`, `scripts/buttons.lua`                                                  | Доступные команды игрока, кнопки, хоткеи, кто что может строить, тренировать, исследовать и кастовать.                 |
| `scripts/spells.lua`                                                                                                           | Способности, мана, цели заклинаний, условия, autocast/AI-cast, summon/TTL, урон, статусы.                              |
| `scripts/human/upgrade.lua`, `scripts/orc/upgrade.lua`, `scripts/upgrade.lua`                                                  | Апгрейды, зависимости, модификаторы, mission allow/deny.                                                               |
| `scripts/stratagus.lua`, `scripts/wc2.lua`                                                                                     | Общие правила: ресурсы, fog, игроки, расы, команды, AStar, лимиты, campaign/runtime setup, victory/defeat.             |
| `scripts/ai.lua`, `scripts/ai/*.lua`, `campaigns/**/*.sms`                                                                     | AI-эквиваленты рас, build orders, attack waves, mission AI, сложность.                                                 |
| `scripts/human/campaign*.lua`, `scripts/orc/campaign*.lua`, `campaigns/**/*_c.sms`                                             | Кампании, акты, порядок миссий, briefing, цели, условия победы/поражения.                                              |
| `maps/**/*.smp`, `maps/**/*.sms`, `campaigns/**/*.smp`, `campaigns/**/*.sms`, `doc/pud-specs.txt`, `pud.cpp`, `pudconvert.cpp` | Карты, стартовые позиции, игроки, terrain/resource layout, будущий importer.                                           |
| `scripts/sound.lua`, `scripts/*/anim.lua`, `scripts/icons.lua`, `scripts/ui.lua`                                               | Звуковые группы, анимационные состояния, UI/icon mappings.                                                             |


OpenRTS можно использовать только как инженерный референс для реализации, например flow-field, steering, tactical AI FSM, weapons/projectiles. OpenRTS не является источником механик Warcraft II.

Для лора, сюжета, описаний кампаний и общей проверки контекста можно использовать официальные руководства, проверенные справочные материалы и ручной просмотр оригинальной игры. Если Wargus и другой источник расходятся, фиксируем это в строке матрицы или known issues и выбираем вариант, который лучше сохраняет игровой опыт Warcraft II в рамках мобильного порта.

## Статусы


| Статус      | Значение                                                              |
| ----------- | --------------------------------------------------------------------- |
| `source`    | Механика подтверждена источником, но еще не перенесена в Godot.       |
| `design`    | Нужно спроектировать Godot-формат данных и границы систем.            |
| `implement` | Нужно реализовать систему/код.                                        |
| `verify`    | Нужно сравнить с Wargus и оригинальной игрой на конкретных сценариях. |
| `defer`     | Механика настоящая, но не входит в первый вертикальный срез.          |


## Первый вертикальный срез

Первый срез должен быть не "полная Warcraft II", а проверка, что архитектура выдерживает настоящий набор правил. Рекомендуемый срез: Human campaign mission 01.

Минимальный состав среза:

- карта из `campaigns/human/level01h.*`;
- player setup, стартовые ресурсы, стартовые юниты;
- Peasant, Farm, Town Hall, Barracks, Footman;
- gold/wood harvesting;
- строительство Farm/Barracks;
- training Peasant/Footman;
- выбор, move, stop, attack, harvest, build, train;
- fog/explored хотя бы в базовом виде;
- условия победы/поражения из `campaigns/human/level01h_c.sms`;
- HUD ресурсов, selection panel, command panel;
- save/load хотя бы для текущего состояния матча.

Все остальные механики ниже остаются в матрице, чтобы команда не забыла их при расширении.

## Матрица механик

### 1. Матч, игроки, фракции


| ID        | Механика                                                                                                                    | Источник                                                                                   | Godot-модуль                                                     | Требование к реализации                                                                                                   | Статус |
| --------- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------ |
| MATCH-001 | Игра идет в рамках одного match/session с текущей картой, игроками, seed/settings и состоянием победы/поражения.            | `scripts/stratagus.lua`, `scripts/wc2.lua`, `campaigns/**/*_c.sms`                         | `game/match`, `game/simulation`, `game/scenario`                 | `MatchConfig` создает Simulation, Scenario, Presentation, UI; результат матча уходит в Campaign.                          | design |
| MATCH-002 | Расовые стороны: Human, Orc, Neutral.                                                                                       | `scripts/wc2.lua`, `scripts/human/units.lua`, `scripts/orc/units.lua`, `scripts/units.lua` | `content/catalogs/factions.tres`, `side_storage`                 | Не смешивать race, player slot и diplomacy. Neutral используется для gold mine, oil patch, critters, special map objects. | source |
| MATCH-003 | Player slots, player type, стартовая позиция, ресурсы, race name.                                                           | `SetupPlayer`, `DefinePlayerTypes` в `scripts/wc2.lua`; campaign/map `.sms`                | `match_config`, `side_storage`, `scenario`                       | Карта/миссия задает активных игроков, race, AI/person/nobody/rescue/neutral, стартовые ресурсы и start view.              | source |
| MATCH-004 | Команды, союзники, враги, shared vision.                                                                                    | `SetMapTeams`, `SetupPlayer` в `scripts/wc2.lua`                                           | `side_storage`, `visibility_system`                              | Diplomacy влияет на target rules, shared vision и victory/defeat checks.                                                  | source |
| MATCH-005 | Цвета игроков.                                                                                                              | `DefinePlayerColors` в `scripts/stratagus.lua`                                             | `factions.tres`, `presentation/render`                           | Цвет игрока хранится как данные и применяется к sprites/palette shader.                                                   | source |
| MATCH-006 | Victory/defeat: дефолтно поражение при отсутствии юнитов, победа при отсутствии противников; миссии переопределяют условия. | `SinglePlayerTriggers` в `scripts/stratagus.lua`; `AddTrigger` в `campaigns/**/*_c.sms`    | `scenario/mission`, `match_result`                               | Всегда иметь scenario-owned conditions; дефолтные правила использовать только для skirmish.                               | source |
| MATCH-007 | Game speed / game cycle / difficulty влияют на AI и темп.                                                                   | `SetGameSpeed`, `GameCycle`, `GameSettings.Difficulty`, `AiSleep`, `AiForce`               | `simulation_runner`, `ai_controller`, `difficulty_profiles.tres` | Fixed tick в Godot должен отделять simulation step от FPS; difficulty хранится в data.                                    | source |


### 2. Карта, terrain, слои движения


| ID      | Механика                                                          | Источник                                                                                                                       | Godot-модуль                                                                | Требование к реализации                                                                                 | Статус |
| ------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------ |
| MAP-001 | Карта тайловая; есть логический слой и визуальный tileset.        | `maps/**/*.smp`, `campaigns/**/*.smp`, `scripts/tilesets/*`, `doc/pud-specs.txt`                                               | `map_logic_definition`, `map_visual_definition`, `map_grid`, `map_renderer` | Разделять logic grid и visual tiles. Импорт карты не должен создавать игровые Node на каждый тайл.      | design |
| MAP-002 | Tilesets: summer, winter, wasteland, swamp и wargus variants.     | `scripts/tilesets/*.lua`, `scripts/tilesets/wargus/*.lua`, unit `UnitTypeFiles`                                                | `content/assets/tilesets`, `map_visual_definition`                          | Tileset выбирает атлас terrain и варианты нейтральных/building sprites.                                 | source |
| MAP-003 | Типы прохода: land, naval, fly.                                   | `Type = "land"`, `Type = "naval"`, `Type = "fly"`, `LandUnit`, `SeaUnit`, `AirUnit` в unit scripts                             | `movement_storage`, `map_grid`, `static_occupancy_grid`                     | Pathfinding и target rules должны знать layer сущности: ground, sea, air.                               | source |
| MAP-004 | Занятость клеток статическими зданиями и динамическими юнитами.   | unit sizes/building definitions, `Building = true`, `BuildingRules`                                                            | `static_occupancy_grid`, `dynamic_occupancy_grid`, `reservation_grid`       | Строительство, движение и атака проверяют разные occupancy views.                                       | design |
| MAP-005 | Gold mine как neutral resource node.                              | `unit-gold-mine` в `scripts/units.lua`                                                                                         | `resource_node_storage`, `economy_system`                                   | Mine хранит остаток gold, доступна для harvest, видна на minimap как neutral.                           | source |
| MAP-006 | Forest/wood как ресурс terrain.                                   | `DefineDefaultActions`, wood harvest speed comments, `WoodImprove` flags                                                       | `terrain_runtime_storage`, `economy_system`, `terrain_system`               | Лес должен убывать/менять проходимость, wood returns в town hall/lumber mill equivalents.               | design |
| MAP-007 | Oil patch и oil platform.                                         | `unit-oil-patch`, `unit-human-oil-platform`, `unit-orc-oil-platform`                                                           | `resource_node_storage`, `construction_system`, `economy_system`            | Oil platform строится on top oil patch; patch заменяется/восстанавливается по source rules.             | source |
| MAP-008 | Shore buildings для shipyard/foundry/refinery.                    | `ShoreBuilding = true`, `BuildingRules` у shipyard/foundry/refinery                                                            | `construction_system`, `map_grid`                                           | Проверять береговую позицию и ограничения расстояния от oil patch/platform.                             | source |
| MAP-009 | Main facility нельзя строить слишком близко к gold mine.          | `BuildingRules` у town hall/keep/castle и orc equivalents                                                                      | `construction_system`                                                       | Проверка placement должна быть data-driven.                                                             | source |
| MAP-010 | Destroyed site/corpses/special neutral objects остаются на карте. | `unit-human-dead-body`, `unit-orc-dead-body`, `unit-destroyed-*`, `unit-circle-of-power`, `unit-dark-portal`, `unit-runestone` | `cleanup_system`, `terrain_system`, `scenario`                              | Не удалять все умершие сущности одинаково; corpse/site может быть условием spell/scenario/presentation. | source |


### 3. Ресурсы и экономика


| ID      | Механика                                                             | Источник                                                                                          | Godot-модуль                                                   | Требование к реализации                                                                       | Статус |
| ------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ------ |
| ECO-001 | Основные ресурсы Warcraft II: gold, wood, oil.                       | `DefineDefaultResourceNames`, unit costs, economy buttons                                         | `side_storage`, `economy_rules.tres`, `resource_bar`           | Не считать ore/stone/coal игровыми ресурсами Warcraft II без отдельного source proof.         | source |
| ECO-002 | Start resource presets: default/low/medium/high и mission overrides. | `SetPlayerData`, `GameSettings.Resources`, `.sms` setup                                           | `match_config`, `scenario`, `side_storage`                     | Skirmish и campaign получают ресурсы разными путями, но пишут в один storage.                 | source |
| ECO-003 | Worker harvest: gold mine и wood.                                    | `Action = "harvest"`, worker units, `GivesResource = "gold"`, `CanHarvest = true`                 | `worker_storage`, `economy_system`, `command_system`           | Worker имеет order: go to resource, gather, return, repeat.                                   | source |
| ECO-004 | Return goods вручную.                                                | `Action = "return-goods"` в buttons                                                               | `command_system`, `economy_system`                             | Команда заставляет worker/tanker вернуться с грузом.                                          | source |
| ECO-005 | Oil economy: tanker, platform, refinery/shipyard haul oil.           | oil tanker units, oil platform, `SET HAUL OIL`, oil costs                                         | `worker_storage`, `economy_system`, `transport_system`         | Oil tanker не должен быть обычным worker; это naval resource carrier.                         | source |
| ECO-006 | Buildings improve production.                                        | `ImproveProduction = {"wood", 25}`, `ImproveProduction = {"oil", 25}`, main facility gold improve | `economy_system`, `building_storage`                           | Production bonus должен идти из data, не из hardcode.                                         | source |
| ECO-007 | Supply/demand.                                                       | `Supply = 4` у farms/pig farms, `Supply = 1` у town centers, `Demand = 1` у units                 | `side_storage`, `production_system`, `resource_bar`            | Training checks must respect supply limit.                                                    | source |
| ECO-008 | Unit/building costs include time and resources.                      | `Costs = {"time", ..., "gold", ..., "wood", ..., "oil", ...}`                                     | `production_system`, `construction_system`, `content/catalogs` | `time` is build/train duration, not a spendable stock resource unless mission says otherwise. | source |
| ECO-009 | Repair costs and repair command.                                     | `RepairCosts`, `RepairRange`, `AutoRepairRange`, `Action = "repair"`                              | `construction_system`, `worker_storage`, `health_storage`      | Repair validates target, distance, resources and building/unit repairability.                 | source |


### 4. Строительство, производство, tech tree


| ID        | Механика                                                                                                                                       | Источник                                                                                | Godot-модуль                                                   | Требование к реализации                                                                                                    | Статус |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------ |
| BUILD-001 | Worker builds basic and advanced structures.                                                                                                   | Peasant/Peon build buttons                                                              | `command_system`, `construction_system`                        | Build menu levels and allowed conditions come from button/catalog data.                                                    | source |
| BUILD-002 | Basic buildings: farm/pig farm, barracks, town hall/great hall, lumber mill, blacksmith, tower, wall.                                          | `scripts/human/buttons.lua`, `scripts/orc/buttons.lua`                                  | `buildings.tres`, `construction_system`                        | Wall buttons are present in Wargus with network/debug checks; verify original campaign policy before enabling in campaign. | source |
| BUILD-003 | Advanced buildings: shipyard, foundry, refinery, inventor/alchemist, stables/ogre mound, mage tower/temple, church/altar, aviary/dragon roost. | race buttons and unit definitions                                                       | `buildings.tres`, `construction_system`                        | Advanced menu availability is conditional, not always visible.                                                             | source |
| BUILD-004 | Town hall upgrade chain.                                                                                                                       | `upgrade-to` buttons: town hall -> keep -> castle; great hall -> stronghold -> fortress | `production_system`, `building_storage`                        | Upgraded building changes production, supply, tech availability and visual.                                                | source |
| BUILD-005 | Tower upgrade chain.                                                                                                                           | watch tower -> guard tower/cannon tower and orc equivalents                             | `production_system`, `combat_storage`, `building_storage`      | Tower upgrade changes attack type/range/targets and visual.                                                                | source |
| BUILD-006 | Unit training from specific buildings.                                                                                                         | `train-unit` buttons                                                                    | `production_system`, `content/catalogs/units.tres`             | Production building defines train list through data; no per-building script subclass.                                      | source |
| BUILD-007 | Research and unit upgrades from specific buildings.                                                                                            | `research` buttons, `DefineDependency`, `DefineModifier`                                | `technology_definition`, `production_system`, `ability_system` | Research changes catalog-derived runtime values and unlocks units/spells.                                                  | source |
| BUILD-008 | Mission-specific allow/deny.                                                                                                                   | `DefineAllow*` in campaign `_c.sms`                                                     | `scenario/mission`, `command_query`                            | Mission can hide/deny units, upgrades, spells and buildings independent of global tech tree.                               | source |
| BUILD-009 | Training queue enabled in Wargus.                                                                                                              | `SetTrainingQueue(true)`                                                                | `production_storage`, `queue_panel`                            | Queue behavior must be explicit. If original Warcraft II differs, mark and verify before final.                            | verify |


### 5. Команды игрока и ввод


| ID      | Механика                              | Источник                                                                      | Godot-модуль                                                 | Требование к реализации                                                            | Статус |
| ------- | ------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------------------------- | ------ |
| CMD-001 | Выбор юнитов, max selectable 18.      | `SetMaxSelectable(18)`                                                        | `selection_controller`, `input_state`, `selection_panel`     | Selection storage хранит EntityId; UI показывает группы и одиночный выбор.         | source |
| CMD-002 | Move.                                 | `Action = "move"`, `RightButtonMoves()`                                       | `command_composer`, `movement_system`                        | Right-click empty ground maps to move unless active command overrides.             | source |
| CMD-003 | Stop.                                 | `Action = "stop"`                                                             | `command_system`, `movement_system`, `combat_system`         | Stop clears active order and queue where applicable.                               | source |
| CMD-004 | Attack unit/target.                   | `Action = "attack"`                                                           | `command_system`, `combat_system`                            | Attack validates target layer and diplomacy.                                       | source |
| CMD-005 | Attack ground.                        | `Action = "attack-ground"` for ballista/catapult/battleship/juggernaut/groups | `command_system`, `projectile_system`                        | Ground attack targets position, not entity.                                        | source |
| CMD-006 | Patrol.                               | `Action = "patrol"`                                                           | `movement_system`, `command_system`                          | Patrol alternates path endpoints and enables combat behavior while patrolling.     | source |
| CMD-007 | Stand ground.                         | `Action = "stand-ground"`                                                     | `movement_system`, `combat_system`                           | Unit should hold position and still attack as rules allow.                         | source |
| CMD-008 | Explore.                              | `Action = "explore"` for air scouts and spell eye behavior                    | `movement_system`, `visibility_system`, `ai`                 | Explore needs autonomous target choice within map/fog.                             | source |
| CMD-009 | Harvest and return goods.             | `Action = "harvest"`, `Action = "return-goods"`                               | `economy_system`, `command_system`                           | Resource orders must be cancellable and serializable.                              | source |
| CMD-010 | Repair.                               | `Action = "repair"`                                                           | `construction_system`, `health_storage`                      | Requires worker, valid damaged target, resources, range.                           | source |
| CMD-011 | Build.                                | `Action = "build"`                                                            | `construction_system`, `command_composer`                    | Build is two-phase: choose structure, choose placement, then simulation validates. | source |
| CMD-012 | Train unit.                           | `Action = "train-unit"`                                                       | `production_system`, `queue_panel`                           | Queue and cancel train must expose UI state.                                       | source |
| CMD-013 | Research.                             | `Action = "research"`                                                         | `production_system`, `technology_storage`                    | Research consumes resources/time and unlocks modifier/spell/unit.                  | source |
| CMD-014 | Upgrade to.                           | `Action = "upgrade-to"`                                                       | `production_system`, `building_storage`                      | Upgrades existing entity type and preserves ownership/location.                    | source |
| CMD-015 | Cast spell.                           | `Action = "cast-spell"`                                                       | `ability_system`, `command_system`                           | Spell targeting can be self/unit/position; validation happens in simulation.       | source |
| CMD-016 | Unload.                               | `Action = "unload"` for transports                                            | `transport_system`, `command_system`                         | Transport unload validates shoreline/passable target and cargo.                    | source |
| CMD-017 | Cancel construction/training/upgrade. | global cancel buttons                                                         | `production_system`, `construction_system`, `command_system` | Cancel behavior must define refund/progress policy from source verification.       | verify |


### 6. Юниты, здания, нейтралы


| ID       | Механика                                                                                                                    | Источник                                                               | Godot-модуль                                                | Требование к реализации                                                            | Статус |
| -------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------------------- | ------ |
| UNIT-001 | Human land core: Peasant, Footman, Archer/Ranger, Knight/Paladin, Mage, Ballista, Dwarven Demolition Squad.                 | `scripts/human/units.lua`                                              | `units.tres`, `unit_visuals.tres`                           | Every unit is data plus components, not a Godot subclass per unit.                 | source |
| UNIT-002 | Orc land core: Peon, Grunt, Axethrower/Berserker, Ogre/Ogre Mage, Death Knight, Catapult, Goblin Sappers.                   | `scripts/orc/units.lua`                                                | `units.tres`, `unit_visuals.tres`                           | Mirror race equivalence through data, not hardcoded switch chains in systems.      | source |
| UNIT-003 | Air units: Gnomish Flying Machine, Gryphon Rider, Goblin Zeppelin, Dragon, hero air units.                                  | `Type = "fly"`, `AirUnit = true`                                       | `movement_storage`, `visibility_system`, `combat_system`    | Air units use fly movement and target rules; scouts can explore.                   | source |
| UNIT-004 | Naval units: Oil Tanker, Transport, Destroyer, Battleship/Juggernaut, Submarine/Turtle.                                     | `Type = "naval"`, `SeaUnit = true`                                     | `movement_storage`, `transport_system`, `combat_system`     | Naval pathing is separate from land; oil and transport depend on naval layer.      | source |
| UNIT-005 | Buildings are units with `Building = true`.                                                                                 | race unit files                                                        | `building_storage`, `health_storage`, `identity_storage`    | Building state should share entity id system but have separate storage components. | source |
| UNIT-006 | Neutral objects: gold mine, oil patch, critters, daemon, circle of power, dark portal, runestone, corpses, destroyed sites. | `scripts/units.lua`                                                    | `map_logic_definition`, `resource_node_storage`, `scenario` | Neutral objects may be targetable, harvestable, decorative or scenario-relevant.   | source |
| UNIT-007 | Flags: organic, undead, hero, volatile, coward, land/sea/air/building.                                                      | unit files, `scripts/spells.lua` conditions                            | `status_effect_storage`, `combat_storage`, `ability_system` | Spell/combat filters should read flags from data.                                  | source |
| UNIT-008 | Race equivalence: human/orc counterparts.                                                                                   | `HumanEquivalent`, `OrcEquivalent` in `scripts/wc2.lua`; `Ai*` helpers | `content/catalogs/factions.tres`, importer                  | Importer can use equivalence for skirmish race conversion and AI planning.         | source |


### 7. Движение, pathfinding, столкновения


| ID       | Механика                                                                | Источник                                                                     | Godot-модуль                                                | Требование к реализации                                                                                                  | Статус |
| -------- | ----------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------ |
| MOVE-001 | AStar pathfinding with fixed/moving unit costs and unseen terrain cost. | `AStar(...)` in `scripts/stratagus.lua`                                      | `grid_pathfinder`, `navigation_service`                     | Pathfinding must account for static obstacles, moving unit cost and fog/unseen policy.                                   | source |
| MOVE-002 | Different pathing per land/naval/fly.                                   | unit type flags                                                              | `map_grid`, `navigation_service`                            | Sea and land do not share passability; fly ignores most ground blockers but still obeys map bounds.                      | source |
| MOVE-003 | Group orders.                                                           | command buttons, Wargus groups, OpenRTS implementation reference             | `group_path_planner`, `reservation_grid`, `movement_system` | Group movement must avoid per-unit independent chaos; implementation can borrow ideas from OpenRTS flow fields/steering. | design |
| MOVE-004 | Transport loading/unloading.                                            | `CanTransport = {"LandUnit", "only"}`, `Action = "unload"`                   | `transport_storage`, `transport_system`                     | Cargo is saved in simulation snapshot and hidden from normal map occupancy while loaded.                                 | source |
| MOVE-005 | Attack movement / target pursuit.                                       | attack commands, AI scripts, OpenRTS tactical AI as implementation reference | `movement_system`, `combat_system`                          | Pursuit must be command-driven and respect stand-ground/patrol/attack-ground differences.                                | design |


### 8. Бой, урон, projectiles


| ID         | Механика                                                               | Источник                                                                    | Godot-модуль                                                       | Требование к реализации                                                                 | Статус |
| ---------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------ | --------------------------------------------------------------------------------------- | ------ |
| COMBAT-001 | Attack ranges, including min range for siege/towers.                   | `MinAttackRange`, `MaxAttackRange` in unit files                            | `combat_storage`, `combat_system`                                  | Range checks use catalog data and target footprint.                                     | source |
| COMBAT-002 | Target filters: land, sea, air.                                        | `CanTargetLand`, `CanTargetSea`, `CanTargetAir`                             | `combat_system`                                                    | Target validation must be shared by command, AI and autocast.                           | source |
| COMBAT-003 | Melee, ranged, siege and naval attacks use missiles/sounds/animations. | unit attack fields, `scripts/missiles.lua`, `scripts/sound.lua`, anim files | `projectile_system`, `match_audio_presenter`, `presentation/views` | Simulation owns hit/impact timing; presentation only draws projectile/effect.           | design |
| COMBAT-004 | Attack ground for artillery/naval artillery.                           | `Action = "attack-ground"`                                                  | `projectile_system`, `command_system`                              | Ground attack can miss moving units and affects area according to missile/effect rules. | source |
| COMBAT-005 | Damage, death, corpses and destroyed building sites.                   | death units, `cleanup_system` analog in Wargus units                        | `health_storage`, `cleanup_system`, `terrain_system`               | Cleanup may spawn corpse/destroyed-site entities before freeing original id.            | source |
| COMBAT-006 | Reveal attacker.                                                       | `SetRevealAttacker(true)`                                                   | `visibility_system`, `combat_system`                               | Attacking can temporarily reveal attacker according to Warcraft/Wargus rule.            | source |
| COMBAT-007 | Auto attack and defensive reactions.                                   | AI scripts, attack flags, OpenRTS tactical AI reference                     | `combat_system`, `ai_controller`                                   | Needs separate rules for idle auto-acquire, stand-ground, patrol and explicit attack.   | design |


### 9. Fog, visibility, minimap


| ID      | Механика                                                     | Источник                                                 | Godot-модуль                                                 | Требование к реализации                                                           | Статус |
| ------- | ------------------------------------------------------------ | -------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------- | ------ |
| VIS-001 | Fog of war enabled by default.                               | `FogOfWar = true`, `SetFogOfWar`, `SetFogOfWarType`      | `visibility_system`, `fog_renderer`                          | Keep visible/explored/hidden state per player.                                    | source |
| VIS-002 | Explored and hidden opacity levels for world/minimap.        | `SetFogOfWarOpacityLevels`, `SetMMFogOfWarOpacityLevels` | `fog_renderer`, `minimap_renderer`                           | Render config must be data-driven and cheap for weak PCs.                         | source |
| VIS-003 | Sight range per unit/building.                               | unit definitions, `Preference.ShowSightRange`            | `vision_storage`, `visibility_grid`                          | Sight updates dirty regions only, not full map every frame if avoidable.          | source |
| VIS-004 | Shared vision through teams/allies.                          | `SetSharedVision` in `SetupPlayer`                       | `visibility_system`, `side_storage`                          | Visibility query should combine allied sources only when shared vision is active. | source |
| VIS-005 | Revelation after loss of main facility.                      | `SetRevelationType("all-units")`                         | `visibility_system`, `scenario`                              | Implement as match/scenario rule, not renderer shortcut.                          | source |
| VIS-006 | Holy Vision and Eye of Kilrogg/Eye of Vision reveal/explore. | `spell-holy-vision`, `spell-eye-of-vision`               | `ability_system`, `visibility_system`                        | Summoned revealers/eyes need TTL and ownership.                                   | source |
| VIS-007 | Invisibility and visibility interaction.                     | `spell-invisibility`, `Invisible` variable               | `status_effect_system`, `visibility_system`, `combat_system` | Need explicit detection/targeting behavior verified against Wargus/original.      | verify |


### 10. Spells and status effects


| ID        | Механика                                                                                          | Источник                                                                | Godot-модуль                                                  | Требование к реализации                                                                         | Статус |
| --------- | ------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------ |
| SPELL-001 | Mana variable, mana cost and regen/enable rules.                                                  | `DefineVariables("Mana", ...)`, spell definitions                       | `ability_runtime_storage`, `ability_system`                   | Mana is runtime state; spell availability depends on unit and researched upgrade.               | source |
| SPELL-002 | Human paladin spells: Holy Vision, Healing, Exorcism.                                             | `spell-holy-vision`, `spell-healing`, `spell-exorcism`; paladin buttons | `abilities.tres`, `ability_system`                            | Healing targets organic damaged allies; Exorcism targets undead non-buildings.                  | source |
| SPELL-003 | Human mage spells: Fireball, Slow, Flame Shield, Invisibility, Polymorph, Blizzard.               | `scripts/spells.lua`, mage buttons                                      | `abilities.tres`, `status_effect_system`, `projectile_system` | Include target type, mana, range, repeat-cast and area effects.                                 | source |
| SPELL-004 | Orc ogre mage spells: Eye of Kilrogg, Bloodlust, Runes.                                           | double-head spell variants, orc buttons/upgrades                        | `abilities.tres`, `status_effect_system`                      | Double-head variants are separate Wargus spell ids but should map cleanly to unit ability data. | source |
| SPELL-005 | Orc death knight spells: Death Coil, Raise Dead, Whirlwind, Haste, Unholy Armor, Death and Decay. | `scripts/spells.lua`, orc buttons/upgrades                              | `abilities.tres`, `status_effect_system`, `projectile_system` | Raise Dead requires corpse; Death and Decay/Blizzard are repeat-cast area bombardment.          | source |
| SPELL-006 | Demolish for Dwarven Demolition Squad/Goblin Sappers.                                             | `spell-suicide-bomber`, buttons                                         | `ability_system`, `combat_system`, `cleanup_system`           | Self-targeted demolition deals area damage and kills caster.                                    | source |
| SPELL-007 | Status variables: Haste, Slow, Bloodlust, Invisible, UnholyArmor, TTL/Summoned.                   | spell actions/conditions                                                | `status_effect_storage`                                       | Status durations and stat modifiers must save/load deterministically.                           | source |
| SPELL-008 | Autocast and AI-cast rules.                                                                       | `autocast`, `ai-cast` blocks in spells                                  | `ability_system`, `ai_controller`                             | Autocast is not just UI; it is gameplay behavior with target filters and priorities.            | source |


### 11. Campaigns, сценарии, миссии


| ID       | Механика                                                           | Источник                                                                         | Godot-модуль                                                      | Требование к реализации                                                       | Статус |
| -------- | ------------------------------------------------------------------ | -------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------ |
| SCEN-001 | Base Human campaign: 4 acts, 14 missions, videos/victory step.     | `scripts/human/campaign1.lua`                                                    | `campaign_definition`, `campaign_progression`                     | Campaign data stores steps, act screens, map ids, victory screen.             | source |
| SCEN-002 | Base Orc campaign: 4 acts, 14 missions, videos/victory step.       | `scripts/orc/campaign1.lua`                                                      | `campaign_definition`, `campaign_progression`                     | Same format as Human, different race and assets.                              | source |
| SCEN-003 | Expansion Human campaign: 12 missions.                             | `scripts/human/campaign2.lua`, `campaigns/human-exp`                             | `campaign_definition`                                             | Include only if expansion content is in project scope.                        | defer  |
| SCEN-004 | Expansion Orc campaign: 12 missions.                               | `scripts/orc/campaign2.lua`, `campaigns/orc-exp`                                 | `campaign_definition`                                             | Include only if expansion content is in project scope.                        | defer  |
| SCEN-005 | Mission briefing with title, objectives, text, images, voice refs. | `Briefing(...)` in campaign `_c.sms`; `BriefingAction` in `scripts/database.lua` | `mission_definition`, `dialogue_definition`, `dialogue_overlay`   | Store references and text separately from runtime trigger logic.              | source |
| SCEN-006 | Mission goals and trigger conditions.                              | `AddTrigger(...)` in campaign `_c.sms`                                           | `trigger_definition`, `condition_definition`, `action_definition` | Need a small condition/action DSL, not hardcoded mission scripts.             | source |
| SCEN-007 | Mission unit/upgrade restrictions.                                 | `DefineAllow*` in campaign `_c.sms`                                              | `mission_runtime`, `command_query`, `production_system`           | Restrictions affect UI buttons and command validation.                        | source |
| SCEN-008 | Mission AI scripts and attack waves.                               | `DefineAi`, `AiNeed`, `AiSet`, `AiForce`, `AiAttackWithForce` in `_c.sms`        | `ai_directive`, `economy_planner`, `army_planner`                 | Import as declarative directives where possible; do not embed Lua logic.      | source |
| SCEN-009 | Rescue/capture/diplomacy style player types.                       | player types in Wargus and rescue/capture sounds                                 | `side_storage`, `scenario`                                        | Verify exact Warcraft II rescue/capture behavior before final implementation. | verify |
| SCEN-010 | Campaign progress, best scores and mission unlock.                 | `CampaignProgress`, campaign menu arrays                                         | `campaign_state`, `campaign_progression`                          | Save campaign progress outside match snapshot.                                | source |


### 12. AI


| ID     | Механика                                                                                                    | Источник                                                                        | Godot-модуль                                        | Требование к реализации                                                                    | Статус |
| ------ | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| AI-001 | Race-equivalent planning names: worker, barracks, city center, shooter, cavalry, mage, harbor, tanker, etc. | `scripts/ai.lua`                                                                | `ai_directive`, `factions.tres`                     | AI should plan in roles and resolve to race-specific unit ids.                             | source |
| AI-002 | Build orders: need buildings, set worker counts, research, upgrade, wait.                                   | `AiNeed`, `AiSet`, `AiWait`, `AiResearch`, `AiUpgradeTo` in AI/campaign scripts | `economy_planner`, `army_planner`                   | AI emits normal `GameCommand`; it must not mutate storage directly.                        | source |
| AI-003 | Attack forces and waves.                                                                                    | `AiForce`, `AiWaitForce`, `AiAttackWithForce`                                   | `army_planner`, `ai_controller`                     | Attack groups should be reproducible and saveable.                                         | source |
| AI-004 | Difficulty modifies resource cheats, speed and timing in Wargus.                                            | `AiLoop`, `AiSleep`, `AiForce`                                                  | `difficulty_profiles.tres`, `ai_controller`         | Treat Wargus difficulty behavior as source; verify if exact original behavior is required. | verify |
| AI-005 | Skirmish AI strategy names.                                                                                 | `DefineAi` wrapper and `scripts/ai/*.lua`                                       | `skirmish_config_builder`, `ai_controller`          | Skirmish AI is separate from campaign mission scripts.                                     | source |
| AI-006 | Tactical unit behavior: auto attack, attack back, return post, hold.                                        | Wargus combat behavior; OpenRTS `TacticalAI.java` as implementation reference   | `combat_system`, `ai_controller`, `movement_system` | Use Warcraft II/Wargus behavior for rules; OpenRTS can only inform engineering structure.                         | design |


### 13. UI, HUD, menus


| ID     | Механика                                                                                            | Источник                                                            | Godot-модуль                                     | Требование к реализации                                                         | Статус |
| ------ | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------- | ------ |
| UI-001 | Command panel built from buttons with Pos, Level, Icon, Action, Value, Allowed, Key, Hint, ForUnit. | `scripts/*/buttons.lua`                                             | `command_panel`, `command_query`                 | UI asks simulation/command query what buttons are legal for selection.          | source |
| UI-002 | Resource bar: gold, wood, oil, supply and optional time/objective data.                             | `ResourcesOnUI`, unit supply/demand                                 | `resource_bar`, `simulation_ui_query`            | Do not expose simulation storage directly to UI.                                | source |
| UI-003 | Selection panel: one unit, group, contextual unit groups.                                           | command buttons, Wargus group UI, OpenRTS command manager reference | `selection_panel`, `unit_icon`                   | Must handle mixed selection and command intersection.                           | design |
| UI-004 | Queue panel for training/research/build upgrades.                                                   | `SetTrainingQueue(true)`, cancel buttons                            | `queue_panel`, `production_storage`              | Shows queue progress and cancel entries.                                        | source |
| UI-005 | Minimap with terrain/fog/player colors.                                                             | `MinimapWithTerrain`, player colors, fog opacity                    | `minimap_renderer`, `minimap_panel`              | Minimap uses presentation data and fog/minimap buffers.                         | source |
| UI-006 | Menus: help, options, speed, sound, diplomacy, save, load, restart, quit.                           | `scripts/commands.lua`, `scripts/menus/*.lua`                       | `ui/screens`, `settings_service`, `save_service` | Menus pause single-player where source does; network behavior must be separate. | source |
| UI-007 | In-game hotkeys.                                                                                    | button `Key`, `HandleIngameCommandKey`                              | `input_controller`, `command_composer`           | Hotkeys come from data where possible.                                          | source |
| UI-008 | Tutorial/dialogue/briefing overlays.                                                                | `BriefingAction`, campaign briefing refs                            | `dialogue_overlay`, `tutorial_overlay`           | Keep briefing/dialogue data-driven and localizable.                             | source |


### 14. Audio, animation, presentation


| ID       | Механика                                                                           | Источник                                                             | Godot-модуль                                                      | Требование к реализации                                                    | Статус |
| -------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------- | ------ |
| PRES-001 | Unit/building sprite mappings per race/tileset.                                    | unit `Image` and `UnitTypeFiles`                                     | `sprite_banks.tres`, `unit_visuals.tres`, `building_visuals.tres` | Runtime references visual ids, not raw file paths inside simulation.       | source |
| PRES-002 | Animations: still, move, attack, death, spell/action variants.                     | `scripts/human/anim.lua`, `scripts/orc/anim.lua`, `scripts/anim.lua` | `animation_clock`, `unit_view`, `building_view`                   | Animation states follow simulation state/events.                           | source |
| PRES-003 | Missiles/effects visuals.                                                          | `scripts/missiles.lua`, `scripts/spells.lua`                         | `projectile_view`, `effect_view`, `projectiles.tres`              | Projectiles are simulation entities/events with presentation views.        | source |
| PRES-004 | Sound groups: selected, annoyed, acknowledge, ready, attack, building, spells, UI. | `scripts/sound.lua`                                                  | `audio_banks.tres`, `audio_service`, `match_audio_presenter`      | Audio presenter maps simulation events to sound groups.                    | source |
| PRES-005 | Music and cinematics/briefing media refs.                                          | `wargus.playlist`, campaign steps, `CreateVideoStep`                 | `audio_service`, `campaign UI`                                    | Store references only; original assets require rights/extraction pipeline. | source |
| PRES-006 | Palette/player color shader behavior.                                              | player colors, sprite assets                                         | `palette_shader.gdshader`, `entity_renderer`                      | Color remap must be cheap and data-driven.                                 | design |


### 15. Save/load, persistence, determinism


| ID       | Механика                                                 | Источник                                        | Godot-модуль                                                | Требование к реализации                                                         | Статус |
| -------- | -------------------------------------------------------- | ----------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------- | ------ |
| SAVE-001 | Save/load menus exist during single-player.              | `RunSaveMenu`, `RunGameLoadGameMenu`, `F11/F12` | `save_service`, `save_serializer`                           | Save includes match, simulation, scenario and pending commands.                 | source |
| SAVE-002 | Campaign progress separate from match save.              | `CampaignProgress`, `CampaignBestScores`        | `campaign_state`, `settings_service`                        | Campaign unlock/results are not stored only inside save slot.                   | source |
| SAVE-003 | Deterministic simulation state.                          | Wargus `GameCycle`, sync tests, command scripts | `simulation_snapshot`, `simulation_random`, `command_queue` | Save tick, RNG, entity ids, storages, orders, status durations, scenario state. | design |
| SAVE-004 | Restore transient presentation from authoritative state. | Current architecture docs                       | `presentation_controller`, `render_sync`                    | Do not save sprites/audio/UI cache; rebuild from snapshot.                      | design |


### 16. Import pipeline


| ID      | Механика/данные                         | Источник                                                                | Godot-модуль                                 | Требование к реализации                                                              | Статус |
| ------- | --------------------------------------- | ----------------------------------------------------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------ | ------ |
| IMP-001 | Import unit/building catalog.           | `scripts/human/units.lua`, `scripts/orc/units.lua`, `scripts/units.lua` | `tools/content_validation_tool.gd`, catalogs | Parse only supported fields first; keep source path and source line metadata.        | design |
| IMP-002 | Import command/button catalog.          | `scripts/*/buttons.lua`                                                 | `command_panel`, `command_query`             | Convert button actions to Godot command ids and ability ids.                         | design |
| IMP-003 | Import spells/upgrades/dependencies.    | `scripts/spells.lua`, `scripts/*/upgrade.lua`                           | `abilities.tres`, `technologies.tres`        | Preserve conditions, target types, mana, ranges, modifiers, unlocks.                 | design |
| IMP-004 | Import campaigns/missions.              | `scripts/*/campaign*.lua`, `campaigns/**/*_c.sms`                       | `campaign_definition`, `mission_definition`  | Convert mission scripts to declarative condition/action data where possible.         | design |
| IMP-005 | Import maps.                            | `.smp/.sms/.pud`, `doc/pud-specs.txt`, `pud.cpp`                        | `map_baker.gd`, map resources                | Separate terrain, resources, players, starting units and scenario script refs.       | design |
| IMP-006 | Import audio/animation/visual mappings. | `scripts/sound.lua`, `scripts/*/anim.lua`, `scripts/icons.lua`          | visual/audio catalogs                        | Store ids and references; do not commit proprietary extracted assets without rights. | design |
| IMP-007 | Validation reports.                     | All imported sources                                                    | `content_validation_tool.gd`, tests          | Every imported id must have schema, owner system, and unresolved source warnings.    | design |


## Полный список команд из Wargus-кнопок

Этот список получен из `Action =` в `scripts/human/buttons.lua`, `scripts/orc/buttons.lua`, `scripts/buttons.lua`.


| Команда                                                         | Назначение                                  |
| --------------------------------------------------------------- | ------------------------------------------- |
| `move`                                                          | Движение к позиции.                         |
| `stop`                                                          | Остановка текущего приказа.                 |
| `attack`                                                        | Атака цели.                                 |
| `attack-ground`                                                 | Атака позиции.                              |
| `patrol`                                                        | Патруль.                                    |
| `stand-ground`                                                  | Удерживать позицию.                         |
| `explore`                                                       | Разведка.                                   |
| `harvest`                                                       | Добыча/назначение добычи.                   |
| `return-goods`                                                  | Вернуть груз ресурсов.                      |
| `repair`                                                        | Ремонт.                                     |
| `build`                                                         | Построить здание.                           |
| `button`                                                        | Переключить уровень/страницу command panel. |
| `train-unit`                                                    | Тренировать/построить юнит.                 |
| `research`                                                      | Исследовать апгрейд/способность.            |
| `upgrade-to`                                                    | Улучшить здание/юнита до другого типа.      |
| `cast-spell`                                                    | Применить способность.                      |
| `unload`                                                        | Выгрузить транспорт.                        |
| `cancel`, `cancel-build`, `cancel-train-unit`, `cancel-upgrade` | Отмена действий.                            |


## Полный список spell ids из Wargus

Источник: `scripts/spells.lua`.


| Spell id                                                 | Категория                               |
| -------------------------------------------------------- | --------------------------------------- |
| `spell-holy-vision`                                      | Human vision/reveal.                    |
| `spell-healing`                                          | Human heal.                             |
| `spell-exorcism`                                         | Human anti-undead.                      |
| `spell-fireball`                                         | Human mage attack spell.                |
| `spell-slow`                                             | Human debuff.                           |
| `spell-flame-shield`                                     | Human area/status spell.                |
| `spell-invisibility`                                     | Human invisibility.                     |
| `spell-polymorph`                                        | Human transform.                        |
| `spell-blizzard`                                         | Human area bombardment.                 |
| `spell-eye-of-vision`, `spell-eye-of-vision-double-head` | Orc vision/summoned scout.              |
| `spell-bloodlust`, `spell-bloodlust-double-head`         | Orc buff.                               |
| `spell-runes`, `spell-runes-double-head`                 | Orc trap/area spell.                    |
| `spell-death-coil`                                       | Orc attack spell.                       |
| `spell-raise-dead`                                       | Orc corpse summon.                      |
| `spell-whirlwind`                                        | Orc area moving damage.                 |
| `spell-haste`                                            | Orc buff.                               |
| `spell-unholy-armor`                                     | Orc protection/status with health cost. |
| `spell-death-and-decay`                                  | Orc area bombardment.                   |
| `spell-suicide-bomber`                                   | Demolish for demolition/sapper units.   |


## Контрольные вопросы перед реализацией системы

Перед началом любой системы ответить письменно:

1. Какие строки этой матрицы закрывает система?
2. Какие Wargus-файлы являются источником поведения?
3. Какие поля должны быть в `.tres`/catalog data, а какие являются runtime state?
4. Какие команды игрока и AI будут входить в систему?
5. Что должно попасть в save snapshot?
6. Что должно уйти только в Presentation/UI?
7. Какой минимальный тест доказывает соответствие Warcraft II?

## Запреты

- Не добавлять механику без источника.
- Не считать OpenRTS источником Warcraft II-правил.
- Не копировать GPL-код Wargus в Godot без отдельного решения по лицензии.
- Не коммитить оригинальные Warcraft II ассеты без прав и понятного asset pipeline.
- Не прятать правила миссий в Godot-сценах; миссии должны быть data-driven.
- Не давать UI прямой доступ к simulation storage.
- Не делать юнитов отдельными Godot Node-классами с игровой логикой.
