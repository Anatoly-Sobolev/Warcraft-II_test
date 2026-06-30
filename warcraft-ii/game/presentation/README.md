# presentation

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md) · 🎨 [Интеграция визуала](../../docs/design/visual_integration.md)

**Ответственность:** показать мир: карта, units/buildings/missiles, интерполяция,
анимации, эффекты, выделение, туман, миникарта, камера, игровой звук.
Presentation ничего не решает в gameplay.

**Владелец состояния:** камера, визуальные пулы, локальный графический профиль.

## Контракт

- **Принимает:** dirty buffers и events из `warcraft_runtime/ports`,
  `SelectionPresentationData` и `CameraIntent` из input, запросы из scenario.
- **Отдает:** состояние камеры через `camera_control_port`; sound requests через
  `match_audio_presenter`/`services/audio`.
- **Запрещено:** считать урон, путь, экономику, видимость или доступность команд;
  читать `warcraft_runtime/state` напрямую.

## Корневые файлы

| Файл | Назначение |
|---|---|
| `world_view.tscn` / `world_view.gd` | Корневая сцена мира. |
| `presentation_controller.gd` | Координация рендера за кадр. |
| `render_sync.gd` | Чтение `render_change_buffer`, связь `UnitHandle -> View`. |
| `camera_control_port.gd` | Прием `CameraIntent`. |
| `camera_snapshot.gd` | Сериализуемое состояние камеры. |

## Подмодули

| Папка | Назначение |
|---|---|
| `views/` | Unit/building/projectile/effect views. |
| `render/` | Entity/map/fog/selection renderers, animation clock, culling. |
| `pools/` | Переиспользование сцен. |
| `camera/` | Camera state/controller/bounds. |
| `minimap/` | Minimap rendering. |
| `audio/` | Mapping runtime events to sound groups. |

## Инварианты

- `View` не имеет игровой логики.
- Visual/audio ids приходят из content catalogs.
- Presentation может интерполировать кадры, но не меняет runtime result.
