# Porting documentation

Документы этой папки описывают перенос gameplay-equivalent логики Warcraft II в
Godot. Проект является портом игры с новыми ассетами, а не новой RTS.

| Документ | Что фиксирует |
| --- | --- |
| [`pre_start_checklist.md`](pre_start_checklist.md) | Что нужно закрыть до первой задачи по переносу механик. |
| [`warcraft2_logic_porting_plan.md`](warcraft2_logic_porting_plan.md) | Общая карта переноса механик: source, runtime concept, module, test. |
| [`wargus_runtime_mapping.md`](wargus_runtime_mapping.md) | Как Wargus/Stratagus concepts мапятся на `game/warcraft_runtime/`. |
| [`local_reference_setup.md`](local_reference_setup.md) | Как работать с локальными Wargus/Warcraft II reference-файлами и что нельзя коммитить. |

Главное правило:

```text
Wargus/Warcraft source -> runtime concept -> order/rule/adapter -> test
```

Runtime-логика размещается в `game/warcraft_runtime/*`, mission/UI-facing оболочки
в `game/scenario/*`, данные в `content/schema/*` и `content/catalogs/*`.
