# imported reference reports

Папка для коммитируемых промежуточных отчетов, созданных из локальных
reference-only источников. Здесь не должно быть оригинальных Warcraft II/Wargus
ассетов.

## Что можно хранить

```text
content/imported/
  maps/
  animation/
  audio/
  visual/
```

Можно коммитить:

- ids;
- frame sizes;
- sheet sizes;
- grid sizes;
- animation state names;
- frame numbers;
- tile flags;
- map dimensions;
- player slots;
- resource counts;
- sound group names;
- unresolved questions.

Нельзя коммитить:

- оригинальные spritesheets;
- extracted tilesets;
- WAV/music/video;
- PUD/SMS/SMP originals;
- GPL source snippets;
- большие фрагменты оригинальных script files.

## Назначение

Эти отчеты помогают переносить логику в `content/schema/*`, `content/catalogs/*`
и `game/simulation/*`, не требуя от каждого участника хранить локальную копию
игры или Wargus extraction.
