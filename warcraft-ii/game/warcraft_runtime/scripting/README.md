# warcraft_runtime/scripting

> ↑ [warcraft_runtime](../README.md) · 🏛 [Архитектура](../../../docs/architecture/architecture.md)

**Ответственность:** adapters for Wargus Lua, SMS campaign scripts, triggers and
mission actions. Этот слой нужен, чтобы не переписывать campaign logic вручную.

## Что сюда добавлять

- Lua loading/conversion adapters.
- Mission script step mapping.
- Trigger condition/action wrappers.
- Safe runtime API exposed to scripts.
- Reference reports for unsupported script calls.

## Инварианты

- Scripts не меняют runtime state в обход approved API.
- Scripting не исполняет per-unit hot loops.
- Unsupported Wargus call фиксируется в reference report/known issues.
