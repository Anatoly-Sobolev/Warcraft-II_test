# Warcraft II — карта проекта

Одиночная 2D-RTS на Godot 4.4 (GL Compatibility) для ОС «Аврора». Цель — 30 FPS на слабом железе.

- 🏛 **Архитектура и «почему»:** [`../ARCHITECTURE.md`](../ARCHITECTURE.md) — начни отсюда.
- 🧭 **Рабочие детали:** [`../ARCHITECTURE_DETAILS.md`](../ARCHITECTURE_DETAILS.md) — куда класть код, папки, этапы.

## Главная идея за 10 секунд

Мир разделён на два слоя: **Simulation** (вся правда об игре — только данные, без
сцен) и **Presentation/UI** (рисуют готовое состояние). Общение — через узкие порты:
**команды внутрь, подготовленные данные наружу**.

## Слои и модули

| Модуль | Ответственность | README |
|---|---|---|
| **app** | Запуск, экраны, жизненный цикл приложения | [→](app/README.md) |
| **game/campaign** | Прогресс между миссиями | [→](game/campaign/README.md) |
| **game/match** | Сборка одного матча (composition root) | [→](game/match/README.md) |
| **game/input** | Жесты, выбор, создание команд | [→](game/input/README.md) |
| **game/simulation** | **Вся логика и правда о матче** | [→](game/simulation/README.md) |
| **game/scenario** | Миссии, сюжет, обучение | [→](game/scenario/README.md) |
| **game/presentation** | Спрайты, камера, туман, миникарта, звук | [→](game/presentation/README.md) |
| **ui** | Меню, HUD, панели | [→](ui/README.md) |
| **services** | Сохранения, настройки, ресурсы, платформа | [→](services/README.md) |
| **content** | Схемы данных, каталоги, кампании, карты, ассеты | [→](content/README.md) |
| **tests** | unit / integration / performance | [→](tests/README.md) |
| **debug** | Оверлеи отладки (вне релиза) | [→](debug/README.md) |
| **tools** | Валидация контента, запекание карт | [→](tools/README.md) |

## Поток данных (кратко)

```
Input/AI/Scenario ──GameCommand──► Simulation ──┬── события ───► Scenario
                                                ├── dirty-буферы► Presentation
                                                └── ViewData ───► UI
```

Где искать состояние: всё авторитетное — в `game/simulation/`. Кто чем владеет —
в таблице README каждого модуля, в `ARCHITECTURE.md` и в `ARCHITECTURE_DETAILS.md`.
