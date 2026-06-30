# Архитектура: рабочие детали

*Вторая часть архитектуры. Читать перед началом конкретной задачи: какие модули
есть, за что они отвечают и куда класть новый код.*

Первая, короткая часть: [architecture.md](architecture.md).

---

## Как читать

Этот файл фиксирует **границы и назначение**, а не алгоритмы. Формулы, бюджеты,
форматы и UX-правила лежат в `warcraft-ii/docs/`.

Для задачи обычно хватает трёх шагов:

1. Найти модуль в каталоге ниже.
2. Проверить запреты модуля.
3. Свериться с таблицей «Куда класть новый код».

---

## Структура папок

```text
warcraft-ii/                 (res://)
├── app/            запуск, экраны, жизненный цикл
├── game/
│   ├── campaign/   прогресс между миссиями
│   ├── match/      сборка одного матча
│   ├── input/      жесты, выбор, создание команд
│   ├── simulation/ вся игровая логика
│   ├── scenario/   миссии, сюжет, обучение
│   └── presentation/ отображение игрового мира
├── ui/             меню, HUD, панели, оверлеи
├── services/       сохранения, настройки, ресурсы, платформа
├── content/        схемы, каталоги, баланс, кампании, карты, ассеты
├── tests/          unit / integration / performance
├── debug/          отладочные оверлеи
├── tools/          инструменты вне игры
└── docs/           подробные спецификации
```

---

## Каталог модулей

### `app/`

**Роль:** вход в приложение, крупные экраны, жизненный цикл.

**Ключевые файлы:**

- `app.tscn`, `app.gd` — корневая сцена приложения.
- `bootstrap.gd` — начальная настройка.
- `scene_router.gd` — переключение экранов.
- `app_lifecycle.gd` — сворачивание, выход, пауза приложения.
- `app_state.gd` — состояние уровня приложения.

**Нельзя:** считать правила игры, хранить состояние матча.

### `game/campaign/`

**Роль:** прогресс между миссиями.

**Ключевые файлы:**

- `campaign_controller.gd` — управление кампанией.
- `campaign_state.gd` — открытые миссии, результаты, сложность.
- `campaign_progression.gd` — правила открытия миссий.
- `campaign_view_data.gd` — данные для экранов кампании.

**Нельзя:** грузить игровой мир и менять Simulation напрямую.

### `game/match/`

**Роль:** один игровой сеанс, composition root.

**Ключевые файлы:**

- `match.tscn`, `match.gd` — корень матча.
- `match_composition.gd` — создаёт и связывает input, simulation, scenario, presentation, ui, services.
- `match_config.gd` — карта, seed, стороны, сложность.
- `match_snapshot.gd` — общий снимок матча.
- `match_result.gd` — итог для кампании.
- `skirmish_config_builder.gd` — сборка конфигурации схватки.

**Нельзя:** считать бой, добычу, AI или UI-логику.

### `game/input/`

**Роль:** ввод игрока: касания, выбор, команды, намерения камеры.

**Ключевые файлы:**

- `input_controller.gd` — точка входа событий Godot.
- `gesture_recognizer.gd` — распознавание жестов.
- `input_state.gd` — выбранные EntityId и режим команды.
- `selection_controller.gd` — выбор через `selection_query`.
- `command_composer.gd` — сборка `GameCommand`.
- `camera_intent.gd` — намерение сдвинуть/приблизить камеру.
- `selection_presentation_data.gd` — подсветка выбранного для Presentation.

**Нельзя:** решать, можно ли действие. Это проверяет `simulation`.

### `game/simulation/`

**Роль:** авторитетный игровой мир.

**Корневые файлы:**

- `simulation_world.gd` — собирает хранилища, системы, сетки, порты.
- `simulation_runner.gd` — такты, накопление времени, запуск систем.
- `simulation_config.gd` — частоты, лимиты, настройки симуляции.
- `simulation_snapshot.gd` — сохраняемое состояние Simulation.

**Нельзя:** обращаться к сценам, UI, звуку, файлам, платформе.

#### `game/simulation/core/`

