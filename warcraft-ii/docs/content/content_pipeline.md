# Content pipeline

Документ фиксирует, как проект работает с игровыми данными, визуальными
материалами и reference-only ассетами.

## Типы материалов

| Тип | Где хранится | Можно ли использовать в runtime | Правило |
| --- | --- | --- | --- |
| Gameplay data | `content/schema/gameplay/`, `content/catalogs/`, `content/balance/` | Да | Данные должны ссылаться на `mechanics_matrix.md`. |
| Presentation data | `content/schema/presentation/`, `content/catalogs/` | Да | Хранит visual ids, sprite/icon/audio banks, но не правила Warcraft Runtime. |
| Project visuals/placeholders | `content/assets/` | Да | Материалы проекта с записью в `content/assets/placeholder_manifest.json`. |
| Original runtime placeholders | `content/assets/` | Да, временно | Оригинальные Warcraft II заглушки со статусом `original_placeholder` в manifest и планом замены. |
| Imported reference reports | `content/imported/` | Нет напрямую | Наши Markdown/CSV/JSON отчеты без оригинальных ассетов; используются для переноса в schemas/catalogs. |
| Original Warcraft II references | `docs/design/reference_packs/` manifest или внешний носитель | Нет | Reference-only, если нет отдельного права и asset pipeline. |
| Wargus metadata | Внешний source checkout, ссылки в docs | Нет напрямую | Использовать как справочник для ids, states, mappings и reference reports. |

## Оригинальные материалы Warcraft II

Оригинальные материалы Warcraft II используются в двух режимах:

- reference materials для дизайнера, отчетов и сверки;
- runtime placeholders в `content/assets/`, пока дизайнер готовит новые ассеты.

Оригинальные файлы не считаются финальными ассетами проекта. Если файл нужен
игре сейчас, он добавляется как `original_placeholder` через
`content/assets/placeholder_manifest.json`, подключается через catalogs и
получает replacement target.

## Временные оригинальные placeholder-ассеты

Оригинальные Warcraft II материалы можно использовать как временные
runtime-заглушки. Это нужно не для финального визуального стиля, а чтобы UI,
Presentation, sprite/audio banks, TileSet и `services/assets` можно было
интегрировать до готовности новых ассетов.

Для каждого такого файла обязательны:

- запись в `content/assets/placeholder_manifest.json`;
- `origin: "original_placeholder"` и `status: "original_placeholder"`;
- `source_ref`: откуда ассет получен, без личных абсолютных путей;
- `mechanics_refs`: строки `mechanics_matrix.md`, для которых ассет нужен как
  отображение, например `PRES-001`, `PRES-002`, `UI-001`, `MAP-002`;
- `replacement_target` и `replacement_owner`;
- ручная проверка, где видно, что ассет подключен через manifest/catalog, а не
  прямой `load()` из UI/Presentation hot path.

Процедура добавления:

1. Положить файл в обычную runtime-папку `content/assets/...`, чтобы проект
   запускался без `external/`.
2. Добавить или обновить запись в `placeholder_manifest.json`.
3. Подключить файл через `content/catalogs/`, sprite/audio bank или TileSet.
4. Добавить manual/content-validation check в тестовый план или sprint report.

Процедура замены:

1. Дизайнер кладет новый ассет в тот же класс runtime-папки.
2. Каталог или manifest переключается на новый путь для того же `asset_id` либо
   создается новый `asset_id` с явной миграцией.
3. Старый `original_placeholder` переводится в `deprecated_placeholder`.
4. После проверки демо placeholder удаляется из preload-пакетов и больше не
   используется новыми задачами.

`original_placeholder` не должен попадать в save snapshot, runtime state,
баланс, миссионные условия или mechanics matrix как источник правил.

## Reference pack для дизайнера

Перед визуальной задачей готовится manifest в
`docs/design/reference_packs/original_ui_reference_pack.md`. Он фиксирует:

- какие кадры оригинального UI нужны;
- какие crop-зоны нужно показать дизайнеру;
- какие строки `mechanics_matrix.md` подтверждают состав UI;
- какие Wargus-файлы являются metadata source;
- какие локальные `content/assets/` можно показывать как текущую техническую
  базу проекта.

## Runtime-ассеты проекта

Ассеты, placeholders и временные оригинальные placeholders лежат в
`content/assets/`:

```text
content/assets/textures/
content/assets/animations/
content/assets/audio/
content/assets/fonts/
content/assets/shaders/
content/assets/tilesets/
```

Каталоги и схемы связывают runtime-код с ассетами через ids:

```text
content/schema/presentation/
content/catalogs/sprite_banks.tres
content/catalogs/unit_visuals.tres
content/catalogs/building_visuals.tres
content/catalogs/audio_banks.tres
```

Warcraft Runtime не должна ссылаться на конкретные файлы ассетов. Она отдает состояние,
events и ids, а Presentation/UI выбирают визуалы через каталоги.

## Импорт и reference reports

Локальные оригинальные материалы анализируются инструментами из `tools/import/`
или вручную, но в Git попадают только наши отчеты и черновые данные без
оригинальных ассетов:

```text
content/imported/maps/
content/imported/animation/
content/imported/audio/
content/imported/visual/
```

Для правил локальной установки Wargus/Warcraft II см.
[`../porting/local_reference_setup.md`](../porting/local_reference_setup.md).
