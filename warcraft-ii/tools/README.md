# tools

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md)

**Ответственность:** инструменты разработки, import/reference pipeline and content
validation. Они запускаются вне игры и не должны становиться обязательной
runtime-зависимостью релизной сборки.

## Файлы

| Файл | Назначение |
|---|---|
| `content_validation_tool.gd` | Проверка IDs, source metadata, ссылок, requirements, локализации. |
| `map_baker.gd` | Карта/reference draft -> компактные runtime массивы. |
| `atlas_validation_tool.gd` | Проверка размеров, регионов, animation keys. |

## Подпапки

| Папка | Назначение |
| --- | --- |
| [`import/`](import/README.md) | Readers/converters for Wargus Lua, SMS/SMP/PUD, installed game data and reference reports. |
