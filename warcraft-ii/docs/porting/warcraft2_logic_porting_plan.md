# Warcraft II logic porting plan

Документ фиксирует, какие части логики Warcraft II переносятся, откуда брать
reference information, куда класть реализацию в проекте и чем проверять
соответствие. Цель - не byte-perfect копия, а gameplay-equivalent порт с
архитектурой, пригодной для слабого железа.

## Главный принцип

Не создаем отдельный модуль `warcraft_logic`. Логика раскладывается по уже
существующим слоям проекта:

```text
reference source -> content data -> Simulation systems -> ports -> Presentation/UI
```

Wargus Lua/C++ и извлеченные Warcraft II материалы нельзя переносить напрямую в
кодовую базу без отдельного лицензионного решения. Их можно использовать как
справочник, после чего записывать наши схемы, каталоги, тесты и документацию.

## Где лежит runtime-логика

| Область | Основное место | Что туда попадает |
| --- | --- | --- |
| Entity ids, commands, orders, events | `game/simulation/core/` | Универсальные команды, события, приказы, очередь команд. |
| Компонентные данные | `game/simulation/storage/` | Health, movement, ownership, worker, production, projectile, terrain runtime. |
| Правила матча | `game/simulation/systems/` | Движение, бой, экономика, строительство, производство, видимость, cleanup. |
| Карта, занятость, видимость | `game/simulation/spatial/` | Grid, occupancy, reservations, visibility, spatial index. |
| Поиск пути | `game/simulation/navigation/` | A*, path requests, group movement, path cache. |
| Миссии и триггеры | `game/scenario/` | Условия победы, briefing, tutorial, mission actions. |
| AI | `game/simulation/ai/` и `game/simulation/systems/ai_system.gd` | Директивы, экономика, армия, атаки. |
| Runtime data | `content/schema/gameplay/`, `content/catalogs/`, `content/balance/` | Юниты, здания, атаки, технологии, карты, фракции. |
| Visual/audio mapping | `content/schema/presentation/`, `content/catalogs/` | Visual ids, sprite banks, animation banks, audio banks. |
| Import/validation tools | `tools/import/`, `tools/*validation*`, `tools/map_baker.gd` | Reference readers, reports, validation, baking. |

## Портинговая таблица

| Warcraft II область | Reference source | Наши данные | Runtime module | Проверка |
| --- | --- | --- | --- | --- |
| Match/session, игроки, команды, расы | `scripts/wc2.lua`, map `.sms/.smp` | `match_config`, `factions.tres`, map definitions | `game/match/`, `side_storage` | Создать матч с теми же player slots, race, resources. |
| Карта, terrain, start view | `.sms/.smp`, `scripts/tilesets/*.lua` | `map_logic_definition.gd`, `map_visual_definition.gd`, baked arrays | `spatial/map_grid`, `terrain_runtime_storage`, `map_renderer` | Размер карты, tiles, passability, start views совпадают с reference report. |
| Passability и строительство | tileset flags: `land`, `water`, `forest`, `rock`, `unpassable`, `no-building` | terrain flags, placement rules | `terrain_system`, `construction_system`, occupancy grids | Юнит не проходит через forest/rocks/water; здание нельзя поставить на forbidden tiles. |
| Юниты и здания | `scripts/*/units.lua`, `scripts/units.lua` | `units.tres`, `buildings.tres`, `attacks.tres` | `entity_factory`, storages, systems | Создание сущности дает правильные компоненты и footprint. |
| Команды игрока | `scripts/commands.lua`, buttons/icons metadata | command definitions, button ids | `input/command_composer`, `command_system` | UI/input не меняют Simulation напрямую; все идет через `GameCommand`. |
| Движение | unit speed fields, map passability | movement definition, speed, movement class | `movement_system`, `navigation_service` | Юнит строит путь по grid и не проходит через blocked occupancy. |
| Бой | unit attack fields, missiles, armor/damage data | `attack_definition.gd`, projectile definitions | `combat_system`, `projectile_system`, `health_storage` | Cooldown, target filters, projectile/hit events работают через Simulation. |
| Добыча и ресурсы | worker commands, resources, gold mine/oil/wood metadata | worker/resource definitions | `economy_system`, `worker_storage`, `resource_node_storage` | Worker harvest/carry/return cycle меняет ресурсы стороны. |
| Строительство | building definitions, requirements, costs | building definitions, construction data | `construction_system`, `production_system` | Placement, cost, progress, completion, cancel rules. |
| Производство и технологии | train/research/upgrade metadata | production queues, technologies | `production_system`, `technology_definition.gd` | Queue progresses by tick and unlocks units/upgrades. |
| Fog/visibility | view range, map visibility behavior | vision definitions | `visibility_system`, `visibility_grid` | Explored/visible buffers меняются по движениям units/buildings. |
| AI | `scripts/ai/*`, campaign `_c.sms` AI calls | AI directives, plans, difficulty profiles | `ai/`, `ai_system` | AI создает обычные `GameCommand`, не меняет storages напрямую. |
| Scenario/triggers | campaign `.sms`, briefing steps, trigger calls | mission/condition/action definitions | `game/scenario/` | Victory/defeat/objectives проверяются scenario-owned логикой. |
| Animation mapping | `scripts/*/anim.lua`, unit `Image` fields | animation banks, visual definitions | `game/presentation/render/animation_clock.gd` | Presentation проигрывает states по data-driven system, Simulation не знает PNG. |
| Sound groups | `scripts/sound.lua` | `audio_banks.tres` | `match_audio_presenter`, `services/audio` | Simulation events приводят к правильным sound groups. |

## Этапы переноса

1. Выбрать маленький vertical slice: одна карта, Human worker, melee unit,
   town hall, ресурс, базовая атака.
2. Создать reference report в `content/imported/` без оригинальных ассетов.
3. Заполнить/уточнить gameplay schemas и catalogs.
4. Реализовать недостающие storage/system функции в Simulation.
5. Добавить presentation mapping только после того, как Simulation state/events
   понятны.
6. Добавить тест: unit/integration/manual smoke.
7. Обновить `mechanics_matrix.md`: источник, статус, тест.

## Что добавлять в структуру

Нужны не новые runtime-модули, а портинговая инфраструктура:

```text
docs/porting/
tools/import/
content/imported/
```

`docs/porting/` объясняет процесс. `tools/import/` читает локальные reference
sources и генерирует отчеты/черновики. `content/imported/` хранит наши
промежуточные отчеты и таблицы, которые можно коммитить, если они не содержат
оригинальных ассетов или GPL-кода.

## Запрещено

- Копировать GPL-код Wargus в Godot runtime.
- Коммитить оригинальные Warcraft II PNG/WAV/SMK/SMS/PUD/extracted assets без
  отдельного права.
- Встраивать правила Simulation в UI, Presentation или Godot Node.
- Делать импорт так, чтобы для запуска проекта требовалась локальная купленная
  игра.
- Хранить gameplay data только в дизайнерских картинках или Godot-сценах.

## Definition of Done для переноса механики

Механика считается перенесенной, если:

- есть строка или источник в `mechanics_matrix.md`;
- runtime data лежит в `content/schema/*` и `content/catalogs/*`;
- логика реализована в правильной системе Simulation/Scenario;
- вход идет через `GameCommand`, если это действие игрока/AI/scenario;
- выход идет через events, dirty buffers или ViewData;
- есть тест или ручной тест-кейс;
- reference-only материалы не попали в коммит;
- ограничения записаны явно.
