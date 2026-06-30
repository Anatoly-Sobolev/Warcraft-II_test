# Content pipeline

Документ фиксирует, как проект работает с игровыми данными, визуальными
материалами и reference-only ассетами.

## Типы материалов

| Тип | Где хранится | Можно ли использовать в runtime | Правило |
| --- | --- | --- | --- |
| Gameplay data | `content/schema/gameplay/`, `content/catalogs/`, `content/balance/` | Да | Данные должны ссылаться на `mechanics_matrix.md`. |
| Presentation data | `content/schema/presentation/`, `content/catalogs/` | Да | Хранит visual ids, sprite/icon/audio banks, но не правила Warcraft Runtime. |
| Project visuals/placeholders | `content/assets/` | Да | Только разрешенные к коммиту материалы. |
| Imported reference reports | `content/imported/` | Нет напрямую | Наши Markdown/CSV/JSON отчеты без оригинальных ассетов; используются для переноса в schemas/catalogs. |
| Original Warcraft II references | `docs/design/reference_packs/` manifest или внешний носитель | Нет | Reference-only, если нет отдельного права и asset pipeline. |
| Wargus metadata | Внешний source checkout, ссылки в docs | Нет напрямую | Использовать как справочник; GPL-код не переносить в Godot без решения по лицензии. |

## Оригинальные материалы Warcraft II

Оригинальные скриншоты и crop-изображения можно показывать дизайнеру как
reference-only материалы, чтобы он видел, что именно перерабатывается. Они не
становятся ассетами проекта автоматически.

До отдельного решения по правам запрещено:

- коммитить оригинальные изображения, аудио, видео и extracted sprites;
- класть оригинальные файлы в `content/assets/`;
- использовать оригинальные изображения как финальные runtime-текстуры;
- смешивать reference-only материалы с project visuals/placeholders.

Если права на хранение и использование есть, в этот документ нужно добавить
отдельный раздел с источником, владельцем проверки прав, разрешенными форматами,
папкой хранения и процедурой импорта.

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

Разрешенные ассеты и placeholders лежат в `content/assets/`:

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
