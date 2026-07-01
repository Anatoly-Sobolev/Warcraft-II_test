# Workflow задачи в порте Warcraft II

Документ описывает не архитектуру проекта и не план спринтов, а порядок работы
над одной задачей: найти Warcraft II/Wargus reference, определить владельца
состояния, поставить задачу ИИ, проверить результат и подготовить изменение к
сдаче спринта.

Команда: 4 программиста, 1 дизайнер, 1 тестировщик и 1 менеджер. Все роли
работают вокруг одного правила: проект является gameplay-equivalent портом
Warcraft II с новыми ассетами, а не новой RTS.

## Роли в задаче

| Роль | Что делает в workflow |
| --- | --- |
| P1-P4, программисты | Переносят механику, runtime, UI, presentation, content/tools/services в своих зонах ответственности. |
| D, дизайнер | Готовит reference board, новые ассеты, размеры, states, integration notes и список спорных мест. |
| Q, тестировщик | Готовит test cases, запускает smoke/regression/manual checks, заводит баги и проверяет исправления. |
| M, менеджер | Утверждает scope, принимает пятничное демо, фиксирует переносы и blockers. |

## Перед началом задачи

1. Прочитать `AGENTS.md`.
2. Прочитать `docs/architecture/architecture.md`.
3. Прочитать `docs/architecture/architecture_details.md`.
4. Прочитать README модуля, который меняется.
5. Если задача требует reference-файлов, проверить
   `docs/porting/local_reference_setup.md`.
6. Если задача добавляет или меняет Warcraft II-механику, найти строку в
   `docs/gameplay/mechanics_matrix.md`.
7. Найти source/reference: Wargus Lua/SMS/SMP/PUD, installed game behavior,
   reference report или design reference pack.
8. Если задача входит в спринт, открыть актуальный отчет в `docs/sprints/`.

Задача по механике не готова к реализации, если у нее нет source/reference и
понятного места в `game/warcraft_runtime/`, catalogs, scenario или presentation
boundary.

## Не строим платформу заранее

Архитектура задает границы роста, но задача должна идти по минимальному пути:
source -> command/script step -> order/rule -> state -> check.

- `native/` не трогаем без benchmark и конкретного hot path.
- `scripting/` не превращаем в полноценный Lua runtime без выбранной mission/script
  задачи.
- AI расширяем только от конкретной Wargus directive, build order или attack wave.
- Import pipeline делаем через нужные reports и converters, а не через
  универсальный importer всего Warcraft II.
- Dirty buffers, snapshots и ports расширяем только под конкретный UI,
  Presentation, save/load или тестовый сценарий.

Если задача звучит как «сделать систему X», ее нужно переписать как «перенести
конкретное поведение X из source Y и проверить сценарием Z».

## Жизненный цикл задачи

| Шаг | Что делает исполнитель | Что должно остаться в репозитории |
| --- | --- | --- |
| 1. Уточнить цель | Определить user story, sprint task, demo path и критерий приемки. | Заполненная задача по `sprint_task_template.md`, issue или строка в sprint report. |
| 2. Найти reference | Указать Wargus/Warcraft source, mechanics row, report или design board. | Ссылка на `mechanics_matrix.md`, reference report или design handoff. |
| 3. Определить границы | Найти владельца состояния и запрещенные слои. | Явный target module и forbidden files/layers в задаче. |
| 4. Сформулировать промпт | Дать ИИ контекст порта, reference, DoD, тест, запреты и known difference policy. | Промпт или краткое резюме можно сохранить, если это важно для ревью. |
| 5. Получить изменение | Проверить, что ИИ не придумал новую RTS-механику и не вышел за границы модуля. | Код/документы только в ожидаемых местах. |
| 6. Проверить | Запустить unit/integration/manual/performance check или передать Q для проверки. | Результат проверки и баги в sprint report или test case. |
| 7. Обновить документы | Обновить README, test cases, mechanics matrix, reference report, design handoff или sprint report. | Документы совпадают с реальным поведением. |
| 8. Review и приемка | Проверить архитектуру, ссылки, known issues, demo path; менеджер принимает scope недели. | Исправленные замечания, явные ограничения или перенос задачи. |

## Минимальный review checklist

- Изменение лежит в правильном модуле.
- Игровая логика не попала в UI, Presentation, Godot Node или сцену.
- Действия игрока, AI и сценария идут через `WarcraftCommand`, runtime order или
  утвержденный script adapter.
- Warcraft Runtime не зависит от файловой системы, звука, UI и Presentation.
- Новая Warcraft II-механика имеет ссылку на `mechanics_matrix.md` и
  Wargus/Warcraft source.
- Дизайнерские ассеты имеют reference board, target path и integration notes.
- Тестировщик знает, какой smoke/regression/manual check подтверждает задачу.
- Sprint report говорит только о том, что реально запускается.
- Локальные Markdown-ссылки не сломаны.
- Оригинальные Warcraft II assets, установщики и личные абсолютные пути не
  попали в Git.

## Правило пятницы

Перед пятничной проверкой команда сначала закрывает воспроизводимость:

1. Чистый запуск проекта по README.
2. Проход демо-сценария текущего спринта.
3. Проверка README, onboarding, sprint report и важных локальных ссылок.
4. Фиксация тестов, которые реально запускались.
5. Фиксация known issues, blockers и переносов scope.
6. Менеджер принимает только то, что можно запустить или честно показать как
   ограничение.

Новые фичи после этого можно добавлять только если они не рискуют сломать демо.
