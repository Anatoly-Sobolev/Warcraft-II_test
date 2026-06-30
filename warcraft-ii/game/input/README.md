# input

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md)

**Ответственность:** получить события Godot, распознать жесты/hotkeys, хранить
выбор игрока и превратить действия в `WarcraftCommand` или `CameraIntent`.

**Владелец состояния:** выбранные `UnitHandle`, основной выбранный объект, активный
режим команды, временное состояние жестов.

## Контракт

- **Принимает:** события ввода Godot, `TutorialInputRules`, UI button requests.
- **Отдает:** `WarcraftCommand` в `warcraft_runtime/ports/warcraft_command_sink`;
  `CameraIntent` в `presentation`; `SelectionPresentationData` для подсветки;
  `InputActionSummary` в tutorial.
- **Запрещено:** решать, доступна ли команда. Это делает `warcraft_runtime`.

## Зависит от

- `warcraft_runtime/ports`: `warcraft_command_sink`, `selection_query`,
  `warcraft_command_query`.
- `presentation`: `camera_control_port`.
- **Не зависит от:** `warcraft_runtime/state`.

## Файлы

| Файл | Назначение |
|---|---|
| `input_controller.gd` | Единственная точка приема событий Godot. |
| `input_state.gd` | Выбор, режим команды, временные жесты. |
| `input_snapshot.gd` | Устойчивое сериализуемое состояние input. |
| `gesture_recognizer.gd` | Касания, drag, pinch, long-press. |
| `selection_controller.gd` | Применение результатов `selection_query`. |
| `command_composer.gd` | Сборка compact `WarcraftCommand` из UI/input. |
| `camera_intent.gd` | Намерение сдвинуть/масштабировать камеру. |
| `input_action_summary.gd` | Описание действия для tutorial. |
| `selection_presentation_data.gd` | `UnitHandle` + version для подсветки. |
