# content/assets

Папка хранит runtime-ассеты, которые Godot-проект может загрузить через
`services/assets`: текстуры, атласы, TileSet, animation/audio banks, шрифты,
шейдеры и временные placeholders.

## Статусы ассетов

Каждый неслужебный runtime-ассет должен быть описан в
[`placeholder_manifest.json`](placeholder_manifest.json).

| Статус | Значение |
| --- | --- |
| `project_final` | Новый или разрешенный финальный ассет проекта. |
| `project_placeholder` | Временная авторская/техническая заглушка без чужих материалов. |
| `original_placeholder` | Временная заглушка из оригинальной Warcraft II, подключенная через manifest и ожидающая замены новым ассетом. |
| `replacement_ready` | Новый ассет готов и может заменить placeholder после проверки каталогов. |
| `deprecated_placeholder` | Placeholder больше не должен использоваться новыми каталогами. |

`original_placeholder` нужен только для того, чтобы UI/Presentation, каталоги,
preload-пакеты и sprite/audio banks можно было интегрировать до завершения работы
дизайнера. Он не является финальным визуалом проекта.

## Правило замены

1. Runtime и UI ссылаются на `asset_id`, а не на происхождение файла.
2. `services/assets/content_manifest.gd` читает asset id/path/package/status.
3. Presentation/UI получают ресурс через manifest/cache и могут показать fallback.
4. Когда дизайнер сдает новый ассет, меняется manifest/catalog path для того же
   `asset_id` или добавляется новый `asset_id` с явной миграцией.
5. Старый `original_placeholder` переводится в `deprecated_placeholder` и удаляется
   из preload-пакетов после проверки демо.

## Текущие заглушки

Сейчас runtime PNG в `textures/*` собраны из `external/wargus_extracted`.
Исходники каждого атласа перечислены в `source_paths` внутри
`placeholder_manifest.json`.

Пример замены:

1. Дизайнер кладет новый файл, например
   `content/assets/textures/units/new_alliance_units_atlas.png`.
2. В `placeholder_manifest.json` у `alliance_units_atlas` меняется
   `runtime_path` на новый файл.
3. `origin` меняется на `project`, `status` - на `project_final` или
   `replacement_ready`.
4. Старый исходный placeholder можно оставить для сравнения до проверки демо или
   удалить после миграции каталогов.

Если нужно сохранить тот же путь, новый файл можно просто положить поверх
текущего PNG. Тогда меняются только `origin`, `status` и `source_paths`.

## Что нельзя

- Класть оригинальные Warcraft II файлы сюда без записи в
  `placeholder_manifest.json`.
- Менять gameplay state или timings ради конкретной картинки.
- Ссылаться на PNG/WAV напрямую из Warcraft Runtime, orders, UI-кнопок или
  сценариев.
- Добавлять ассет без owner, replacement target и ручной проверки.
