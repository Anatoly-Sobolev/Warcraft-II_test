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

## Правила

- Не копировать оригинальные assets в `content/assets/`.
- Если переносится GPL Wargus logic, фиксировать source metadata and license note.
- Вывод инструментов должен быть нашим report/data format или adapter, а не
  случайной копией source без структуры.
- Absolute paths допускаются только как локальные параметры запуска.
- Коммитируемые результаты складывать в `content/imported/`.

Подробные правила: [`../../docs/porting/local_reference_setup.md`](../../docs/porting/local_reference_setup.md).
