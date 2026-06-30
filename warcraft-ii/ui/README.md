# ui

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md) · 🎨 [Интеграция визуала](../docs/design/visual_integration.md)

**Статус: заглушка.** Реализуется частично (минимальный HUD в вертикальном срезе),
полностью — позже. README можно расширять по мере готовности экранов.

**Назначение (кратко):** меню, HUD, панели, оверлеи. Показывает готовые versioned
данные и превращает нажатия в запросы. Авторитетного состояния не хранит.

## Подмодули

| Папка | Назначение |
| --- | --- |
| `hud/` | Корневой HUD и его отдельные панели. `hud.tscn` только композитит дочерние компоненты. |
| `components/` | Переиспользуемые UI-компоненты: кнопки, tooltip, progress, modal, icon slot. |
| `overlays/` | Dialogue, tutorial, notifications и другие слои поверх матча. |
| `screens/` | Main menu, campaign select, settings, pause, result и другие экраны. |
| `theme/` | Godot Theme, UI tokens, шрифты, общие текстуры и стили. |
| `animation/` | Общие UI motion tokens и helper-скрипты. Локальные анимации лежат рядом с компонентом. |

## Правила HUD

- Не делать HUD одной большой сценой.
- Каждый самостоятельный элемент HUD должен иметь свою папку и сцену.
- `hud.tscn` отвечает за раскладку и передачу ViewData, но не за внутреннюю
  реализацию кнопок, resource bar, selection panel или minimap panel.
- UI-компоненты не читают `game/simulation/storage/`.
- Нажатия испускают сигналы наружу и дальше проходят через Input/Command flow.
  Компонент не создает и не применяет `GameCommand` самостоятельно.

Пример структуры command panel:

```text
ui/hud/command_panel/
  command_panel.tscn
  command_panel.gd
  command_button.tscn
  command_button.gd
```

## Входные данные

UI получает только подготовленные данные:

- `simulation_ui_query` и UI ViewData для ресурсов, supply, очередей;
- `selection_view_data` для выбранных сущностей;
- `command_query` или подготовленный `CommandPanelViewData` для доступных команд;
- Scenario ViewData для dialogue/tutorial overlays.

Если компоненту нужны новые данные, сначала добавляется явный ViewData/adapter
контракт. Запрещено "временно" читать внутренние поля Simulation.
