# Contributing to the-thread-game

Thanks for taking the time to contribute! This document covers the
practical bits of working on a Godot project in this repository —
engine version, coding style, how scenes are structured, and what to
watch out for when committing.

## Getting set up

1. **Install Godot 4.6** (the version this project targets — see the
   `config/features` line in `project.godot`). Newer patch releases of
   4.6.x are fine; older or newer minor versions are not supported.
   Use the standard (GDScript) build, not Mono/.NET.
2. **Clone and open** the project:
   ```
   git clone <your fork url>
   cd the-thread-game
   ```
   Then, in the Godot project manager, pick **Import** and select
   `project.godot` from the cloned directory.
3. **First import** will generate a local `.godot/` cache — this is
   gitignored and should never be committed.

If you intend to build the web export yourself, also install the
matching **export templates** from Godot (Editor → Manage Export
Templates). You do not need them just to run the project in the editor.

## Running the game

- Press **F5** in the editor to run the main scene (`scenes/main.tscn`).
- Press **F6** to run the currently-open scene in isolation — useful
  when iterating on a component or a single level.

## Project layout

```
addons/        Third-party plugins (e.g. virtual_joystick).
assets/        Art, audio, and other imported media.
docs/          Internal design notes and guides.
materials/     Shared Material resources.
resources/     Shared .tres data resources.
scenes/        .tscn scenes.
  components/  Reusable node-based components (health, decay timer, …).
  ui/          UI scenes.
scripts/       GDScript files.
  components/  Scripts attached to component scenes.
  resources/   Custom Resource classes.
build/         Exported builds (web export lands in build/web/).
```

Keep scripts next to their conceptual twin scenes where it makes
sense (e.g. `scripts/components/health_component.gd` goes with
`scenes/components/health_component.tscn`).

## Branching and pull requests

- Branch off `master`. Name branches descriptively:
  `feature/decay-timer-pause`, `fix/player-collision`, etc.
- Keep PRs focused. Unrelated cleanup belongs in its own PR.
- Before opening a PR:
  - Run the game and exercise the code path you changed.
  - Make sure the editor shows no new errors or warnings in the
    **Debugger → Errors** panel when running the affected scene.
  - Re-save any scene you touched via the editor so Godot rewrites it
    cleanly — hand-edited `.tscn` files can trigger spurious diffs.
- PR description should explain the **why**, list the scenes/scripts
  touched, and include a short test plan (what you did to verify it).

## Commit conventions

- Imperative, present-tense subject under 72 characters
  (e.g. `Add HealthComponent damage flash`, not `Added…` /
  `Adds…`).
- Group related file changes in a single commit. In particular, a
  `.gd` script and the `.tscn` that instances it usually belong
  together.
- Always include the matching `.uid` / `.import` file alongside the
  asset or script it belongs to (see "Working with Godot files"
  below).
- Don't commit contents of `.godot/`, `build/*` that you didn't
  deliberately export, crash dumps, or editor layout files from other
  projects.

## Coding style (GDScript)

