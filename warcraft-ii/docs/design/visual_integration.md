# Интеграция визуальной части

Документ фиксирует правила работы с дизайном, UI, presentation-сценами,
ассетами и анимациями. Его нужно читать перед задачами, которые меняют внешний
вид игры, HUD, меню, оверлеи, визуалы юнитов, эффекты, иконки или motion.

## Цель

Визуальная часть должна быть поддерживаемой системой, а не набором больших
сцен. Дизайн входит в проект через маленькие компоненты, схемы, каталоги,
токены темы и подготовленные ViewData.

Главные ограничения:

- `game/warcraft_runtime/` остается единственным источником правды о матче.
- `game/presentation/` показывает игровой мир: карту, сущности, туман, эффекты,
  визуальные анимации, миникарту как картинку мира, камеру и игровой звук.
- `ui/` показывает HUD, меню, панели, окна, tooltip, dialogue/tutorial overlay.
- UI и Presentation не читают `warcraft_runtime/state/` и не меняют Warcraft Runtime
  напрямую.
- Действия игрока идут через Input и `WarcraftCommand`, а не из кнопки прямо в
  Warcraft Runtime.
- Оригинальные ассеты Warcraft II нельзя коммитить без прав и отдельного
  asset pipeline.

## Перед задачей дизайнеру

Перед тем как просить дизайнера рисовать новый стиль, нужно подготовить пакет
референсов оригинального Warcraft II UI. Дизайнер не должен выдумывать новый
состав интерфейса, новые панели или лишние состояния без отдельной продуктовой
задачи. Его задача — переработать существующий UI под новый визуальный стиль,
сохранив состав, иерархию, темп чтения и RTS-функции.

Reference pack должен содержать:

1. Полные скриншоты оригинального игрового экрана.
2. Крупные crop-изображения отдельных UI-зон.
3. Таблицу соответствия UI-зон строкам `mechanics_matrix.md`.
4. Список Wargus-файлов, которые подтверждают кнопки, иконки, хоткеи и layout.
5. Список локальных ассетов проекта, которые можно использовать как рабочие
   placeholders или текущие project visuals.
6. Явную пометку, какие материалы являются reference-only и не должны попадать
   в runtime/commit как оригинальные Warcraft II assets.

Обязательные кадры оригинального UI для первого пакета:

| Кадр | Что дизайнер должен увидеть | Зачем нужен |
| --- | --- | --- |
| Human mission 01, стартовый экран | Общий HUD, карта, ресурсы, миникарта, нижняя панель | Базовая композиция игрового экрана. |
| Выбран один Peasant | Selection panel, portrait/icon, доступные команды рабочего | Состояние одного юнита. |
| Выбрана группа юнитов | Group selection panel | Правила плотности и группового выбора. |
| Выбран Town Hall | Training/production commands, supply/resource context | Состояние здания. |
| Выбран Barracks | Train Footman и очередь/прогресс, если доступно | Production flow. |
| Открыто build menu у Peasant | Command panel с уровнем меню строительства | Многоуровневые команды. |
| Tooltip на command button | Текст, hotkey, стоимость/условия | Поведение подсказок. |
| Недоступная команда | Disabled state и причина | Error/disabled state. |
| Миникарта с туманом | Terrain, fog, player colors | Minimap и fog readability. |
| Pause/options/save menu | Внутриигровые меню | Экранные состояния вне боя. |
| Briefing/dialogue/objective screen | Миссионные overlay/экраны | Сюжетные и обучающие слои. |

## Где брать визуальные материалы

Материалы делятся на три группы.

### Reference-only оригинал

Это скриншоты и crop-изображения из оригинальной Warcraft II, сделанные из
легального источника. Они нужны дизайнеру, чтобы понимать, что именно
перерабатывается: состав HUD, расположение панелей, плотность кнопок, состояние
tooltip, меню, briefing и миникарта.

Эти материалы нельзя использовать как runtime-ассеты и нельзя коммитить в
репозиторий, если на это нет прав и отдельного asset pipeline. Если права есть,
нужно явно записать это в `docs/content/content_pipeline.md` и указать, какие
файлы разрешено хранить в Git.

Рекомендуемое место для описания пакета:

```text
docs/design/reference_packs/original_ui_reference_pack.md
```

Сами бинарные оригинальные изображения можно класть в репозиторий только при
наличии прав. Если прав нет, в документе хранится manifest: названия кадров,
сценарий получения, размер, дата снятия и внешний путь/носитель без коммита
оригинальных файлов.

### Wargus/Stratagus как технический справочник

Для состава UI и mapping-данных использовать строки из `mechanics_matrix.md`:

- `UI-001` — command panel: `Pos`, `Level`, `Icon`, `Action`, `Value`,
  `Allowed`, `Key`, `Hint`, `ForUnit` из `scripts/*/buttons.lua`.
- `UI-002` — resource bar: `ResourcesOnUI`, gold, wood, oil, supply.
- `UI-003` — selection panel и смешанный выбор.
- `UI-004` — queue panel и cancel/progress.
- `UI-005` — minimap, terrain/fog/player colors.
- `UI-006` — menus: help, options, speed, sound, diplomacy, save, load,
  restart, quit.
- `UI-007` — hotkeys из button data.
- `UI-008` — briefing/dialogue/tutorial overlays.
- `PRES-001` ... `PRES-006` — sprite mappings, animations, effects, sound
  groups, palette/player colors.
