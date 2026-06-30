# import tools

Папка для инструментов, которые читают локальные Warcraft II/Wargus
reference-only материалы и создают наши отчеты, черновые каталоги или проверки.

Эти инструменты запускаются вне игры. Они не должны быть зависимостью runtime.

## Разрешенные задачи

| Инструмент | Назначение |
| --- | --- |
| `pud_sms_map_importer.gd` | Будущий importer карт: читает локальные `.sms/.smp/.pud` reference data и создает наши map reports/черновики. |
| `animation_reference_report.gd` | Будущий отчет по spritesheet sizes, states, frames и markers из Wargus metadata. |
| `sound_reference_report.gd` | Будущий отчет по sound groups и source ids. |
| `wargus_reference_reader.gd` | Общий helper для чтения локальных reference paths, если понадобится. |

## Правила

- Не копировать оригинальные assets в `content/assets/`.
- Не переносить GPL Lua/C++ код Wargus в runtime.
- Вывод инструментов должен быть нашим report/data format, а не копией source.
- Absolute paths допускаются только как локальные параметры запуска.
- Результаты, которые можно коммитить, складывать в `content/imported/`.

Подробные правила: [`../../docs/porting/local_reference_setup.md`](../../docs/porting/local_reference_setup.md).
