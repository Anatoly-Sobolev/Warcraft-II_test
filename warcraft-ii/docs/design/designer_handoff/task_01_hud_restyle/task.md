# Что нужно сделать

Перерисовать первый вертикальный срез HUD в новом визуальном стиле проекта, сохранив структуру Warcraft II/Wargus.

## Обязательные компоненты

- Верхняя полоса ресурсов: gold, wood, oil, food/supply, score/workers при наличии.
- Левая колонка HUD: menu button, minimap, selection/info panel, command panel.
- Command panel: фиксированная сетка 3x3. Пустые и недоступные команды не должны сдвигать остальные кнопки.
- Command button: normal, hover, pressed, disabled/locked, selected/current, progress/cooldown.
- Tooltip/popup для команды: название, hotkey, стоимость/требования.
- Production/progress state для Town Hall и Barracks.
- Group selection state.
- Briefing/objectives overlay для Human mission 01 как направление стиля.

## Что нельзя менять

- Не добавлять новые игровые команды.
- Не менять расположение основных зон HUD без согласования.
- Не превращать HUD в один неделимый экран: дизайн должен раскладываться на отдельные компоненты.
- Не использовать оригинальные Warcraft II изображения как финальные ассеты.

## Что сдать

1. Основной макет экрана Human mission 01.
2. Component map: какие элементы HUD есть и к каким оригинальным референсам они привязаны.
3. Отдельные компоненты: resource bar, minimap frame, selection/info panel, command panel, command button, tooltip, menu button.
4. Состояния кнопок и панелей.
5. Список новых ассетов, которые нужно будет нарезать для Godot.
6. Motion notes: hover, press, появление tooltip, progress fill, warning/error pulse.

## Первый набор команд

Для первого среза нужны состояния Peasant, Town Hall, Barracks и Footman:

| Контекст | Команды |
| --- | --- |
| Peasant base | Move, Stop, Attack, Repair, Harvest, Return Goods, Build Basic, Build Advanced. |
| Peasant build basic | Farm, Barracks, Town Hall, Lumber Mill, Blacksmith, Tower, Wall, Cancel. |
| Town Hall | Train Peasant, Upgrade to Keep, Harvest rally, Move rally, Stop rally, Attack rally. |
| Barracks | Train Footman; будущие команды могут быть disabled/future. |
| Footman | Move, Stop, Attack, Patrol, Stand Ground. |
| Group selection | Compact selected unit grid and shared command state. |
