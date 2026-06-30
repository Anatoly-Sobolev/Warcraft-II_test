# AI and Developer Instructions

Эти правила обязательны для ИИ-агентов и разработчиков, которые меняют проект.

## Перед началом работы

Прочитать:

- `[README.md](README.md)`;
- `[warcraft-ii/docs/architecture/architecture.md](warcraft-ii/docs/architecture/architecture.md)`;
- `[warcraft-ii/docs/architecture/architecture_details.md](warcraft-ii/docs/architecture/architecture_details.md)`;
- `[warcraft-ii/README.md](warcraft-ii/README.md)`;
- `[warcraft-ii/docs/gameplay/mechanics_matrix.md](warcraft-ii/docs/gameplay/mechanics_matrix.md)`;
- README того модуля, который меняется.

Если задача касается сдачи спринта, дополнительно прочитать:

- `[warcraft-ii/docs/evaluation/season_2026_alignment.md](warcraft-ii/docs/evaluation/season_2026_alignment.md)`;
- `[warcraft-ii/docs/testing/test_strategy.md](warcraft-ii/docs/testing/test_strategy.md)`;
- актуальный отчет спринта в `warcraft-ii/docs/sprints/`.

## Нельзя

- Нельзя добавлять механику Warcraft II без строки или источника в `mechanics_matrix.md`.
- Нельзя коммитить оригинальные ассеты Warcraft II, если на них нет прав.
- Нельзя хранить игровую логику в Godot Node, UI или Presentation.
- Нельзя менять состояние `Warcraft Runtime` напрямую из UI, Presentation, Scenario или Input.
- Нельзя обходить `WarcraftCommand` или runtime order/script API для действий игрока, AI или сценария.
- Нельзя придумывать новую RTS-механику, если есть Warcraft II/Wargus reference.
- Нельзя обещать в отчете спринта то, что не запускается в текущей версии проекта.

## Архитектурные правила

- `game/warcraft_runtime/` - единственный источник правды о матче.
- `game/presentation/` и `ui/` только показывают подготовленное состояние.
- Вход в runtime идет через `WarcraftCommand`, runtime order или адаптированный mission/AI script step.
- Выход из runtime идет через события, dirty-буферы и UI/render snapshots.
- Юнит или здание в логике - это `UnitHandle` и runtime state, а не отдельный Node с игровой логикой.
- Runtime-модель намеренно близка к Wargus/Stratagus: `UnitType`, `Unit`, `Player`, `Order`, `Map`, `GameCycle`.
- Новый контент добавляется через схемы, каталоги, reference reports и `.tres`, если для него не нужна новая runtime-механика.
- Сначала reference/source, тест и измерение, потом реализация и оптимизация.

## Где размещать изменения


| Тип изменения                             | Основное место                   |
| ----------------------------------------- | -------------------------------- |
| Запуск приложения, роутинг экранов        | `warcraft-ii/app/`               |
| Прогресс кампании                         | `warcraft-ii/game/campaign/`     |
| Один матч и сборка модулей                | `warcraft-ii/game/match/`        |
| Жесты, выбор, команды игрока              | `warcraft-ii/game/input/`        |
| Warcraft II runtime, orders, бой, экономика, туман, AI | `warcraft-ii/game/warcraft_runtime/` |
| Миссии, цели, триггеры, обучение          | `warcraft-ii/game/scenario/`     |
| Отображение мира, камера, звук матча      | `warcraft-ii/game/presentation/` |
| HUD, меню, панели                         | `warcraft-ii/ui/`                |
| Сохранения, настройки, ресурсы, платформа | `warcraft-ii/services/`          |
| Баланс, каталоги, карты, ассеты           | `warcraft-ii/content/`           |
| Тесты                                     | `warcraft-ii/tests/`             |
| Проектные спецификации                    | `warcraft-ii/docs/`              |


## Definition of Done

Изменение считается готовым только если:

- проект открывается в Godot 4.4;
- демо-сценарий, затронутый изменением, запускается;
- добавлены или обновлены тесты либо ручные тест-кейсы;
- обновлены затронутые документы;
- если добавлена механика Warcraft II, обновлена `mechanics_matrix.md`;
- если изменение входит в спринт, обновлен отчет спринта;
- известные ограничения записаны явно.

## Еженедельная рутина

До пятничной проверки:

1. Запустить проект из чистого состояния.
2. Пройти smoke test из `docs/testing/test_strategy.md`.
3. Обновить отчет спринта.
4. Проверить, что все ссылки в README и отчете открываются.
5. Убедиться, что все материалы лежат в GitVerse.
6. Описать, какие тесты реально запускались и какой результат получили.
