# Data-driven animation system

Документ фиксирует, как переносить подход Warcraft II/Wargus к анимациям в этот
Godot-проект. Цель: сохранить производительность RTS и не превращать каждого
юнита, здание или эффект в отдельную сложную сцену.

## Решение

Runtime-анимации юнитов, зданий, снарядов и эффектов должны быть data-driven:

```text
visual id
  -> spritesheet/atlas
  -> frame size
  -> direction policy
  -> animation states
  -> event markers
  -> lightweight renderer
```

Godot-сцена `unit_view`, `building_view`, `projectile_view` или `effect_view` -
только тонкая оболочка отображения. Она не хранит правила боя, движения, добычи,
строительства или AI.

Запрещено делать по отдельной большой сцене на каждую анимацию юнита. Это плохо
масштабируется, усложняет поддержку и ломает архитектурное правило: Warcraft Runtime
считает матч, Presentation только показывает состояние.

## Как это работает в оригинальной модели

В Wargus/Stratagus анимация строится из трех частей:

1. `DefineUnitType` задает изображение, размер кадра и id набора анимаций.
2. `DefineAnimations` задает states: `Still`, `Move`, `Attack`, `Death`,
   `Harvest_wood`, `Repair`, spell/action variants.
3. Animation script перечисляет команды: показать кадр, подождать, сдвинуть
   юнита, отметить удар, проиграть звук.

Пример источников:

```text
<local Wargus checkout>\scripts\human\units.lua
<local Wargus checkout>\scripts\human\anim.lua
<local Wargus checkout>\scripts\orc\units.lua
<local Wargus checkout>\scripts\orc\anim.lua
<local Wargus checkout>\scripts\anim.lua
```

Пример структуры:

```lua
DefineUnitType("unit-footman", {
  Image = {"file", "human/units/footman.png", "size", {72, 72}},
  Animations = "animations-footman",
})

DefineAnimations("animations-footman", {
  Still = UnitStill,
  Move = {"frame 0", "move 3", "wait 2", "frame 5", "move 3", "wait 1"},
  Attack = {"frame 25", "wait 3", "frame 30", "wait 3", "attack"},
  Death = {"frame 45", "wait 3", "frame 50", "wait 3"},
})
```

Команды оригинальной модели:

| Команда | Смысл для порта |
| --- | --- |
| `frame N` | Показать frame id из spritesheet/atlas. |
| `wait N` | Держать кадр несколько animation ticks. |
| `move N` | Визуально продвинуть юнита в рамках движения. В Godot это должно синхронизироваться с интерполяцией позиции из Warcraft Runtime. |
| `attack` | Marker удара. В нашем проекте Warcraft Runtime владеет уроном, а Presentation использует marker для визуального совпадения удара, звука и эффекта. |
| `sound X` | Marker звука. Presentation отправляет событие в audio presenter. |
| `unbreakable begin/end` | Анимацию нельзя резко перебить. В порте это флаг state lock или minimum playback time. |
| `label/goto/if-var` | Условная анимация. В порте допускается только как данные/условия visual state, не как произвольный скрипт. |
| `random-rotate` | Небольшая вариативность idle/facing. В порте это контролируемое visual-only поведение. |

GPL Lua-код Wargus нельзя переносить в Godot напрямую без отдельного решения по
лицензии. Используем его как reference source и описываем собственную схему
данных.

## Что хранить в проекте

```text
content/assets/textures/units/
content/assets/textures/buildings/
content/assets/textures/effects/
content/assets/animations/
content/schema/presentation/
content/catalogs/sprite_banks.tres
content/catalogs/unit_visuals.tres
content/catalogs/building_visuals.tres
content/catalogs/projectiles.tres
```

`content/assets/textures/*` хранит разрешенные PNG/WebP atlases и spritesheets.
`content/assets/animations/*_sprite_bank.tres` хранит frame rectangles,
animation states и markers. `content/catalogs/*` связывает gameplay ids с visual
ids. Warcraft Runtime не должна ссылаться на конкретный PNG.

## Минимальная схема animation bank

Будущие `.tres`/Resource-схемы должны покрывать такие поля:

| Поле | Зачем нужно |
| --- | --- |
| `visual_id` | Стабильный id визуала: например `human_footman`. |
| `texture` | Ссылка на atlas/spritesheet. |
| `frame_width`, `frame_height` | Размер одного кадра в пикселях. |
| `columns`, `rows` | Проверка сетки и быстрый расчет frame rect. |
| `origin` | Точка привязки к миру: обычно bottom-center или explicit pivot. |
| `direction_policy` | Как выбирать направление: `none`, `5_direction_mirrored`, `8_direction`, `custom`. |
| `states` | `idle`, `move`, `attack`, `death`, `work`, `harvest_wood`, `repair`, `cast`, `build`, `train`, `upgrade`. |
| `frames` | Список frame ids или frame rect ids для каждого state. |
| `durations` | Длительность кадров в animation ticks или seconds. |
| `markers` | `hit`, `sound`, `spawn_projectile`, `resource_tick`, `effect`, `lock_start`, `lock_end`. |
| `loop` | Зацикливать ли state. |
| `interrupt_policy` | Можно ли перебить state новым visual state. |
| `shadow_id` | Тень, если она не зашита в spritesheet. |
| `player_color_mask` | Маска или palette remap для цвета игрока. |
| `fallback_state` | Что показывать, если state отсутствует. |

