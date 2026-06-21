# Архитектура проекта

Короткое и читаемое описание архитектуры (каркас + обоснование) лежит в корне
репозитория: [`ARCHITECTURE.md`](../../../ARCHITECTURE.md).

Рабочая часть с папками, маршрутом разработки и ответом «куда класть новый код»:
[`ARCHITECTURE_DETAILS.md`](../../../ARCHITECTURE_DETAILS.md).

Начните с короткой архитектуры. Этот каталог (`docs/`) хранит подробные спецификации
для тех, кому нужны конкретные формулы и бюджеты:

- `gameplay/gameplay_spec.md` — правила, формулы боя, экономики, баланса
- `input/touch_ux_spec.md` — приоритеты жестов и размеры зон касания
- `performance/target_device.md` — профиль слабейшего устройства «Авроры»
- `performance/performance_budgets.md` — измеренные бюджеты кадра и тика
- `platform/aurora_build.md` — воспроизводимая сборка под «Аврору»
- `persistence/save_format.md` — формат и версии файла сохранения
- `testing/test_strategy.md` — стратегия тестов
- `content/content_pipeline.md` — как добавлять контент