Baseline: the **[official GDScript style guide]**
(https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
If something isn't mentioned below, defer to that document.

The project also runs with `gdscript/warnings/untyped_declaration=2`,
which means **untyped declarations are treated as errors**. Concretely:

- **Type everything.** Every variable, parameter, and return value must
  have an explicit type. No `var foo = …` without a type hint, no
  untyped function parameters, no functions without a return type
  (use `-> void` when nothing is returned).
  ```gd
  var speed: float = 120.0
  func apply_damage(amount: int) -> void:
      ...
  ```
- Use `snake_case` for variables, functions, files, and node names;
  `PascalCase` for classes and custom resources; `SCREAMING_SNAKE_CASE`
  for constants.
- Prefer `class_name` on reusable components so they're available
  globally and show up in the editor's "Create node" dialog.
- Use `@onready` for node references obtained at scene entry:
  ```gd
  @onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
  ```
- Use `@export` for values that designers/level authors should be
  able to tweak in the Inspector; do not hard-code tuning values
  that you'll want to change later.
- Signals are declared at the top of the file, named in the past
  tense (`died`, `health_changed`), and typed where possible.
- Tabs for indentation (this is Godot's default — don't switch to
  spaces).
- No trailing whitespace; leave a single trailing newline at EOF.

## Architecture rules

These are project-wide rules. New code that violates them will be
asked to change in review.

### Call down, signal up

Parent nodes may **call methods on their children**. Children must
**never reach up** to talk to their parent or siblings — they
**emit signals** and let whoever cares subscribe.

- **Forbidden:** `get_parent()`, `get_parent().some_method()`,
  `owner.something`, walking up the tree with `..` in a `$NodePath`,
  or any other upward traversal from a child.
- **Forbidden:** reaching sideways into sibling nodes from a child
  (`get_parent().get_node("Sibling")`). If two components need to
  cooperate, the **parent wires them together** — typically by
  listening to a signal from one and calling a method on the other.
- **Required:** components expose their behavior as methods (for the
  parent to call downward) and as signals (for the parent to
  subscribe to upward). That's the entire public API.

If you find yourself wanting `get_parent()`, the answer is almost
always: add a signal, and let the parent hook it up.

### Composition over OOP

Prefer **small, single-purpose node components** over deep class
hierarchies. A "thing with health that can decay" is a parent node
with a `HealthComponent` and a `DecayTimerComponent` attached as
children — not a `DecayingHealthyEntity` subclass.

- Keep components **self-contained**: they should make sense on their
  own, configured through `@export` values, with no assumptions about
  what their parent is.
- Avoid inheritance chains more than one level deep unless there's a
  real reason. "I need three of these with slightly different
  behavior" is usually a composition problem, not a subclassing one.
- Reusable behavior lives in `scenes/components/` +
  `scripts/components/`. If you're writing a new behavior that could
  plausibly be attached to more than one kind of entity, make it a
  component.

### Use Resources for data

Tuning values, stat blocks, ability definitions, spawn tables, etc.
belong in **custom `Resource` classes** (`.tres` files), not in
script-level constants.

- Define a `class_name`-ed `Resource` subclass in `scripts/resources/`
  with typed `@export` fields.
- Create `.tres` instances under `resources/` and `@export` a slot on
  the consuming node so designers can swap the resource without
  editing code.
- This keeps designer-facing tuning out of scripts, makes variants
  cheap (duplicate the `.tres`, tweak, plug in), and lets the same
  data be shared by multiple scenes.

## Working with Godot files

Godot stores metadata in sidecar files. **Always commit them
together with the asset they describe**, or the editor will desync:

- `foo.png` ↔ `foo.png.import`
- `foo.gd` ↔ `foo.gd.uid`
- `foo.tscn` / `foo.tres` have stable UIDs in their headers — do not
  edit those by hand.

Other notes:

- **Don't hand-edit `.tscn` / `.tres` files** unless you know exactly
  what you're doing. Prefer opening the scene, making the change in
  the editor, and letting Godot re-serialize it.
- **Do commit** `project.godot`, `export_presets.cfg`, and any `.uid`
  files. These are source-of-truth.
- **Don't commit** `.godot/`, `*.translation` (generated),
  `export_credentials.cfg`, or any `.tmp` scene files Godot leaves
  behind after a crash (you'll occasionally see files like
  `scenes/game_level.tscn<digits>.tmp` — delete those; they're not
  meant to be tracked).
- **Resource UIDs** (the `uid://...` strings) are the durable way to
  reference a file. If you need to rename a resource, do it through
  the editor's FileSystem dock so Godot updates every reference.
- **Merging scene files** is painful. Coordinate with other
  contributors before making large structural changes to shared
  scenes (e.g. `game_level.tscn`, `main.tscn`). If a conflict is
  hopeless, it's usually faster to redo the change on top of the
  updated scene than to resolve the conflict by hand.

## Exporting / CI

- The `Web` export preset in `export_presets.cfg` outputs to
  `build/index.html`; the deploy workflow (`.github/workflows/deploy-pages.yml`)
  picks up anything in `build/web/` and publishes it to GitHub Pages
  on pushes to `master` that touch that directory.
- If you change the export preset or the workflow, verify the deploy
  succeeds on your fork's Pages before merging.

## Reporting issues

Open a GitHub issue with:

- Godot version (`Help → About` in the editor).
- OS and, for rendering bugs, GPU / driver.
- Exact scene or script you were running.
- Minimal steps to reproduce, and what you expected vs. what
  happened.
- Console / debugger output if there were errors.

## License

By submitting a contribution you agree that it will be released under
the same license as the project (see `LICENSE`).
