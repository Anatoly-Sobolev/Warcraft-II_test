# services

> ↑ [Корень проекта](../README.md) · 🏛 [Архитектура](../docs/architecture/architecture.md)

**Статус: заглушка.** Реализуется частично (`persistence`, `platform`, `assets`
нужны уже в вертикальном срезе), остальное — по мере надобности. README можно
расширять по факту.

**Назначение (кратко):** стабильные фасады к платформе и инфраструктуре — настройки,
сохранения, ресурсы, звук, локализация, платформа, диагностика, фоновые задачи.
Игровых решений не принимает.

## Assets

`services/assets/` должен стать единственной точкой загрузки runtime-ассетов:
текстур, атласов, TileSet, sprite/audio banks, сцен эффектов и briefing media.
Цель — повысить производительность и убрать фризы от тяжелых загрузок во время
матча.

Система должна быть лаконичной:

- `ContentManifest` описывает пакеты ресурсов для app shell, common UI, миссии,
  расы и tileset;
- manifest хранит происхождение и статус ассета: `project_final`,
  `project_placeholder`, `original_placeholder`, `replacement_ready` или
  `deprecated_placeholder`;
- `AssetLoader` запускает асинхронную загрузку через Godot threaded loading и
  отдает статус `ready/loading/failed`;
- `ResourceCache` хранит готовые ресурсы и не допускает дублирующих запросов;
- Presentation/UI могут получить placeholder или fallback, если ресурс еще не
  готов;
- оригинальный Warcraft II asset может быть runtime placeholder только как
  `original_placeholder` с записью в `content/assets/placeholder_manifest.json`;
- ошибки логируются через diagnostics и видны в smoke/performance отчетах.

Границы:

- Warcraft Runtime не знает о PNG/WAV/сценах и не вызывает загрузку файлов;
- UI-кнопки, orders и runtime rules не грузят ассеты напрямую;
- fallback влияет только на отображение/звук, но не на состояние матча;
- замена `original_placeholder` на новый ассет является визуальной миграцией
  manifest/catalog, а не изменением Warcraft Runtime;
- синхронный `load()` в горячем кадре допускается только как явно измеренное и
  задокументированное исключение.

Текущая минимальная реализация уже дает `ContentManifest`,
`ResourceCache` и `AssetLoader.load_now()` для bootstrap/manual checks. Перед
использованием в матче `AssetLoader` нужно расширить threaded loading API; прямой
`load_now()` в hot path остается запрещенным.
