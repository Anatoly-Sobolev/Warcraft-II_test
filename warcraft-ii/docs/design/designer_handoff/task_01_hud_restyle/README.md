# Задание дизайнеру 01: рестайл HUD

Это папка выдачи дизайнеру. Ее можно открыть без чтения кода проекта.

Задача: не придумать новый RTS-интерфейс, а перерисовать существующий HUD Warcraft II/Wargus в новом стиле проекта. Состав HUD, расположение зон и набор состояний сохраняются.

## Что смотреть

После подготовки материалов открыть:

1. [`reference_board.md`](reference_board.md) - доска с картинками оригинального UI.
2. [`materials_checklist.md`](materials_checklist.md) - список обязательных референсов и что на них смотреть.
3. [`task.md`](task.md) - что именно нужно нарисовать и сдать.
4. [`asset_structure.md`](asset_structure.md) - где лежат UI, spritesheets, анимации, sounds и campaign art.

Папка с изображениями:

```text
reference_assets/
```

Эта папка специально исключена из Git, потому что в ней могут лежать оригинальные проприетарные ассеты Warcraft II. Ее можно передать дизайнеру отдельно архивом или через приватное хранилище, если права на такое использование подтверждены.

## Откуда берутся оригинальные ассеты

В репозитории Wargus нет готовой папки с оригинальными картинками Warcraft II. Wargus хранит скрипты, описания UI и инструмент извлечения, но сами изображения нужно извлечь из вашей легальной копии Warcraft II.

Поддерживаемые источники по Wargus:

- GOG installer `setup*.exe`;
- Battle.net Edition CD/installer: `install.mpq`, `Install.mpq`, `INSTALL.MPQ`, `install.exe`;
- DOS CD: `REZDAT.WAR` или `rezdat.war`;
- директория с архивами Warcraft II, где лежат файлы вроде `maindat.war`.

Извлечение делает Wargus tool `wartool` или GUI-скрипт Wargus `scripts/extract.lua`. Локальный checkout Wargus:

```text
<local Wargus checkout>
```

На этой машине готовый `wartool.exe` в checkout не найден. Значит, нужно либо собрать Wargus/wartool, либо взять готовую сборку Wargus, где уже есть `wartool.exe`.

## Быстрый маршрут

1. Подготовить легальный источник Warcraft II: GOG installer, Battle.net Edition CD/installer или DOS CD.
2. Извлечь ассеты через Wargus `wartool` в локальную папку вне Git, например:

```text
external\wargus_extracted
```

3. Проверить, что внутри результата есть PNG-файлы вроде:

```text
ui\human\infopanel.png
ui\human\buttonpanel.png
ui\human\menubutton.png
ui\gold,wood,oil,mana.png
campaigns\human\interface\introscreen1.png
```

4. Скопировать нужные файлы в `reference_assets/` командой:

```powershell
.\collect_reference_assets.ps1 -ExtractedRoot "external\wargus_extracted"
```

5. Для полного дизайнерского каталога PNG выполнить:

```powershell
.\build_designer_asset_catalog.ps1 -ExtractedRoot "external\wargus_extracted"
```

6. Открыть:

- [`reference_board.md`](reference_board.md) - короткая доска первого HUD-задания;
- `generated_boards/ui_board.md` - все UI PNG;
- `generated_boards/animation_spritesheets_board.md` - юниты, construction sites, missiles и spell effects;
- `generated_boards/full_png_catalog.md` - все PNG, извлеченные Wargus.

## Важно

- Не коммитить оригинальные Warcraft II ассеты.
- Не использовать оригинальные картинки как финальные runtime-ассеты проекта.
- Дизайнер делает новые изображения, но опирается на оригинальные композицию, состояния и смысл UI.
- Если какого-то PNG нет после извлечения, нужно сделать screenshot/crop из запущенного Warcraft II или Wargus и положить его в `reference_assets/screenshots/`.
