# Архитектура порта Warcraft II на Godot 4.4

*Короткая часть для первого чтения: проект является портом Warcraft II с новыми
ассетами, а не новой RTS. Архитектура должна помогать переносить уже существующие
механики и сохранять производительность на ОС «Аврора».*

Подробная рабочая часть: [architecture_details.md](architecture_details.md).

---

## Главная цель

Мы делаем **gameplay-equivalent порт Warcraft II**. Правила, темп, команды,
миссии, AI-поведение и структура кампаний берутся из Warcraft II/Wargus/Stratagus
и проверяются по reference-сценариям. Новыми являются ассеты, адаптация управления
и техническая оболочка под Godot/Аврору.

Приоритеты проекта:

1. **Простота переноса механик** — студент переносит конкретный Wargus/Warcraft II
  concept, а не проектирует RTS с нуля.
2. **Производительность** — стабильные 30 FPS на целевом слабом устройстве.
3. **Проверяемость порта** — каждая механика имеет источник и тест/reference case.
4. **Чистые границы Godot** — игровые правила не живут в Node, UI или сценах.

---

## Новая центральная идея: Warcraft Runtime

Раньше архитектура описывала универсальную `Simulation`. Теперь центр проекта —
`game/warcraft_runtime/`: совместимая по смыслу runtime-модель Warcraft II/Wargus.

```text
Input / AI / Mission Script
        |
        v
   WarcraftCommand
        |
        v
   WARCRAFT RUNTIME
   Unit / UnitType / Player / Order / Map / GameCycle / Trigger
        |
        +-> runtime events
        +-> dirty buffers for render/fog/minimap
        +-> UI snapshots
        v
Presentation / UI
```

Runtime не является произвольной RTS-архитектурой. Его понятия намеренно близки к
Wargus/Stratagus:

- `Unit`, `UnitType`, `Player`, `Order`, `Missile`, `Upgrade`, `Spell`, `Map`;
- `GameCycle` как единица времени;
- order-first логика: move, attack, harvest, build, train, repair, spell, patrol;
- Lua/Wargus data как reference и, при необходимости, прямой runtime/input source.

---

## Как переносить механику

Правило для студентов:

```text
Wargus/Warcraft source -> Runtime concept -> маленький order/rule -> test
```

Пример:

```text
scripts/human/buttons.lua: Action = "train-unit"
        -> WarcraftCommand.TRAIN_UNIT
        -> orders/order_train.gd
        -> test_train_footman / reference report
```

Нельзя начинать с вопроса «как бы мы сделали производство в новой RTS». Нужно
начинать с вопроса «как это устроено в Warcraft II/Wargus и какой минимальный
runtime concept это повторяет».

---

## Производительность

Прямой перенос механик не означает “делать всё объектами Godot”. Горячее ядро
остается отделенным от сцен:

- runtime не зависит от `Node`, `Control`, `Sprite2D`, аудио и файловой системы;
- game cycle фиксированный и не привязан к FPS;
- состояние хранится в плотных массивах или native-структурах там, где это нужно;
- `UnitHandle`/индекс используется для быстрых ссылок, но наружу не отдается как
изменяемая структура;
- pathfinding, fog, массовое движение и бой являются первыми кандидатами на
C++/GDExtension после измерений;
- Lua допустим для загрузки данных, миссий и AI-директив, но не для тысяч
per-unit операций в горячем цикле без отдельного бенчмарка.

---

## Слои проекта


| Модуль               | Ответственность                                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------ |
| **App**              | Запуск, экраны, жизненный цикл приложения. Не знает правил игры.                                 |
| **Campaign**         | Прогресс между миссиями и результаты кампаний.                                                   |
| **Match**            | Сборка одного матча и связывание модулей.                                                        |
| **Input**            | Касания, выбор, hotkeys, превращение действий в `WarcraftCommand`.                               |
| **Warcraft Runtime** | Авторитетный мир Warcraft II: units, players, orders, map, game cycle, combat, economy, fog, AI. |
| **Scenario**         | Оболочка для целей, briefing, tutorial и адаптации mission scripts.                              |
| **Presentation**     | Отображение мира, камера, миникарта, эффекты, игровой звук.                                      |
| **UI**               | HUD, command panel, selection panel, меню и оверлеи.                                             |
| **Services**         | Сохранения, настройки, ресурсы, платформа, локализация, общий audio/cache.                       |
| **Tools**            | Import/reference pipeline из Wargus и установленной игры.                                        |


---

## Поток данных

```text
Reference sources
  Wargus Lua / SMS / SMP / PUD / installed game data
        |
        v
tools/import -> content/imported/reference reports
        |
        v
content/catalogs + runtime adapters
        |
        v
Warcraft Runtime -> Presentation/UI
```

В матче:

```text
input ───────────────┐
mission/scenario ────┼── WarcraftCommand ──► warcraft_runtime
runtime AI ──────────┘                         ├── events ───► scenario/audio
                                                ├── dirty ────► presentation
                                                └── snapshots ► ui/save
```

---

## Контент и ассеты

Правила и численные параметры можно переносить из Wargus/Warcraft II reference.
Финальные визуальные и звуковые ассеты проекта — новые или легально разрешенные.

- gameplay data: `content/schema/gameplay/`, `content/catalogs/`;
- mission/campaign data: `content/schema/scenario/`, `content/campaigns/`;
- visual/audio mapping: `content/schema/presentation/`, `content/assets/`;
- reference reports: `content/imported/`;
- original game installation and Wargus checkout are local references, not
обязательные runtime-зависимости релизной сборки.

---

## Минимальная карта проекта

```text
warcraft-ii/
├── app/                 запуск и экраны
├── game/
│   ├── campaign/        прогресс между миссиями
│   ├── match/           сборка матча
│   ├── input/           ввод -> WarcraftCommand
│   ├── warcraft_runtime/портируемое ядро Warcraft II/Wargus
│   ├── scenario/        briefing, tutorial, objective оболочки
│   └── presentation/    отображение мира
├── ui/                  HUD, меню, панели
├── services/            сохранения, настройки, платформа
├── content/             данные, каталоги, новые ассеты
├── tools/               import/reference pipeline
├── tests/               unit / integration / reference / performance
├── debug/               отладочные оверлеи
└── docs/                спецификации
```

---

## Правила, которые держат порт

- **Портируем Wargus/Warcraft II concept, не придумываем новую RTS-механику.**
- **`game/warcraft_runtime/` — единственный источник правды о матче.**
- **Игровое действие входит как `WarcraftCommand` или runtime order/script step.**
- **Order logic находится в `warcraft_runtime/orders/`, общие правила — в `rules/`.**
- **Godot Node, UI и Presentation не меняют состояние матча напрямую.**
- **Runtime не зависит от сцен и должен тестироваться без запущенного матча.**
- **Производительность проверяется тестом или бенчмарком до “красивой” оптимизации.**
- **Новые ассеты отделены от reference-only Warcraft II/Wargus материалов.**
