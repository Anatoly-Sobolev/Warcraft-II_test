# warcraft_runtime/model

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** базовые Warcraft II/Wargus concepts, через которые переносится
runtime-логика: unit handle, command, order, event, RNG, game-cycle scheduling.

## Файлы

| Файл | Назначение |
|---|---|
| `unit_handle.gd` | Безопасная ссылка на unit slot: index + generation. |
| `unit_registry.gd` | Создание, reuse и освобождение unit slots. |
| `runtime_index.gd` | Плотные наборы индексов для быстрых проходов. |
| `unit_factory.gd` | Создание units/buildings/missiles из UnitType/catalog data. |
| `warcraft_command.gd` | Намерение игрока, AI или mission script. |
| `command_queue.gd` | Очередь команд по `GameCycle`. |
| `warcraft_order.gd` | Длительный приказ unit: move, attack, harvest, build... |
| `runtime_event.gd` | Завершившийся факт runtime. |
| `event_buffer.gd` | Пакеты событий по game cycle. |
| `runtime_random.gd` | Сохраняемый RNG. |
| `cycle_scheduler.gd` | Редкие проверки и budgeted work по циклам. |

## Инварианты

- Названия и enum values должны мапиться на Wargus/Warcraft sources.
- `UnitHandle == 0` означает отсутствие unit.
- Долгая ссылка хранит generation, чтобы reuse slot не ломал selection/order target.
- Model не знает про Godot scenes, sprites или UI.