**Роль:** фундамент симуляции.

**Файлы:**

- `entity_id.gd` — индекс + поколение.
- `entity_registry.gd` — создание и освобождение ID.
- `dense_id_set.gd` — плотный перебор активных компонентов.
- `entity_factory.gd` — создание сущности из данных контента.
- `game_command.gd` — намерение игрока, AI или сценария.
- `command_queue.gd` — очередь команд по тактам.
- `unit_order.gd` — длительное состояние принятого приказа.
- `simulation_event.gd`, `event_buffer.gd` — события симуляции.
- `simulation_random.gd` — сохраняемый RNG.
- `tick_scheduler.gd` — редкие системы по расписанию.

#### `game/simulation/storage/`

**Роль:** компонентные данные в плотных массивах.

**Группы файлов:**

- База сущности: `identity_storage.gd`, `transform_storage.gd`, `ownership_storage.gd`.
- Жизнь и бой: `health_storage.gd`, `combat_storage.gd`, `status_effect_storage.gd`.
- Движение и карта: `movement_storage.gd`, `vision_storage.gd`, `terrain_runtime_storage.gd`.
- Экономика: `worker_storage.gd`, `resource_node_storage.gd`, `side_storage.gd`.
- Здания и производство: `building_storage.gd`, `production_storage.gd`.
- Спецсистемы: `ability_runtime_storage.gd`, `projectile_storage.gd`, `transport_storage.gd`.
- Статистика: `statistics_storage.gd`.

**Нельзя:** отдавать наружу изменяемые массивы.

#### `game/simulation/systems/`

**Роль:** вся изменяющая логика мира по тактам.

**Порядок систем:**

```text
command → economy → terrain → construction → production → ability →
status_effect → movement → transport → combat → projectile → visibility →
ai → cleanup
```

**Ключевые файлы:**

- `command_system.gd` — проверка и принятие команд.
- `economy_system.gd` — добыча, перенос, ресурсы.
- `terrain_system.gd` — лес, ресурсы, проходимость.
- `construction_system.gd` — размещение и стройка.
- `production_system.gd` — очереди юнитов и технологий.
- `movement_system.gd` — движение по пути.
- `combat_system.gd` — атака, cooldown, урон.
- `visibility_system.gd` — туман войны.
- `cleanup_system.gd` — смерть, освобождение ID и клеток.

**Нельзя:** создавать сцены, читать input/UI, выделять мусор в горячих циклах.

#### `game/simulation/spatial/`

**Роль:** логическая карта, занятость, видимость, быстрый поиск.

**Файлы:**

- `map_grid.gd` — клетки карты.
- `static_occupancy_grid.gd`, `dynamic_occupancy_grid.gd` — статическая и динамическая занятость.
- `reservation_grid.gd` — резервирование движения.
- `visibility_grid.gd` — explored/visible.
- `spatial_index.gd` — быстрый поиск сущностей.
- `path_region_versions.gd` — версии областей для кэша путей.

#### `game/simulation/navigation/`

**Роль:** поиск пути и обслуживание очереди путей.

**Файлы:**

- `grid_pathfinder.gd` — A* по сетке.
- `navigation_service.gd` — фасад навигации.
- `path_request_queue.gd` — очередь запросов.
- `path_cache.gd` — кэш путей.
- `group_path_planner.gd` — групповое движение.
- `stuck_resolver.gd` — выход из застреваний.

#### `game/simulation/ai/`

**Роль:** AI планирует обычные `GameCommand`.

**Файлы:**

- `ai_controller.gd` — координация AI.
- `ai_state_storage.gd` — состояние планирования.
- `ai_directive.gd` — намерения AI.
- `economy_planner.gd` — экономика.
- `army_planner.gd` — армия.

**Нельзя:** менять хранилища в обход команд.

#### `game/simulation/ports/`

**Роль:** единственные двери наружу.

**Вход:** `command_sink.gd`.

**Запросы:** `selection_query.gd`, `command_query.gd`, `scenario_query.gd`,
`simulation_ui_query.gd`, `simulation_event_reader.gd`.

