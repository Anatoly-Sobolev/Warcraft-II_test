# warcraft_runtime/state

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** runtime-состояние матча в форме, пригодной для мобильных устройств ОС Аврора.
Имена файлов близки к Warcraft concepts, но хранение внутри может быть
data-oriented или native.

## Файлы

| Файл | Назначение |
|---|---|
| `unit_type_state.gd` | Runtime refs на UnitType/building/missile definitions. |
| `position_state.gd` | Tile/subtile position, direction, movement layer. |
| `ownership_state.gd` | Owner player, team/diplomacy refs. |
| `unit_vitals_state.gd` | HP, mana, armor, death flags. |
| `order_state.gd` | Current/saved order, target, phase, timers. |
| `movement_state.gd` | Speed, path, stuck state. |
| `combat_state.gd` | Attack profile, cooldown, range, target. |
| `worker_state.gd` | Carried resource, harvest target, return depot. |
| `building_state.gd` | Footprint, construction progress, rally point. |
| `resource_node_state.gd` | Gold mine, oil patch, resource counters. |
| `terrain_state.gd` | Runtime terrain changes and depleted cells. |
| `production_state.gd` | Train/research/upgrade queues. |
| `spell_state.gd` | Mana, cooldowns, spell runtime fields. |
| `status_effect_state.gd` | Buff/debuff source, target, duration, stacks. |
| `missile_state.gd` | Warcraft missile/projectile runtime data. |
| `transport_state.gd` | Passengers, capacity, unload state. |
| `player_state.gd` | Players: controller, race, resources, supply, tech. |
| `vision_state.gd` | Sight source data. |
| `score_state.gd` | Statistics and mission result counters. |

## Инварианты

- Наружу не возвращаются изменяемые массивы.
- Save snapshot хранит только authoritative state, не render cache.
- Добавление поля начинается с Wargus/original source и теста.
