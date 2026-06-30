# Animation asset spec template

Использовать для каждого нового юнита, здания, снаряда или эффекта.

## Asset

| Поле | Значение |
| --- | --- |
| Asset id |  |
| Gameplay id, если есть |  |
| Visual id |  |
| Тип | unit / building / projectile / effect |
| Faction/tileset |  |
| Reference board |  |
| Новый runtime файл |  |

## Spritesheet

| Поле | Значение |
| --- | --- |
| Frame size |  |
| Sheet size |  |
| Grid |  |
| Transparent background | yes / no |
| Pivot | bottom-center / custom |
| Direction policy | none / 5_direction_mirrored / 8_direction / custom |
| Player color mask | no / separate PNG / palette zone |
| Shadow | baked / separate / none |

## States

| State | Loop | Frames | Duration/ticks | Markers | Notes |
| --- | --- | --- | --- | --- | --- |
| idle | yes |  |  |  |  |
| move | yes |  |  |  |  |
| attack | no |  |  | hit, sound, projectile |  |
| death | no |  |  | corpse/end |  |
| work/harvest/repair | yes/no |  |  | work, sound |  |
| cast/spell | no |  |  | sound, projectile, effect |  |

## Event markers

| Marker | State | Frame | Meaning |
| --- | --- | --- | --- |
| hit | attack |  | Visual sync only; Simulation owns damage. |
| sound |  |  | Audio group/id. |
| projectile |  |  | Spawn projectile/effect presentation. |
| work |  |  | Harvest/repair visual sync. |
| end |  |  | One-shot visual finished. |

## Designer checklist

- [ ] Sheet size divides cleanly by frame size.
- [ ] Pivot is stable in every frame.
- [ ] Mandatory states are present or fallback is named.
- [ ] Attack/cast/work states have event markers.
- [ ] Preview shows idle, move, attack/work and death.
- [ ] Asset is new legal art, not copied original Warcraft II/Wargus material.
- [ ] Readability checked at gameplay zoom.
- [ ] Performance budget accepted.

## Integration checklist

- [ ] Texture imported into `content/assets/textures/*`.
- [ ] Animation data added to `content/assets/animations/*_sprite_bank.tres`.
- [ ] Visual catalog references visual id.
- [ ] Presentation view plays states through data-driven animation system.
- [ ] No Simulation logic added to View.
- [ ] Manual demo/test map check completed.