**Данные наружу:** `selection_view_data.gd`, `simulation_ui_data.gd`,
`render_change_buffer.gd`, `terrain_change_buffer.gd`, `fog_change_buffer.gd`,
`minimap_change_buffer.gd`.

**Нельзя:** возвращать внутренние массивы `storage/`.

### `game/scenario/`

**Роль:** миссия внутри матча: цели, триггеры, волны, диалоги, обучение.

**Корневые файлы:**

- `scenario_controller.gd` — координация сценария.
- `scenario_state.gd` — состояние сценария.
- `scenario_snapshot.gd` — сохранение сценария.
- `scenario_view_data.gd` — данные для UI.
- `scenario_presentation_port.gd` — запросы к Presentation.

**Подпапки:**

- `mission/` — `mission_runtime.gd`, `condition_evaluator.gd`, `action_executor.gd`.
- `narrative/` — `sequence_runner.gd`, `dialogue_runtime.gd`.
- `tutorial/` — `tutorial_runner.gd`, `tutorial_input_rules.gd`.

**Нельзя:** править `simulation/storage/` напрямую.

### `game/presentation/`

**Роль:** показать игровой мир.

**Корневые файлы:**

- `world_view.tscn`, `world_view.gd` — сцена мира.
- `presentation_controller.gd` — координация кадра.
- `render_sync.gd` — связь `EntityId -> View`.
- `camera_control_port.gd`, `camera_snapshot.gd` — камера.

**Подпапки:**

- `views/` — `unit_view`, `building_view`, `projectile_view`, `effect_view`.
- `render/` — entity/map/fog/selection renderers, `animation_clock`, `view_culling`.
- `camera/` — состояние, контроллер, границы.
- `minimap/` — отрисовка миникарты.
- `pools/` — переиспользование сцен.
- `audio/` — выбор звука по событиям матча.

**Нельзя:** считать урон, путь, экономику, видимость.

### `ui/`

**Роль:** интерфейс поверх игры и отдельные экраны.

**Корень:** `ui_root.tscn`, `ui_root.gd`.

**Подпапки:**

- `hud/` — `hud`, `resource_bar`, `command_panel`, `selection_panel`, `minimap_panel`.
- `screens/` — main menu, campaign select, mission select, skirmish setup, settings, loading, pause, result.
- `components/` — кнопка, tooltip, modal, progress, unit icon.
- `overlays/` — dialogue, tutorial, notifications.
- `theme/` — тема и константы.
- `animation/` — общие UI motion tokens и helper-скрипты.

**Нельзя:** хранить правду о мире, читать `simulation/storage/`, собирать HUD
как одну монолитную сцену вместо отдельных компонентов.

### `services/`

**Роль:** инфраструктура и фасады к платформе.

**Подпапки:**

- `persistence/` — сохранения, миграции, autosave.
- `settings/` — настройки.
- `assets/` — загрузка ресурсов, manifest, cache.
- `audio/` — общий audio service и пул игроков.
- `localization/` — локализация.
- `platform/` — платформа и адаптер «Авроры».
- `diagnostics/` — логгер, performance monitor, content validator.
- `jobs/` — фоновые задачи.

**Нельзя:** принимать игровые решения. Если логика про урон, добычу, миссии или AI —
это не services.

### `content/`

**Роль:** данные игры.

**Подпапки:**

- `schema/gameplay/` — схемы юнитов, зданий, атак, способностей, карты, фракций.
- `schema/presentation/` — визуальные схемы, банки спрайтов и звуков.
- `schema/scenario/` — миссии, цели, условия, действия, tutorial, диалоги.
- `schema/campaign/` — кампания.
- `catalogs/` — `.tres` каталоги.
- `balance/` — правила баланса.
- `campaigns/`, `skirmish/maps/`, `tutorial/` — игровые наборы данных.
- `assets/` — текстуры, атласы, шейдеры, звуки, тайлсеты, шрифты.
- `localization/` — CSV локализации.

**Нельзя:** добавлять новый класс юнита вместо записи в данных.

