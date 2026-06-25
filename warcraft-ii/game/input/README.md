# input

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md)

**Ответственность:** получить события Godot, распознать жесты, хранить *кого выбрал
игрок*, и превратить действия в `GameCommand` или `CameraIntent`.
**Владелец состояния:** список выбранных `EntityId`, основной выбранный объект, активный режим команды, временное состояние жестов.

## Контракт
- **Принимает:** события ввода Godot, `TutorialInputRules` (ограничения от `scenario/tutorial`).
- **Отдаёт:** `GameCommand` в `simulation/ports/command_sink`; `CameraIntent` в `presentation`; `SelectionPresentationData` (только подсветка) в `presentation`; `InputActionSummary` в tutorial.
- **Запрещено:** принимать окончательное решение о допустимости действия (это делает `simulation`), хранить положение камеры.

## Зависит от
- `simulation/ports` (`command_sink`, `selection_query`, `command_query`), `presentation` (`camera_control_port`).
- **НЕ зависит от:** внутренних хранилищ `simulation`.

## Файлы
| Файл | Назначение |
|---|---|
| `input_controller.gd` | Единственная точка приёма событий Godot. |
| `input_state.gd` | Выбор, режим команды, временные жесты. |
| `input_snapshot.gd` | Устойчивое сериализуемое состояние (без активных жестов). |
| `gesture_recognizer.gd` | Распознавание касаний/перетаскиваний/pinch/long-press. |
| `selection_controller.gd` | Применение результатов `selection_query`. |
| `command_composer.gd` | Сборка компактного `GameCommand`. |
| `camera_intent.gd` | Намерение сдвинуть/масштабировать камеру. |
| `input_action_summary.gd` | Описание действия для tutorial (не команда). |
| `selection_presentation_data.gd` | `EntityId` + версия для подсветки в presentation. |
