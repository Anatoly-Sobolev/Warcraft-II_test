# tests

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md)

**Назначение:** unit, integration, reference and performance checks. Главная идея:
`warcraft_runtime` тестируется без UI и сцен, а каждая перенесенная механика имеет
source/reference proof.

## Правило

Новая механика или исправление регрессии должны добавлять один из вариантов:

- unit/integration/reference/performance тест в этой папке;
- ручной test case в отчете спринта;
- явное объяснение, почему проверка отложена и какой риск остается.

## Приоритеты

- `tests/unit/` — отдельные runtime orders/rules/adapters.
- `tests/integration/` — input -> runtime -> presentation/ui/save flows.
- `tests/performance/` — pathfinding, fog, mass orders, combat, render sync.
- `tests/fixtures/` — small catalogs/maps/reference snapshots.