## Runtime pipeline

```text
Warcraft Runtime state/events
  -> render change buffer / view data
  -> render_sync
  -> visual id lookup
  -> animation_clock
  -> unit_view/building_view/projectile_view/effect_view
  -> texture frame + marker dispatch
```

Warcraft Runtime владеет:

- текущим приказом и состоянием сущности;
- позицией, направлением, скоростью;
- cooldown, моментом урона, смертью, созданием снаряда;
- сохранением и восстановлением authoritative state.

Presentation владеет:

- выбором visual state по runtime state/events;
- проигрыванием frame sequence;
- интерполяцией между warcraft runtime ticks;
- dispatch визуальных markers: звук, вспышка, след, impact sprite;
- culling, pooling, batching.

Важно: marker `hit` не должен сам наносить урон. Он нужен, чтобы визуальный удар,
звук и эффект совпали с событием Warcraft Runtime.

## Формат ассетов для дизайнера

Дизайнер сдает не Godot-сцену, а пакет:

```text
<unit_id>/
  <unit_id>_spritesheet.png
  <unit_id>_player_color_mask.png        optional
  <unit_id>_shadow.png                   optional
  <unit_id>_animation_spec.md или .csv
  <unit_id>_preview.gif/mp4              optional
```

Обязательные параметры в spec:

| Поле | Что указать |
| --- | --- |
| `frame_size` | Например `72x72`, `64x64`, `80x80`, `88x88`. |
| `sheet_size` | Например `360x936`. Должно делиться на frame size без остатка. |
| `grid` | Например `5 columns x 13 rows`. |
| `pivot` | Где юнит стоит на клетке: обычно bottom-center. |
| `direction_policy` | Сколько направлений нарисовано и какие зеркалятся. |
| `states` | Список состояний и кадры каждого состояния. |
| `loop states` | Какие states повторяются: `idle`, `move`, active building. |
| `one-shot states` | Какие states проигрываются один раз: `attack`, `death`, `cast`. |
| `event frames` | На каком кадре удар, звук, снаряд, вспышка, ресурс. |
| `scale note` | Сравнение с оригинальным силуэтом: меньше/так же/крупнее. |
| `readability note` | Проверка, что силуэт читается на игровом zoom. |

Технические правила:

- кадры одного spritesheet имеют одинаковый размер;
- прозрачный фон;
- без лишних полей между кадрами, если в spec не указаны margins;
- все кадры выровнены по одному pivot;
- направление, оружие и ноги не должны прыгать между кадрами;
- player color лучше держать отдельной маской или согласованной palette zone;
- не смешивать разные unit ids в один дизайнерский лист без согласованного atlas
  plan;
- не отдавать только GIF/MP4: они годятся для preview, но не для runtime.

## Размеры и сетки из оригинального референса

Это reference-only данные из извлеченного Wargus. Они нужны дизайнеру для
понимания масштаба и плотности анимаций, но не являются разрешением копировать
оригинальные ассеты.

| Референс | Spritesheet | Frame | Sheet | Grid | Animation id |
| --- | --- | --- | --- | --- | --- |
| Human worker | `human/units/peasant.png` | `72x72` | `360x936` | `5x13` | `animations-peasant` |
| Human melee infantry | `human/units/footman.png` | `72x72` | `360x864` | `5x12` | `animations-footman` |
| Human ranged infantry | `human/units/elven_archer.png` | `72x72` | `360x720` | `5x10` | `animations-archer` |
| Human cavalry | `human/units/knight.png` | `72x72` | `360x1008` | `5x14` | `animations-knight` |
| Human caster | `human/units/mage.png` | `72x72` | `360x1152` | `5x16` | `animations-mage` |
| Siege engine | `human/units/ballista.png` | `64x64` | `320x256` | `5x4` | `animations-ballista` |
| Human ship | `human/units/battleship.png` | `88x88` | `440x264` | `5x3` | `animations-battleship` |
| Human flying unit | `human/units/gryphon_rider.png` | `80x80` | `400x1040` | `5x13` | `animations-gryphon-rider` |
| Orc worker | `orc/units/peon.png` | `72x72` | `360x936` | `5x13` | `animations-peon` |
| Orc melee infantry | `orc/units/grunt.png` | `72x72` | `360x864` | `5x12` | `animations-grunt` |
| Orc ranged infantry | `orc/units/troll_axethrower.png` | `72x72` | `360x864` | `5x12` | `animations-axethrower` |
| Orc heavy infantry | `orc/units/ogre.png` | `72x72` | `360x1008` | `5x14` | `animations-ogre` |
| Orc caster | `orc/units/death_knight.png` | `72x72` | `360x936` | `5x13` | `animations-death-knight` |
| Orc flying unit | `orc/units/dragon.png` | `88x80` | `440x800` | `5x10` | `animations-dragon` |
| Critter/small creature | `neutral/units/skeleton.png` | `56x56` | `280x784` | `5x14` | `animations-skeleton` |

