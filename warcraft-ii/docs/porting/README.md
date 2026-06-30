# Porting documentation

Документы этой папки описывают перенос gameplay-equivalent логики Warcraft II в
проект. Это не место для новых ассетов и не копия Wargus-кода.

| Документ | Что фиксирует |
| --- | --- |
| [`warcraft2_logic_porting_plan.md`](warcraft2_logic_porting_plan.md) | Общая карта переноса логики: источник, наш модуль, данные, тест. |
| [`local_reference_setup.md`](local_reference_setup.md) | Как участникам проекта работать с локальными Wargus/Warcraft II reference-файлами и что нельзя коммитить. |

Главное правило: оригинальные источники используются как reference-only материал.
Runtime-логика реализуется в наших `game/simulation/*`, `game/scenario/*`,
`content/schema/*` и `content/catalogs/*`.
