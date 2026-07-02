# import tools

Папка для инструментов, которые читают локальные Warcraft II/Wargus sources и
создают наши reports, converted data или compatibility adapters.

Эти инструменты запускаются вне игры. Runtime может использовать результат
конвертации, но не должен требовать локальный путь к установленной игре в release.

## Разрешенные задачи

| Инструмент | Назначение |
| --- | --- |
| `wargus_units_importer.gd` | Читает `DefineUnitType` и создает UnitType/building reports. |
| `wargus_buttons_importer.gd` | Читает button Action/Allowed/Key/Hint data. |
| `wargus_spells_importer.gd` | Читает spells/status/targeting parameters. |
| `wargus_upgrades_importer.gd` | Читает technologies, upgrades and dependencies. |
| `pud_sms_map_importer.gd` | Читает `.sms/.smp/.pud` reference data and creates map reports/drafts. |
| `wargus_campaign_importer.gd` | Читает campaign scripts, mission order, briefing and triggers. |
| `animation_reference_report.gd` | Reports for spritesheet sizes, states, frames and markers. |
| `sound_reference_report.gd` | Reports for sound groups and source ids. |
| `wargus_reference_reader.gd` | Общий helper для локальных reference paths. |
| `original_placeholder_builder.gd` | Собирает runtime `original_placeholder` атласы из `external/wargus_extracted` в `content/assets/textures/*`. |

## Правила

- Оригинальные assets, нужные для текущей визуальной системы, добавлять в
  `content/assets/` только как manifest-tracked `original_placeholder`.
- Если переносится Wargus logic concept, фиксировать source metadata и слой проекта,
  куда попадает собственная реализация.
- Вывод инструментов должен быть нашим report/data format или adapter, а не
  случайной копией source без структуры.
- Absolute paths допускаются только как локальные параметры запуска.
- Коммитируемые результаты складывать в `content/imported/`.

Подробные правила: [`../../docs/porting/local_reference_setup.md`](../../docs/porting/local_reference_setup.md).

## Пересобрать placeholder-атласы

```powershell
godot --headless --path warcraft-ii --script res://tools/import/original_placeholder_builder.gd
godot --headless --editor --path warcraft-ii --quit
```

Первый шаг перезаписывает PNG в `content/assets/textures/*` из extracted sources.
Второй шаг обновляет Godot import metadata, чтобы `ResourceLoader` видел новые
текстуры как `CompressedTexture2D`.