Наблюдение: многие листы имеют 5 колонок. В Wargus animation script часто
ссылается на frame ids с шагом `5` (`0`, `5`, `10`, `15`, ...), а facing/direction
добавляется движком. В порте нельзя полагаться на неявное поведение: нужно явно
указать `direction_policy`.

## Рекомендуемые размеры для нового визуала

Для первого playable slice можно сохранить близкие размеры кадров:

| Тип | Рекомендуемый frame size | Почему |
| --- | --- | --- |
| Пеший юнит | `72x72` | Совместимо с читаемостью и оригинальным масштабом. |
| Малый юнит/короткая смерть | `56x56` или `64x64` | Меньше памяти для компактных сущностей. |
| Осадная техника | `64x64` или `72x72` | Достаточно для силуэта, экономит atlas. |
| Корабль | `80x88` или `88x88` | Нужен больший силуэт. |
| Летающий крупный юнит | `80x80` или `88x80` | Сохраняет форму и тень. |
| Снаряд | `16x16`, `24x24`, `32x32` | Чем меньше, тем лучше для массовых эффектов. |
| Impact/effect | `32x32`, `48x48`, `64x64` | Зависит от читаемости, должен быть pooled. |

Нельзя без причины делать `128x128` для обычного пешего юнита: это резко увеличит
память, texture bandwidth и atlas pressure.

## Минимальный набор states для первого среза

### Worker

- `idle`;
- `move`;
- `attack`;
- `death`;
- `harvest_wood`;
- `repair`;
- `carry_gold`;
- `carry_wood`;
- `build` или `work`.

### Combat unit

- `idle`;
- `move`;
- `attack`;
- `death`;
- optional `selected/ready` visual accent через UI/audio, не отдельная логика.

### Building

- `idle`;
- `constructing`;
- `training` или `researching`, если нужен active state;
- `damaged`;
- `death/destroyed`.

### Projectile/effect

- `spawn`;
- `fly` или `active`;
- `impact`;
- optional `trail`.

## Производительность

Правила для реализации:

- один lightweight animation player должен обслуживать все однотипные views;
- кадр вычисляется по данным, без создания новых объектов в горячем цикле;
- frame rects кэшируются при загрузке bank;
- views переиспользуются через pools;
- culling выключает update невидимых one-shot effects;
- animation tick может быть ниже render FPS;
- state сменяется только при dirty event/state change, а не тяжелым поиском
  каждый кадр;
- atlases группируются по faction/type, чтобы уменьшить texture switches;
- оригинальные ассеты не коммитятся в `content/assets/` без прав.

## Проверки перед интеграцией

Перед тем как ассет попадет в runtime:

1. Sheet size делится на frame size.
2. Количество frames в spec не выходит за пределы sheet.
3. У каждого mandatory state есть fallback.
4. У `attack/cast/projectile` есть event marker.
5. Pivot одинаковый во всех кадрах.
6. Player color mask совпадает с основным листом по размеру.
7. Preview показывает idle, move, attack, death.
8. Ассет проверен на игровом zoom и на слабом графическом профиле.

## Что сказать дизайнеру в задаче

Формулировка должна включать:

- ссылку на reference board с оригинальным юнитом/зданием/эффектом;
- frame size и grid target;
- список states;
- direction policy;
- event frames;
- pivot;
- запрет рисовать только видео/GIF вместо spritesheet;
- performance budget;
- список файлов, которые дизайнер должен сдать.

Пример короткого требования:

```text
Сделать новый spritesheet для worker. Ориентир по структуре: peasant/peon
72x72, 5 columns x 13 rows. Не копировать оригинал. Сдать PNG spritesheet,
optional player-color mask и animation_spec.md. Обязательные states: idle,
move, attack, death, harvest_wood, repair, carry_gold, carry_wood. Указать
hit_frame/sound_frame для attack и work_frame для harvest/repair.
```

## Definition of Done для animation asset

Ассет считается готовым, когда:

- дизайнерский пакет сдан в понятной папке;
- spec содержит размеры, states, markers, pivot и direction policy;
- runtime atlas/spritesheet импортирован в разрешенную папку `content/assets/`;
- animation bank ссылается на ассет через visual id;
- unit/building/projectile visual catalog ссылается на animation bank;
- Presentation проигрывает animation states без логики Warcraft Runtime внутри View;
- есть ручная проверка в demo scene или test map;
- ограничения записаны явно.
