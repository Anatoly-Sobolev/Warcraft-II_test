# Local reference setup

Документ отвечает на вопрос: нужно ли каждому участнику проекта иметь Wargus и
файлы Warcraft II локально.

## Короткий ответ

Нет, не каждому, но перед первым спринтом менеджер должен назначить, кто именно
хранит reference-only материалы.

Для обычной разработки проекта достаточно репозитория и Godot. Локальные Wargus
source checkout, купленная игра и extracted assets нужны только участникам,
которые занимаются:

- анализом оригинальных mechanics/metadata;
- подготовкой reference boards для дизайнера;
- импортом карт/звуков/animation reports;
- проверкой соответствия Warcraft II по исходным материалам.

Проект не должен требовать локальную Warcraft II installation для запуска,
тестов обычных модулей или работы UI/Warcraft Runtime.

## Где брать reference-файлы

| Источник | Ссылка | Что делать |
| --- | --- | --- |
| Wargus source | [Wargus/wargus](https://github.com/Wargus/wargus) | Склонировать или скачать архив исходников. Использовать Lua scripts, maps, campaigns, docs и source code как основной технический reference. |
| Установочные файлы Warcraft II | [Warcraft II / Облако Mail](https://cloud.mail.ru/public/U1db/ujYBepiMq) | Открыть вручную в браузере, скачать установочные файлы в локальную неотслеживаемую папку и установить/распаковать игру для reference checks. |

Ссылка на Mail Cloud может требовать JavaScript или авторизацию. Если участник
не может открыть ее, он просит менеджера или владельца reference pipeline выдать
доступ либо подготовить Markdown reports без оригинальных файлов игры.

## Что сделать перед первой задачей

1. Склонировать Wargus в локальную папку вне tracked content:

   ```powershell
   git clone https://github.com/Wargus/wargus.git <local Wargus checkout>
   ```

2. Скачать установочные файлы Warcraft II из командной папки Mail Cloud в
   локальную неотслеживаемую папку, например `external/installers/`.
3. Установить игру или распаковать reference files локально. Не добавлять
   установочные файлы, распакованные assets и extracted media в Git.
4. Записать абсолютные пути в приватный
   `warcraft-ii/docs/local_reference_paths.local.md` или в локальные переменные
   окружения. Не добавлять эти пути в публичные Markdown-файлы.
5. Проверить, что Godot-проект запускается без `external/`, Wargus checkout и
   установленной Warcraft II. Reference-файлы не являются runtime-зависимостью.
6. Для командной работы передавать не оригинальные файлы, а reports: source id,
   размеры, frame counts, states, flags, script names, map ids и известные
   отличия.

## Кому что скачать

| Роль | Что нужно локально | Зачем |
| --- | --- | --- |
| Дизайнер | Reference docs и extracted reference pack в `external/`; при необходимости доступ к установленной Warcraft II для скриншотов. | Собирать boards, crops, размеры, states, mood/style references и handoff без коммита оригинальных файлов. |
| P1 Runtime | Wargus source checkout; локальная Warcraft II нужна только для ручной проверки спорного поведения. | Переносить правила, orders, economy, combat, fog, AI и сверять mechanics matrix. |
| P2 Presentation/Input | Wargus source/extracted visual references по задачам недели; локальная игра полезна для проверки камеры, выбора и темпа. | Подключать визуальные состояния от snapshot и сверять feedback. |
| P3 UI/Scenario/Campaign | UI/campaign references, briefing screenshots, Wargus scripts. | Делать HUD, command panel, objectives, briefing и result screens по источникам. |
| P4 Content/Tools/Services | Wargus source, extracted reports и доступ к локальной игре. | Готовить import/reference reports, catalogs, validation и content checks. |
| Q Tester | Godot-проект всегда; Wargus/Warcraft II только для reference parity задач. | Smoke/regression не должны зависеть от proprietary files; reference checks могут зависеть. |
| M Manager | Не обязан скачивать Wargus или игру. | Принимает демо по sprint report, видео, build notes и QA evidence. |

Если у команды есть только одна легальная локальная установка Warcraft II, ее
использует владелец reference pipeline, а остальные получают Markdown reports,
скриншоты/crops без оригинальных ассетов и публичные design briefs.

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

Абсолютные пути конкретного участника не нужно коммитить. Для локального ИИ и
личных скриптов можно создать файл:

```text
warcraft-ii/docs/local_reference_paths.local.md
```

Файл `*.local.md` исключен из Git и может содержать реальные пути конкретной
машины. Публичные документы должны ссылаться на роли, папки и source names, а не
на абсолютные пути автора.

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
