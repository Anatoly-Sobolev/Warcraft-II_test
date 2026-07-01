# Pre-start checklist for Warcraft II porting

Этот чеклист нужно закрыть до первой задачи по переносу механик. Его цель -
убедиться, что команда начинает не новую RTS, а воспроизводимый порт Warcraft II с
понятным reference flow, границами runtime и performance-критерием.

## 1. Reference environment

- [ ] Открывается upstream Wargus repository:
  [Wargus/wargus](https://github.com/Wargus/wargus). Ответственный за анализ
  клонирует его локально или скачивает архив исходников.
- [ ] Открывается командная папка с установочными файлами Warcraft II:
  [Warcraft II / Облако Mail](https://cloud.mail.ru/public/U1db/ujYBepiMq).
  Ссылка проверяется вручную в браузере, потому что облако может требовать
  JavaScript или авторизацию.
- [ ] У ответственного за анализ есть Wargus checkout; абсолютный путь записан
  только в приватном `docs/local_reference_paths.local.md` или локальном
  окружении.
- [ ] У ответственного за проверку оригинала есть установленная Warcraft II
  BNE/GOG версия; абсолютный путь не попадает в tracked-документы.
- [ ] Установочные архивы и распакованная игра лежат вне Git: например в
  `external/installers/`, `external/warcraft_ii_install/` или личной папке
  участника. В репозиторий не добавляются EXE/ZIP/ISO/MPQ/SMK/WAV/PNG и другие
  оригинальные файлы игры.
- [ ] `external/` остается локальной рабочей зоной и не становится обязательной
  runtime-зависимостью релизной сборки.
- [ ] В Git попадают только reference reports, схемы, каталоги и новые ассеты.

### Что сделать с reference-файлами перед началом работы

1. Склонировать Wargus:

   ```powershell
   git clone https://github.com/Wargus/wargus.git <local Wargus checkout>
   ```

2. Скачать установочные файлы Warcraft II из командной папки Mail Cloud и
   сохранить их в локальную неотслеживаемую папку, например:

   ```text
   <repo root>/external/installers/
   ```

3. Установить Warcraft II локально или распаковать материалы в личную
   неотслеживаемую папку. Если используется `external/`, оставить ее только как
   private reference workspace.
4. Создать приватный файл `warcraft-ii/docs/local_reference_paths.local.md` и
   записать туда реальные пути к Wargus checkout, установленной игре и
   extracted/reference материалам. Этот файл игнорируется Git.
5. Проверить, что проект Godot запускается без Wargus, без установленной игры и
   без `external/`. Эти материалы нужны только для анализа, дизайна, reports и
   reference parity checks.
6. Если из игры или Wargus получены размеры, ids, states, карты, звуковые группы
   или animation data, записать результат как Markdown/CSV/JSON reference report
   в `content/imported/` или `docs/design/`, без копирования оригинальных assets.

## 2. Mechanics source of truth

- [ ] Для первой волны задач выбран небольшой набор ID из
  `docs/gameplay/mechanics_matrix.md`.
- [ ] У каждой задачи есть Wargus/Warcraft II source: файл, функция, script action
  или наблюдаемое поведение.
- [ ] Для новых уточнений создана строка в `mechanics_matrix.md` до реализации.
- [ ] Отличия от Wargus/оригинала записываются явно как `verify`, `design` или
  known issue.

## 3. Runtime boundaries

- [ ] Все gameplay-задачи кладутся в `game/warcraft_runtime/`, если только они не
  являются чистым UI, Presentation, App или Service.
- [ ] Игрок, AI и сценарии меняют матч только через `WarcraftCommand`, runtime order
  или утвержденный script adapter.
- [ ] UI и Presentation читают ViewData/events/dirty buffers, а не runtime state.
- [ ] `Scenario` не меняет state напрямую: он отправляет команды или mission/script
  steps, которые понимает runtime.

## 4. Project structure readiness

- [ ] `game/warcraft_runtime/model/` содержит базовые concepts: handles, commands,
  orders, events, random, schedule.
- [ ] `game/warcraft_runtime/state/` является местом плоского runtime state.
- [ ] `game/warcraft_runtime/orders/` является местом переноса поведения юнитов.
- [ ] `game/warcraft_runtime/rules/` содержит общие правила карты, видимости,
  lifecycle, missiles и statuses.
- [ ] `game/warcraft_runtime/map/` содержит logical map, occupancy, pathfinding и
  fog grids.
- [ ] `game/warcraft_runtime/scripting/` зарезервирован под Lua/SMS adapters.
- [ ] `game/warcraft_runtime/native/` зарезервирован под GDExtension/C++ hot paths
  только после benchmark.

## 5. Performance baseline

- [ ] Перед первой оптимизацией определен минимальный performance case: game cycle,
  pathfinding, fog или render sync.
- [ ] В sprint report есть место для метрик: tick time, dirty updates, path requests,
  fog cells, FPS/profile.
- [ ] Любой перенос в native/GDExtension имеет измерение до/после.
- [ ] UI не получает задач, которые требуют пересчитывать весь runtime state каждый
  frame.

## 6. AI task format

Каждая задача для ИИ должна начинаться с такого блока:

```text
Mechanic ID:
Reference source:
Runtime target:
Allowed files:
Forbidden files:
Test/manual check:
Performance note:
Known difference policy:
```

Задача без `Mechanic ID` или reference source не считается готовой к реализации,
если она добавляет или меняет Warcraft II gameplay.

## 7. First implementation slice

Рекомендуемый первый вертикальный срез:

1. Godot launch path: `App -> Menu -> Match`.
2. Empty `Warcraft Runtime` with fixed `GameCycle`.
3. `WarcraftCommand` queue.
4. One test unit with `UnitHandle`, position and ownership.
5. `move` command through input/query ports.
6. Presentation view from dirty buffer.
7. Manual smoke test and a tiny performance note.

Этот срез доказывает архитектурные границы до экономики, строительства, боя и AI.
