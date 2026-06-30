# Local reference setup

Документ отвечает на вопрос: нужно ли каждому участнику проекта иметь Wargus и
файлы Warcraft II локально.

## Короткий ответ

Нет, не каждому.

Для обычной разработки проекта достаточно репозитория и Godot. Локальные Wargus
source checkout, купленная игра и extracted assets нужны только участникам,
которые занимаются:

- анализом оригинальных mechanics/metadata;
- подготовкой reference boards для дизайнера;
- импортом карт/звуков/animation reports;
- проверкой соответствия Warcraft II по исходным материалам.

Проект не должен требовать локальную Warcraft II installation для запуска,
тестов обычных модулей или работы UI/Warcraft Runtime.

## Что можно хранить локально

Рекомендуемый локальный layout:

```text
<repo root>/
  external/
    wargus_source/
    wargus_portable/
    wargus_extracted/
    gog_unpacked/
```

`external/` уже исключен из Git. Можно использовать и другие пути, если они
указаны в локальных переменных/скриптах и не попадают в коммит.

Пример текущей локальной конфигурации автора:

```text
C:\Users\UZER\Coding\Projects\wargus
C:\Users\UZER\Saved Games\warcraft_2_battlenet_edition
C:\Users\UZER\Coding\Projects\Warcraft II\external\wargus_extracted
```

Эти пути не являются обязательными для остальных участников.

## Что нельзя коммитить

- оригинальные Warcraft II assets: PNG, WAV, MID/OGG, SMK, PUD, extracted
  sprites, tilesets, videos;
- распакованные файлы купленной игры;
- локальные экспериментальные копии Wargus source/runtime adapters, если команда не приняла отдельное решение хранить их в репозитории;
- generated boards, если внутри них лежат копии оригинальных изображений, а не
  только ссылки/описания;
- локальные абсолютные пути как единственный способ работы команды.

Можно коммитить:

- Markdown/CSV/JSON reports, если они содержат только ids, размеры, frame
  numbers, state names, flags, counts и ссылки на source names;
- собственные схемы `.gd` и каталоги `.tres`;
- placeholders и новые легальные ассеты проекта;
- документацию по тому, как локально повторить extraction.

## Как делиться результатом анализа

Участник с локальными оригинальными материалами не выкладывает файлы игры в Git.
Вместо этого он создает:

```text
content/imported/
  maps/<map_id>_reference_report.md
  animation/<unit_id>_animation_reference.md
  audio/<group_id>_sound_reference.md
```

Отчет должен отвечать на вопросы:

- какой original/source id анализировался;
- какие размеры, flags, states, counts найдены;
- куда это должно лечь в нашем проекте;
- какие вопросы нужно проверить вручную;
- какие файлы являются reference-only и не входят в runtime.

## Когда всем понадобится локальная игра

Всем участникам локальная игра не нужна. Она понадобится только если команда
решит проводить массовую проверку импорта или каждый участник будет независимо
сравнивать поведение с оригиналом. Даже в этом случае в Git должны попадать
только наши reports, tests, schemas и catalogs.
