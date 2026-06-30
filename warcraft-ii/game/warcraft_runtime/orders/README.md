# warcraft_runtime/orders

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** основное поведение units/buildings как в Warcraft II/Wargus.
Большинство переносимых механик должно попадать сюда: Warcraft II ощущается через
orders, их фазы, таймеры, targets и edge cases.

## Порядок в game cycle

Точный порядок сверяется с Wargus/Stratagus reference и фиксируется в
`docs/porting/wargus_runtime_mapping.md`.

```text
command_dispatcher -> order_* updates -> rules -> AI scheduler -> lifecycle
```

## Файлы

| Файл | Назначение |
|---|---|
| `command_dispatcher.gd` | Проверка `WarcraftCommand`, назначение/отмена orders. |
| `order_move.gd` | Move, stop, patrol movement phase. |
| `order_attack.gd` | Attack, attack-ground, return fire, hold/stand behavior. |
| `order_resource.gd` | Harvest, return-goods, gold/wood/oil cycle. |
| `order_build.gd` | Build placement, construction, repair, cancel-build. |
| `order_train.gd` | Train-unit, research, upgrade-to, queues/cancel. |
| `order_spell.gd` | Cast-spell, mana, target validation, launch effects. |
| `order_transport.gd` | Load, unload, passenger behavior. |

## Инварианты

- Не переносим “по ощущениям”: у каждого order есть source/reference.
- Order не создает Godot nodes.
- Hot loops не создают временные `Dictionary`, lambda и большие объекты.
- Если поведение расходится с Wargus, отличие фиксируется в docs/known issues.
