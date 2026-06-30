# ui/animation

Папка для общих UI motion tokens и helper-скриптов.

Локальная анимация компонента должна жить рядом с компонентом. Например hover и
press для `command_button` находятся в `ui/hud/command_panel/command_button.tscn`.
В эту папку выносится только то, что переиспользуется несколькими компонентами:

- длительности и easing;
- правила reduced motion;
- общие helpers для запуска UI-анимаций;
- тестовые motion presets.

UI-анимация не должна менять Warcraft Runtime, создавать `WarcraftCommand` или хранить
авторитетное состояние матча.

