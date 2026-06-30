# presentation

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md) · 🎨 [Интеграция визуала](../../docs/design/visual_integration.md)

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

## Визуальные данные и анимации

- Визуальные id, sprite banks, animation banks и audio banks должны приходить из
  `content/schema/presentation/` и `content/catalogs/`, а не быть захардкожены в
  Simulation.
- `views/` содержит сцены отображения сущностей: unit, building, projectile,
  effect. Эти сцены не являются игровыми объектами и не владеют правилами матча.
- `render/animation_clock` и renderer-слой выбирают кадры и визуальные состояния
  по подготовленным данным, событиям и dirty-буферам.
- Анимации атаки, движения, смерти, заклинаний и эффектов относятся к
  Presentation, но их правила соответствия Warcraft II фиксируются в
  `docs/gameplay/mechanics_matrix.md` (`PRES-001` ... `PRES-003`).
- Runtime-анимации должны быть data-driven: spritesheet/atlas, frame size,
  animation states и markers. Подробный контракт: [`../../docs/design/data_driven_animation_system.md`](../../docs/design/data_driven_animation_system.md).

## Инварианты
- У `View` нет игрового `_process()`; позиции интерполируются централизованно.
- Графический профиль не меняет результат симуляции.
- Presentation не создает UI-кнопки и не обрабатывает команды игрока.
- `AnimationPlayer` или отдельная сцена допустимы только как тонкая оболочка
  отображения. Источник states, frames и markers должен быть в content data.
