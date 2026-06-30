# content

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md) · 🎨 [Интеграция визуала](../docs/design/visual_integration.md)

**Ответственность:** runtime data, каталоги, кампании, карты, локализация и новые
ассеты. Код механик находится в `game/warcraft_runtime/`; конкретные UnitType,
buildings, buttons, spells, upgrades and missions должны приходить из данных.

## Ключевая идея

```text
Wargus/Warcraft source -> reference report/converter -> content data -> runtime
```

Новый юнит, здание, кнопка, spell или mission сначала получают source metadata:
откуда взяты поля, какие Wargus ids используются, какие вопросы не закрыты.

## Уже зафиксированные соглашения

- [кампании](campaigns/README.md) — `campaign.tres` + `mission_NN` + `maps/`;
- [карты схватки](skirmish/maps/README.md) — пара `<map_id>_logic.tres` /
  `<map_id>_visual.tres`;
- [imported reference reports](imported/README.md) — коммитируемые отчеты и
  черновые данные из локальных reference sources без оригинальных ассетов.

## Визуальный контент

Визуальная часть хранится как данные, а не как игровая логика:

- `schema/presentation/` — visual ids, sprite banks, icon banks, animation banks,
  audio banks;
- `catalogs/` — `.tres` каталоги визуальных ресурсов;
- `assets/` — разрешенные ассеты, placeholders, шрифты, текстуры, атласы, иконки,
  звуки;
- `localization/` — tooltip, меню, dialogue/tutorial text.

`warcraft_runtime` не должен ссылаться на конкретные PNG/WAV как на gameplay
правила. Он отдает ids/events/state, а Presentation/UI сопоставляют ids с
visual/audio catalogs.

Оригинальные ассеты Warcraft II нельзя коммитить без прав и отдельного asset
pipeline. До появления легального pipeline используются placeholders или
собственные ассеты.

Правила локальных Wargus/Warcraft II материалов:
[`../docs/porting/local_reference_setup.md`](../docs/porting/local_reference_setup.md).
