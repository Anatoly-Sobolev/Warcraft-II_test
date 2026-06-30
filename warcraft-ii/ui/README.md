# ui

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md) · 🎨 [Интеграция визуала](../docs/design/visual_integration.md)

**Ответственность:** меню, HUD, command panel, selection panel, minimap panel,
dialogue/tutorial overlays. UI показывает prepared snapshots и превращает нажатия
в requests; gameplay state не хранит.

## Подмодули

| Папка | Назначение |
| --- | --- |
| `hud/` | Корневой HUD и отдельные панели. |
| `components/` | Переиспользуемые UI-компоненты. |
| `overlays/` | Dialogue, tutorial, notifications. |
| `screens/` | Main menu, campaign select, settings, pause, result. |
| `theme/` | Godot Theme, UI tokens, fonts, shared textures. |
| `animation/` | UI motion helpers. |

## Правила HUD

- Не делать HUD одной большой сценой.
- Command panel строится из `warcraft_runtime/ports/warcraft_command_query` и
  Wargus-derived button data.
- Resource/selection/queue panels читают prepared `runtime_ui_data`, а не state.
- Нажатия идут наружу в Input/Command flow; UI-компонент не применяет команду сам.

## Входные данные

UI получает только подготовленные данные:

- `runtime_ui_query` / `runtime_ui_data` для ресурсов, supply, очередей;
- `selection_view_data` для выбранных units/buildings;
- `warcraft_command_query` для доступных commands/buttons;
- scenario view data для dialogue/tutorial overlays.

Если компоненту нужны новые данные, сначала добавляется явный ViewData/port
контракт. Запрещено временно читать `warcraft_runtime/state`.
