# imported reference reports

Папка для коммитируемых промежуточных reports/черновых данных, созданных из
локальных Warcraft II/Wargus sources. Здесь не должно быть оригинальных финальных
ассетов Warcraft II.

## Что можно хранить

```text
content/imported/
  maps/
  animation/
  audio/
  visual/
  gameplay/
  scripts/
```

Можно коммитить:

- ids, source file paths and line metadata;
- numeric fields: HP, cost, speed, build time, sight, damage;
- button/action ids, hotkeys, command names;
- spell/upgrade ids and summarized parameters;
- map dimensions, tile flags, player slots, resource counts;
- mission trigger/action names and converted declarative drafts;
- sound group names and visual ids;
- unresolved questions and unsupported source calls.

Нельзя коммитить без отдельного права:

- оригинальные spritesheets, tilesets, WAV/music/video;
- PUD/SMS/SMP originals as proprietary game assets;
- большие фрагменты original script files вместо наших converted reports.

## Назначение

Reports помогают переносить логику в `content/schema/*`, `content/catalogs/*` и
`game/warcraft_runtime/*`, не заставляя каждого участника вручную разбирать всю
локальную копию игры.
