# Reference packs

Эта папка хранит manifest-документы для reference-only материалов.

Дизайнеру передается не эта папка как основной материал, а готовый handoff-пакет:

```text
warcraft-ii/docs/design/designer_handoff/task_01_hud_restyle/
```

В нем есть локальная папка `reference_assets/`, куда кладутся реальные PNG и
screenshots/crops, чтобы дизайнер видел оригинальный UI без чтения кода.

Важно: оригинальные изображения, аудио и другие ассеты Warcraft II можно
коммитить только при наличии прав и описанного asset pipeline. Если прав нет,
здесь хранится только manifest: какие материалы нужны, откуда они получены, как
их воспроизвести и где они лежат вне Git.

| Документ | Что фиксирует |
| --- | --- |
| [`original_ui_reference_pack.md`](original_ui_reference_pack.md) | Минимальный пакет оригинального UI, который нужно показать дизайнеру перед задачей на новый визуальный стиль. |
| [`wargus_ui_materials.md`](wargus_ui_materials.md) | Техническая выжимка из локального Wargus checkout для HUD, command panel, icons, menus и briefing references. |
