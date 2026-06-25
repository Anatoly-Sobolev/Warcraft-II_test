# presentation

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md)

**Ответственность:** показать мир — карта, спрайты сущностей, интерполяция, анимации,
визуальные снаряды и эффекты, выделение, туман, миникарта, камера, игровой звук.
**Ничего не считает.**
**Владелец состояния:** камера (`CameraState`), визуальные пулы, локальный графический профиль.

## Контракт
- **Принимает:** dirty-буферы и события из `simulation/ports`; `SelectionPresentationData` и `CameraIntent` из `input`; запросы из `scenario_presentation_port`.
- **Отдаёт:** камера принимает `CameraIntent` через `camera_control_port`. Звук играет `services/audio` по выбору `match_audio_presenter`.
- **Запрещено:** считать урон/путь/экономику/видимость; читать внутренние сетки и хранилища `simulation`.

## Корневые файлы
| Файл | Назначение |
|---|---|
| `world_view.tscn` / `world_view.gd` | Корневая сцена представления мира. |
| `presentation_controller.gd` | Координация рендера за кадр. |
| `render_sync.gd` | Чтение `render_change_buffer`, связь `EntityId → View`. |
| `camera_control_port.gd` | Приём `CameraIntent` извне. |
| `camera_snapshot.gd` | Сериализуемое состояние камеры. |

## Подмодули
| Папка | Назначение |
|---|---|
| `views/` | Сцены/скрипты `unit/building/projectile/effect` View. |
| `render/` | `entity_renderer`, `animation_clock`, `view_culling`, `map/fog/selection_renderer`. |
| `pools/` | Переиспользование временных сцен (`scene_pool`, `pool_registry`). |
| `camera/` | `camera_controller` (владелец `camera_state`), границы. |
| `minimap/` | `minimap_renderer` (ограниченная частота). |
| `audio/` | `match_audio_presenter` — выбор звуков по событиям. |

## Инварианты
- У `View` нет игрового `_process()`; позиции интерполируются централизованно.
- Графический профиль не меняет результат симуляции.
