# scenario

> ↑ [game](../README.md) · 🏛 [Архитектура](../../docs/architecture/architecture.md)

**Ответственность:** UI-facing слой миссии: objectives, briefing, dialogue,
tutorial, notifications and mission result presentation.

Mission logic из Wargus `.sms`/Lua сначала переносится или адаптируется в
`game/warcraft_runtime/scripting/`. `scenario/` показывает цели и диалоги, читает
runtime events и отправляет разрешенные `WarcraftCommand`/script steps.

## Корневые файлы

| Файл | Назначение |
|---|---|
| `scenario_controller.gd` | Координация mission-facing слоя. |
| `scenario_state.gd` | Objectives, dialogue state, tutorial state. |
| `scenario_snapshot.gd` | Сохраняемое состояние scenario shell. |
| `scenario_view_data.gd` | Данные для UI overlays. |
| `scenario_presentation_port.gd` | Запросы к Presentation. |

## Подпапки

- `mission/` — objectives, condition/action wrappers, mission view data.
- `narrative/` — sequence/dialogue runtime.
- `tutorial/` — tutorial runner and input rules.

## Инварианты

- Scenario не правит `warcraft_runtime/state` напрямую.
- Если поведение уже есть в Wargus mission script, сначала делается adapter/report.
- Scenario UI не должен подменять runtime victory/defeat checks без source.
