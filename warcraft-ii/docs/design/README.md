# Design documentation

Эта папка фиксирует правила работы с визуальной частью проекта: UI, HUD,
presentation-слоем, ассетами, анимациями, звуком, видео и картами.

| Документ | Что фиксирует |
| --- | --- |
| [`asset_production_system.md`](asset_production_system.md) | Полная система: какие ассеты создавать, в каком порядке, как делать карты через tiles/TileMapLayer, что уже закрыто и какие есть performance-правила. |
| [`data_driven_animation_system.md`](data_driven_animation_system.md) | Как переносить Warcraft II/Wargus-подход к анимациям: spritesheets, размеры кадров, states, markers, требования к дизайнеру и runtime pipeline. |
| [`designer_handoff/task_01_hud_restyle/README.md`](designer_handoff/task_01_hud_restyle/README.md) | Папка выдачи дизайнеру для первого задания: материалы, доска референсов, чеклист и локальная папка для оригинальных изображений. |
| [`visual_integration.md`](visual_integration.md) | Как дизайнерские материалы превращаются в Godot-сцены, ресурсы и motion-правила без смешивания с Simulation. |
| [`reference_packs/original_ui_reference_pack.md`](reference_packs/original_ui_reference_pack.md) | Какие референсы оригинального Warcraft II UI нужно подготовить перед задачей дизайнеру. |
| [`reference_packs/wargus_ui_materials.md`](reference_packs/wargus_ui_materials.md) | Техническое приложение: какие Wargus-файлы и metadata используются как справочник для UI. |
| [`tasks/designer_task_01_hud_restyle.md`](tasks/designer_task_01_hud_restyle.md) | Полная формулировка первого задания дизайнеру с функциональным составом HUD. |
| [`templates/animation_asset_spec_template.md`](templates/animation_asset_spec_template.md) | Шаблон спецификации для одного animated asset: размеры, сетка, states, markers и чеклисты. |
