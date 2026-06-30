# warcraft_runtime

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md)

**Ответственность:** авторитетное ядро порта Warcraft II. Здесь живут `Unit`,
`UnitType`, `Player`, `Order`, `Map`, `GameCycle`, combat, economy, fog, AI,
mission-facing events и сохраняемое состояние матча.

Это не универсальная RTS-симуляция. Runtime намеренно повторяет Wargus/Stratagus
concepts, чтобы студент переносил существующие механики, а не проектировал новые.

## Ключевая идея

```text
Wargus/Warcraft source -> Warcraft concept -> runtime order/rule -> test
```

Поведение юнита обычно переносится через `orders/`, а не через абстрактные системы.
Производительное хранение допускает плотные массивы и native code, но наружная
модель остается понятной: unit, player, order, map, game cycle.

## Контракт

- **Принимает:** `WarcraftCommand`, AI directives, mission/script steps.
- **Отдает:** runtime events, dirty buffers, UI snapshots, save snapshots.
- **Запрещено:** обращаться к Godot scenes, UI, Presentation, audio, platform или
  файловой системе из горячего gameplay-кода.
- **Performance:** pathfinding, fog, mass order update и combat batch должны иметь
  benchmarks до оптимизации или native-переноса.

## Корневые файлы

| Файл | Назначение |
|---|---|
| `warcraft_runtime.gd` | Фасад runtime: state, game cycle, ports. |
| `game_cycle_runner.gd` | Fixed `GameCycle`, накопление времени, catch-up лимиты. |
| `runtime_config.gd` | Tick rate, budgets, Lua/native flags. |
| `runtime_snapshot.gd` | Явное сериализуемое состояние runtime. |

## Подмодули

| Папка | Что внутри | README |
|---|---|---|
| `model/` | UnitHandle, UnitType/Order/Command concepts, events, RNG | [→](model/README.md) |
| `state/` | Производительное runtime state для units, players, map-facing data | [→](state/README.md) |
| `orders/` | Move, attack, harvest, build, train, spell, transport behavior | [→](orders/README.md) |
| `rules/` | Terrain, visibility, missiles, status effects, lifecycle | [→](rules/README.md) |
| `map/` | Logical map, occupancy, fog, pathfinding | [→](map/README.md) |
| `ai/` | Wargus-style AI directives, build orders, attack waves | [→](ai/README.md) |
| `scripting/` | Lua/SMS adapters and mission trigger mapping | [→](scripting/README.md) |
| `native/` | Future C++/GDExtension hot paths after benchmark | [→](native/README.md) |
| `ports/` | Единственные двери наружу | [→](ports/README.md) |

## Инварианты

- Runtime state меняется только внутри `warcraft_runtime/`.
- UI/Presentation/Scenario не читают `state/` напрямую.
- `WarcraftCommand` и `WarcraftOrder` должны сохранять Wargus/Warcraft semantics.
- Любая новая механика указывает source в `mechanics_matrix.md`.
- Любой hot path имеет performance test перед оптимизацией.