- `IMP-002` и `IMP-006` — импорт button catalog и visual/audio mappings.

Файлы Wargus, которые нужно указывать в задаче дизайнеру и разработчику:

```text
scripts/human/buttons.lua
scripts/orc/buttons.lua
scripts/buttons.lua
scripts/icons.lua
scripts/ui.lua
scripts/sound.lua
scripts/human/anim.lua
scripts/orc/anim.lua
scripts/anim.lua
scripts/missiles.lua
scripts/tilesets/*.lua
```

Wargus можно использовать как справочник по структуре и mapping-данным, но нельзя
переносить GPL-код напрямую в Godot без отдельного лицензионного решения.

### Локальные ассеты проекта

Текущие ассеты проекта лежат в `content/assets/`. Они используются как
разрешенные project visuals или placeholders, пока нет отдельного легального
pipeline оригинальных ассетов:

```text
content/assets/textures/ui/ui_atlas.png
content/assets/textures/portraits/portraits_atlas.png
content/assets/textures/units/*_units_atlas.png
content/assets/textures/buildings/*_buildings_atlas.png
content/assets/textures/effects/*_atlas.png
content/assets/textures/terrain/*_atlas.png
content/assets/animations/*_sprite_bank.tres
content/assets/tilesets/*_tileset.tres
content/assets/shaders/palette_shader.gdshader
content/catalogs/sprite_banks.tres
content/catalogs/unit_visuals.tres
content/catalogs/building_visuals.tres
content/catalogs/audio_banks.tres
```

Дизайнеру можно показывать эти материалы как текущую техническую базу проекта,
но задача дизайнера — предложить новый визуальный стиль поверх состава
оригинального UI, а не просто перекрасить placeholder-атласы.

## Что просить у дизайнера на первой неделе

На первой неделе дизайнер не должен сдавать "один большой экран HUD". Нужен
маленький компонентный пакет для первого вертикального среза.

Минимальный пакет, который выдается дизайнеру вместе с reference pack:

1. Анализ оригинального UI: какие зоны есть, какие состояния нужны, какие
   элементы нельзя убирать.
2. Visual direction: 2-3 направления внешнего вида без копирования оригинальных
   ассетов Warcraft II.
3. UI tokens: палитра, шрифты, размеры, отступы, рамки, состояния, иконографика.
4. HUD components: resource bar, command button, command panel, selection panel,
   minimap panel, tooltip, queue slot.
5. Component states: normal, hover/focus, pressed, disabled, selected, progress,
   warning/error.
6. Layout rules: desktop 16:9, малый экран, минимальные размеры, safe area, что
   фиксировано, что растягивается.
7. Motion spec: что анимируется, trigger, duration, easing, loop/one-shot,
   можно ли отключить ради производительности.
8. Asset list: какие иконки, рамки, шрифты, текстуры и mock placeholders нужны.

Хорошая формулировка задачи дизайнеру:

```text
На основе reference pack оригинального Warcraft II UI сделать переработку HUD
первого вертикального среза в новом стиле. Не придумывать новый состав UI и не
добавлять лишние панели без отдельного согласования.

Обязательные компоненты: resource bar, command button, command panel,
selection panel, minimap panel, tooltip, queue slot. Для каждого компонента дать
состояния и motion spec. Отдельно показать, какой crop оригинального UI является
источником для каждого компонента.

Не собирать HUD как один монолитный экран: каждый элемент должен быть
самостоятельным компонентом для последующей реализации в Godot.
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
- `tooltip.tscn` является общим компонентом и не знает о Warcraft Runtime.

Если компонент вырос настолько, что в нем появились разные зоны ответственности,
его нужно разделить на дочерние сцены.

## Контракты данных

UI получает данные только через подготовленные ViewData или adapter/presenter
матча. Компоненты не читают внутренние хранилища Warcraft Runtime.

Пример потока для HUD:

```text
Warcraft Runtime ports
  -> runtime_ui_query / selection_view_data / command_query
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
может сама менять Warcraft Runtime. Дальше запрос должен пройти через Input/Command
flow и превратиться в `WarcraftCommand`.

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

Warcraft Runtime сообщает состояние и события, Presentation выбирает визуальную
анимацию. Presentation не решает, нанесен ли урон и закончилась ли атака.

Runtime-формат должен быть data-driven: spritesheet/atlas, frame size, direction
policy, animation states и event markers. Подробный контракт для разработчика и
дизайнера лежит в
[`data_driven_animation_system.md`](data_driven_animation_system.md).

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
испускает signal command_requested(command_id, payload). Не читать Warcraft Runtime,
не создавать WarcraftCommand внутри кнопки, не менять другие HUD-панели.
```

Плохой пример:

```text
Сделай красивый HUD как в Warcraft II.
```

Такой запрос почти гарантированно приведет к монолитной сцене и смешению UI,
Input, Warcraft Runtime и Presentation.

## Definition of Done для визуальных изменений

Визуальное изменение готово только если:

- сцены разложены по компонентам, а не собраны в один монолит;
- UI/Presetation не читают `warcraft_runtime/state/`;
- действия игрока не обходят `WarcraftCommand`;
- добавлены или обновлены ViewData/adapter-описания;
- обновлен README затронутого модуля или этот документ;
- для UI-компонента есть ручной тест-кейс или demo-сцена/описание проверки;
- для новой Warcraft II-механики обновлена `mechanics_matrix.md`;
- для новых ассетов понятно, что они разрешены к коммиту или являются
  placeholders.