### `tests/`

**Роль:** проверка логики и связок.

**Подпапки:**

- `unit/` — отдельные классы и системы.
- `integration/` — связки модулей: match, save/load, input flow, scenario.
- `performance/` — бенчмарки.
- `fixtures/` — тестовые данные.

### `debug/`

**Роль:** инструменты разработки поверх игры.

**Файлы:** `performance_overlay`, `world_debug_overlay`, `path_debugger`,
`visibility_debugger`, `terrain_debugger`, `event_log`, `debug_controller`.

**Нельзя:** делать debug обязательной runtime-зависимостью release-сборки.

### `tools/`

**Роль:** инструменты вне игры.

**Файлы:** `content_validation_tool.gd`, `atlas_validation_tool.gd`, `map_baker.gd`.

**Нельзя:** тянуть tools в runtime матча.

### `docs/`

**Роль:** подробные спецификации.

**Подпапки:** `gameplay/`, `input/`, `performance/`, `platform/`, `persistence/`,
`testing/`, `content/`, `architecture/`, `design/`.

---

## Куда класть новый код

| Что добавляем | Куда класть |
| --- | --- |
| Новый тип юнита, здания, способности, технологии | `content/schema/gameplay/` + `content/catalogs/` |
| Баланс: HP, урон, скорость, стоимость | `content/balance/` или `content/catalogs/` |
| Новая характеристика сущности в матче | `game/simulation/storage/` |
| Новое правило игры | `game/simulation/systems/` |
| Новая команда игрока, AI или сценария | `game/simulation/core/game_command.gd`, проверка в `systems/command_system.gd` |
| Данные для HUD | `game/simulation/ports/*ui*` или `selection_view_data.gd` |
| Данные для отрисовки мира | `game/simulation/ports/*change_buffer.gd` |
| Игровой объект на карте | `game/presentation/views/` |
| Рендер карты, тумана, выделения, анимации | `game/presentation/render/` |
| Камера | `game/presentation/camera/` |
| HUD, меню, окно, оверлей | `ui/hud/`, `ui/screens/`, `ui/components/`, `ui/overlays/` |
| UI motion, hover, press, tooltip animation | Рядом с компонентом или `ui/animation/` для общих правил |
| Правила интеграции дизайна | `docs/design/visual_integration.md` |
| Visual ids, sprite/icon/audio banks | `content/schema/presentation/` + `content/catalogs/` |
| Прогресс между миссиями | `game/campaign/` |
| Условие победы, триггер, tutorial, диалог | `game/scenario/` |
| Сохранение, настройки, ресурсы, платформа | `services/` |
| Кампания, карта, локализация, ассеты | `content/` |
| Unit-тест | `tests/unit/` |
| Интеграционный тест | `tests/integration/` |
| Бенчмарк | `tests/performance/` |
| Инструмент вне игры | `tools/` |

---

## Спорные границы

**`presentation/` или `ui/`:** мир, камера, спрайты, туман и миникарта как картинка
мира — `presentation/`. Кнопки, панели, меню и оверлеи — `ui/`.

**`campaign/`, `scenario/` или `match/`:** прогресс между миссиями — `campaign/`;
условия текущей миссии — `scenario/`; сборка игрового сеанса — `match/`.

**`services/` или `game/`:** платформа, файлы, настройки, ресурсы — `services/`;
урон, добыча, строительство, AI, миссии — `game/`.

---

## Как строить проект

1. **Платформенный прототип:** пустой проект под «Аврору», ввод, звук, запись файла,
   FPS-оверлей.
2. **Вертикальный срез:** карта, две стороны, рабочий, ресурс, здание, боец,
   движение, бой, туман, сохранение.
3. **Полная симуляция:** стройка, производство, море/воздух, способности, AI.
4. **Сценарии и кампании:** цели, триггеры, диалоги, обучение, прогресс.
5. **Контент и оптимизация:** наполнение, баланс, бенчмарки.

Дальше следующего этапа не идём, пока текущий не запускается и не даёт понятный
результат на целевом устройстве.
