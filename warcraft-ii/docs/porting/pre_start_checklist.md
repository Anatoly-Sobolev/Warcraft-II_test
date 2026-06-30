# Pre-start checklist for Warcraft II porting

Этот чеклист нужно закрыть до первой задачи по переносу механик. Его цель -
убедиться, что команда начинает не новую RTS, а воспроизводимый порт Warcraft II с
понятным reference flow, границами runtime и performance-критерием.

## 1. Reference environment

- [ ] Зафиксирован локальный путь к Wargus checkout у ответственного за анализ.
- [ ] Зафиксирован локальный путь к установленной Warcraft II BNE/GOG версии у
  ответственного за проверку оригинала.
- [ ] `external/` остается локальной рабочей зоной и не становится обязательной
  runtime-зависимостью релизной сборки.
- [ ] В Git попадают только reference reports, схемы, каталоги и новые ассеты.

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
