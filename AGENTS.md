# AI and Developer Instructions

Эти правила обязательны для ИИ-агентов и разработчиков, которые меняют проект.

## Перед началом работы

Прочитать:

- [`README.md`](README.md);
- [`ARCHITECTURE.md`](ARCHITECTURE.md);
- [`ARCHITECTURE_DETAILS.md`](ARCHITECTURE_DETAILS.md);
- [`warcraft-ii/README.md`](warcraft-ii/README.md);
- [`warcraft-ii/docs/gameplay/mechanics_matrix.md`](warcraft-ii/docs/gameplay/mechanics_matrix.md);
- README того модуля, который меняется.

Если задача касается сдачи спринта, дополнительно прочитать:

- [`warcraft-ii/docs/evaluation/season_2026_alignment.md`](warcraft-ii/docs/evaluation/season_2026_alignment.md);
- [`warcraft-ii/docs/testing/test_strategy.md`](warcraft-ii/docs/testing/test_strategy.md);
- актуальный отчет спринта в `warcraft-ii/docs/sprints/`.

## Нельзя

- Нельзя добавлять механику Warcraft II без строки или источника в `mechanics_matrix.md`.
- Нельзя переносить GPL-код Wargus напрямую в кодовую базу без отдельного лицензионного решения.
- Нельзя коммитить оригинальные ассеты Warcraft II, если на них нет прав.
- Нельзя хранить игровую логику в Godot Node, UI или Presentation.
- Нельзя менять состояние Simulation напрямую из UI, Presentation, Scenario или Input.
- Нельзя обходить `GameCommand` для действий игрока, AI или сценария.
- Нельзя обещать в отчете спринта то, что не запускается в текущей версии проекта.

## Архитектурные правила

- `game/simulation/` - единственный источник правды о матче.
- `game/presentation/` и `ui/` только показывают подготовленное состояние.
- Вход в Simulation идет через команды.
- Выход из Simulation идет через события, dirty-буферы и ViewData.
- Юнит или здание в логике - это `EntityId` и данные в хранилищах, а не отдельный Node с игровой логикой.
- Новый контент добавляется через схемы, каталоги и `.tres`, если для него не нужна новая общая механика.
- Сначала измерение и тест, потом оптимизация.

## Где размещать изменения

| Тип изменения | Основное место |
| --- | --- |
| Запуск приложения, роутинг экранов | `warcraft-ii/app/` |
| Прогресс кампании | `warcraft-ii/game/campaign/` |
| Один матч и сборка модулей | `warcraft-ii/game/match/` |
| Жесты, выбор, команды игрока | `warcraft-ii/game/input/` |
| Правила RTS, бой, экономика, туман, AI | `warcraft-ii/game/simulation/` |
| Миссии, цели, триггеры, обучение | `warcraft-ii/game/scenario/` |
| Отображение мира, камера, звук матча | `warcraft-ii/game/presentation/` |
| HUD, меню, панели | `warcraft-ii/ui/` |
| Сохранения, настройки, ресурсы, платформа | `warcraft-ii/services/` |
| Баланс, каталоги, карты, ассеты | `warcraft-ii/content/` |
| Тесты | `warcraft-ii/tests/` |
| Проектные спецификации | `warcraft-ii/docs/` |

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
