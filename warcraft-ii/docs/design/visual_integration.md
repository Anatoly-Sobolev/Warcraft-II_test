# Интеграция визуальной части

Документ фиксирует правила работы с дизайном, UI, presentation-сценами,
ассетами и анимациями. Его нужно читать перед задачами, которые меняют внешний
вид игры, HUD, меню, оверлеи, визуалы юнитов, эффекты, иконки или motion.

## Цель

Визуальная часть должна быть поддерживаемой системой, а не набором больших
сцен. Дизайн входит в проект через маленькие компоненты, схемы, каталоги,
токены темы и подготовленные ViewData.

Главные ограничения:

- `game/simulation/` остается единственным источником правды о матче.
- `game/presentation/` показывает игровой мир: карту, сущности, туман, эффекты,
  визуальные анимации, миникарту как картинку мира, камеру и игровой звук.
- `ui/` показывает HUD, меню, панели, окна, tooltip, dialogue/tutorial overlay.
- UI и Presentation не читают `simulation/storage/` и не меняют Simulation
  напрямую.
- Действия игрока идут через Input и `GameCommand`, а не из кнопки прямо в
  Simulation.
- Оригинальные ассеты Warcraft II нельзя коммитить без прав и отдельного
  asset pipeline.

## Что просить у дизайнера на первой неделе

На первой неделе дизайнер не должен сдавать "один большой экран HUD". Нужен
маленький компонентный пакет для первого вертикального среза.

Минимальный пакет:

1. Visual direction: 2-3 направления внешнего вида без копирования оригинальных
   ассетов Warcraft II.
2. UI tokens: палитра, шрифты, размеры, отступы, рамки, состояния, иконографика.
3. HUD components: resource bar, command button, command panel, selection panel,
   minimap panel, tooltip, queue slot.
4. Component states: normal, hover/focus, pressed, disabled, selected, progress,
   warning/error.
5. Layout rules: desktop 16:9, малый экран, минимальные размеры, safe area, что
   фиксировано, что растягивается.
6. Motion spec: что анимируется, trigger, duration, easing, loop/one-shot,
   можно ли отключить ради производительности.
7. Asset list: какие иконки, рамки, шрифты, текстуры и mock placeholders нужны.

Хорошая формулировка задачи дизайнеру:

```text
Сделать компонентную спецификацию HUD первого вертикального среза:
resource bar, command button, command panel, selection panel, minimap panel,
tooltip, queue slot. Для каждого компонента дать состояния и motion spec.
Не собирать HUD как один монолитный экран: каждый элемент должен быть
самостоятельным компонентом.
```

## Структура файлов

Визуальные изменения раскладываются по назначению:

```text
warcraft-ii/
  docs/design/                 правила и дизайн-спецификации

  ui/
    ui_root.tscn               корень UI-слоя
    hud/
      hud.tscn                 только композиция HUD
      resource_bar/
      command_panel/
      selection_panel/
      minimap_panel/
      queue_panel/
    components/                переиспользуемые UI-компоненты
    overlays/                  dialogue, tutorial, notifications
    screens/                   меню и отдельные экраны
    theme/                     Theme, UI tokens, шрифты, общие текстуры
    animation/                 общие motion tokens и helpers для UI

  game/presentation/
    views/                     unit/building/projectile/effect views
    render/                    render sync, animation clock, culling, fog, map
    pools/                     переиспользование runtime-сцен
    minimap/                   отрисовка миникарты как изображения мира
    audio/                     звук матча по событиям

  content/
    schema/presentation/       схемы визуальных данных
    catalogs/                  .tres-каталоги визуалов, иконок, анимаций
    assets/                    разрешенные ассеты и placeholders
```

Новые папки внутри `ui/hud/` создаются по компоненту, а не по экрану. Например:

```text
ui/hud/command_panel/
  command_panel.tscn
  command_panel.gd
  command_button.tscn
  command_button.gd
```

## Правило против монолитного HUD

Запрещено делать HUD как одну гигантскую сцену, где лежат все панели, кнопки,
tooltip, логика выбора, прогресс очередей и обработка команд.

Допустимая структура:

