# warcraft_runtime/ports

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** единственные двери наружу. Input, UI, Presentation, Scenario
и Services общаются с runtime через эти типы, а не через `state/` или `map/`.

## Вход

| Файл | Кто использует | Назначение |
|---|---|---|
| `warcraft_command_sink.gd` | input, scenario, AI adapters | Прием `WarcraftCommand`. |

## Запросы

| Файл | Кто использует | Назначение |
|---|---|---|
| `selection_query.gd` | input, ui | Hit-test/selectable unit data. |
| `warcraft_command_query.gd` | ui, input | Доступные buttons/commands for selection. |
| `mission_query.gd` | scenario | Mission-facing facts without raw state access. |
| `runtime_event_reader.gd` | scenario, presentation, audio | Immutable event batches. |
| `runtime_ui_query.gd` | ui | Resources, production, tech, selected unit summary. |

## Данные наружу

| Файл | Кто использует | Назначение |
|---|---|---|
| `selection_view_data.gd` | ui/presentation | Prepared selection data. |
| `runtime_ui_data.gd` | ui | Versioned HUD snapshot. |
| `render_change_buffer.gd` | presentation | Unit/building/missile visual changes. |
| `terrain_change_buffer.gd` | presentation | Terrain visual changes. |
| `fog_change_buffer.gd` | presentation | Fog visibility deltas. |
| `minimap_change_buffer.gd` | presentation/ui | Minimap deltas. |

## Инварианты

- Ports не возвращают изменяемые массивы runtime state.
- UI не читает raw events там, где нужен prepared snapshot.
- Presentation не делает gameplay decisions по dirty buffers.
