# Структура репозитория

Документ помогает быстро понять, где лежат основные материалы и куда добавлять
новые файлы.

## Корень репозитория

| Путь | Назначение |
| --- | --- |
| `README.md` | Входная точка: что это за проект и как его запустить. |
| `AGENTS.md` | Обязательные правила для ИИ-агентов и разработчиков. |
| `.gitignore` | Исключения Git. |
| `warcraft-ii/` | Godot-проект, код, контент, тесты и документация. |

В корне не нужно хранить подробные спецификации, планы спринтов и справочные
материалы. Они должны лежать в `warcraft-ii/docs/`.

## Основные каталоги проекта

| Путь | Что хранит |
| --- | --- |
| `app/` | Запуск приложения, экраны, жизненный цикл. |
| `game/` | Игровые модули: match, input, simulation, scenario, presentation, campaign. |
| `ui/` | HUD, меню, панели, overlay. |
| `services/` | Сохранения, настройки, ресурсы, платформа, диагностика. |
| `content/` | Схемы, каталоги, карты, кампании, игровые данные. |
| `tests/` | Unit, integration, performance и fixtures. |
| `debug/` | Отладочные overlay и инструменты для разработки. |
| `tools/` | Инструменты разработки и валидации вне runtime. |
| `docs/` | Архитектура, дизайн, планы, оценка, тестирование, спецификации. |

## Главные документы

| Документ | Когда читать |
| --- | --- |
| `AGENTS.md` | Перед любой задачей. |
| `docs/architecture/architecture.md` | Перед первым изменением или архитектурным review. |
| `docs/architecture/architecture_details.md` | Когда нужно понять, куда класть код. |
| `docs/product/eight_week_ai_delivery_plan.md` | При планировании спринтов и задач. |
| `docs/product/user_story_map.md` | Когда нужно связать фичу с пользовательской ценностью. |
| `docs/design/visual_integration.md` | Перед изменениями HUD, UI, presentation, ассетов или анимаций. |
| `docs/testing/test_strategy.md` | Перед тестированием и фиксацией test cases. |
| `docs/evaluation/season_2026_alignment.md` | Перед пятничной сдачей. |

## Куда добавлять новое

| Нужно добавить | Куда класть |
| --- | --- |
| Новую механику RTS | `game/simulation/` + тесты + строка в `mechanics_matrix.md`. |
| Новый экран или HUD | `ui/screens/`, `ui/hud/`, `ui/components/`, `ui/overlays/`; правила в `docs/design/visual_integration.md`. |
| UI motion, hover, press, tooltip animation | Рядом с компонентом или в `ui/animation/`, если правило общее. |
| Визуальное отображение мира | `game/presentation/` + визуальные данные в `content/schema/presentation/` и `content/catalogs/`. |
| Миссию, цель, briefing | `game/scenario/` и `content/`. |
| Баланс, юнитов, здания | `content/schema/`, `content/catalogs/`, `content/balance/`. |
| Визуальные ассеты, placeholders, шрифты, иконки | `content/assets/` с учетом прав и asset pipeline. |
| Save/load | `services/persistence/` и snapshot-структуры владельцев состояния. |
| Документ по процессу | `docs/development/`. |
| Документ по дизайну и визуальной интеграции | `docs/design/`. |
| Документ по оценке | `docs/evaluation/`. |
| Отчет спринта | `docs/sprints/`. |

## Что не делать

- Не создавать новые верхнеуровневые папки без причины.
- Не класть подробные спецификации в корень репозитория.
- Не добавлять игровые правила в UI, Presentation или Godot scenes.
- Не собирать HUD или экран как монолитную сцену, если внутри есть независимые
  компоненты.
- Не хранить "временные" решения без known issue или задачи на cleanup.