- `hud.tscn` только размещает дочерние компоненты и передает им ViewData.
- `resource_bar.tscn` показывает ресурсы.
- `selection_panel.tscn` показывает выбранные сущности.
- `command_panel.tscn` строит кнопки из `CommandPanelViewData`.
- `command_button.tscn` отвечает только за визуальное состояние одной кнопки.
- `tooltip.tscn` является общим компонентом и не знает о Simulation.

Если компонент вырос настолько, что в нем появились разные зоны ответственности,
его нужно разделить на дочерние сцены.

## Контракты данных

UI получает данные только через подготовленные ViewData или adapter/presenter
матча. Компоненты не читают внутренние хранилища Simulation.

Пример потока для HUD:

```text
Simulation ports
  -> simulation_ui_query / selection_view_data / command_query
  -> match UI adapter
  -> ui/hud/*
```

Пример данных для кнопки команды:

```text
command_id
icon_id
hotkey
enabled
selected
cooldown_progress
tooltip_key
```

Кнопка может испустить сигнал `command_requested(command_id, payload)`, но не
может сама менять Simulation. Дальше запрос должен пройти через Input/Command
flow и превратиться в `GameCommand`.

## UI или Presentation

Класть в `ui/`:

- HUD-панели;
- кнопки команд;
- меню;
- настройки;
- tooltip;
- окна;
- dialogue/tutorial/notification overlays;
- экран загрузки, паузы, результата.

Класть в `game/presentation/`:

- unit/building/projectile/effect views;
- отрисовку карты, тумана, выделения;
- визуальные состояния юнитов и зданий;
- интерполяцию позиций;
- миникарту как рендер игрового мира;
- игровой звук по событиям матча;
- camera view.

Класть в `content/`:

- visual ids;
- sprite/icon/audio banks;
- `.tres`-каталоги визуальных ресурсов;
- placeholder assets;
- разрешенные шрифты, текстуры, атласы;
- схемы `content/schema/presentation/`.

## Анимации

Анимации делятся на три группы.

### UI motion

Hover, press, panel open/close, tooltip, warning pulse, progress fill. Хранится
рядом с компонентом или в `ui/animation/`, если правило общее.

Локальная анимация кнопки живет в `command_button.tscn`. Общие длительности и
easing должны быть вынесены в UI motion tokens, а не размазаны по скриптам.

### Presentation animation

Still, move, attack, death, spell/action variants, projectile/effect visuals.
Хранится в `game/presentation/` и `content/schema/presentation/`. Источники и
требования фиксируются строками `PRES-001`, `PRES-002`, `PRES-003` в
`docs/gameplay/mechanics_matrix.md`.

Simulation сообщает состояние и события, Presentation выбирает визуальную
анимацию. Presentation не решает, нанесен ли урон и закончилась ли атака.

### Scenario/UI overlays

Briefing, dialogue, tutorial, notifications. Данные принадлежат Scenario и
content, показ принадлежит `ui/overlays/`.

## Правила для задач ИИ

Нельзя просить ИИ "сделай HUD" без границ. Нужно указывать компонент, папку,
входные ViewData, выходные сигналы и запреты.

Хороший пример:

```text
Реализуй `ui/hud/command_panel/command_button.tscn` и `command_button.gd`.
Компонент принимает CommandButtonViewData: command_id, icon_id, hotkey, enabled,
selected, cooldown_progress, tooltip_key. Он показывает визуальные состояния и
испускает signal command_requested(command_id, payload). Не читать Simulation,
не создавать GameCommand внутри кнопки, не менять другие HUD-панели.
```

Плохой пример:

```text
Сделай красивый HUD как в Warcraft II.
```

Такой запрос почти гарантированно приведет к монолитной сцене и смешению UI,
Input, Simulation и Presentation.

## Definition of Done для визуальных изменений

Визуальное изменение готово только если:

- сцены разложены по компонентам, а не собраны в один монолит;
- UI/Presetation не читают `simulation/storage/`;
- действия игрока не обходят `GameCommand`;
- добавлены или обновлены ViewData/adapter-описания;
- обновлен README затронутого модуля или этот документ;
- для UI-компонента есть ручной тест-кейс или demo-сцена/описание проверки;
- для новой Warcraft II-механики обновлена `mechanics_matrix.md`;
- для новых ассетов понятно, что они разрешены к коммиту или являются
  placeholders.

