# content

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md) · 🎨 [Интеграция визуала](../docs/design/visual_integration.md)

**Статус: заглушка.** Наполняется данными по мере реализации механик. README
с описанием схем и каталогов можно расширять по факту.

**Назначение (кратко):** данные игры, а не код — схемы (`.gd`-ресурсы), каталоги и
баланс (`.tres`), кампании, карты, локализация, ассеты. Новый юнит/здание/миссия —
это данные по существующей схеме, а не новый класс.

Уже зафиксированы соглашения об именах:
- [кампании](campaigns/README.md) — `campaign.tres` + `mission_NN` + `maps/`;
- [карты схватки](skirmish/maps/README.md) — пара `<map_id>_logic.tres` / `<map_id>_visual.tres`.
- [imported reference reports](imported/README.md) — коммитируемые отчеты из
  локальных reference-only источников без оригинальных ассетов.

## Визуальный контент

Визуальная часть хранится как данные, а не как игровая логика:

- `schema/presentation/` — схемы visual ids, sprite banks, icon banks,
  animation banks, audio banks;
- `catalogs/` — `.tres`-каталоги визуальных ресурсов;
- `assets/` — разрешенные ассеты, placeholders, шрифты, текстуры, атласы,
  иконки и звуки;
- `localization/` — тексты tooltip, меню, dialogue/tutorial.

Simulation не должна ссылаться на конкретные файлы спрайтов, иконок или звуков.
Она может отдавать состояние, события и ids. Presentation/UI сопоставляют эти ids
с каталогами визуальных ресурсов.

Анимации юнитов, зданий, снарядов и эффектов идут через spritesheet/atlas +
animation bank + markers. Полный контракт описан в
[`../docs/design/data_driven_animation_system.md`](../docs/design/data_driven_animation_system.md).

Оригинальные ассеты Warcraft II нельзя коммитить без прав и отдельного asset
pipeline. До появления легального pipeline используются placeholders или
собственные ассеты.

Правила локальных Wargus/Warcraft II материалов описаны в
[`../docs/porting/local_reference_setup.md`](../docs/porting/local_reference_setup.md).
