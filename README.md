# the-thread-game

An open-source 2D game built in **Godot 4.6**, developed live in a
**SpaceBattles forum thread**. The thread is the roadmap: readers
suggest and vote on what gets added next, and I build it.

Right now the project is still a blank canvas — a top-down player
and a handful of reusable components (health, decay timer, virtual
joystick, etc.) sitting on top of a Godot Web build pipeline. What
it *becomes* depends on the thread.

**▶ Video Demonstration**


https://github.com/user-attachments/assets/915d6b73-74b2-46b1-be15-53635335be2b





**▶ Play in your browser:** https://meyerzon.github.io/the-thread-game/

## The thread

_TODO: link to the SpaceBattles thread once it's live._

If you want to influence the direction of the game, the thread is
the place. Suggestions, votes, jokes, and unhinged feature requests
all welcome there.

## Play

The latest build of `master` is automatically deployed to GitHub
Pages:

**https://meyerzon.github.io/the-thread-game/**

Any modern desktop browser works; mobile is supported via the
on-screen virtual joystick.

## Current state

- Top-down player character (slime — modelled in Blender and
  rendered to pixel art; see [`CREDITS.md`](CREDITS.md) for the
  pipeline).
- Reusable node components: `HealthComponent`, `DecayTimerComponent`,
  element / aura resources.
- 8-way movement, WASD + virtual joystick for mobile.
- Main menu with a working **Play** button and a second button
  whose behaviour is best discovered in person.
- Gradient background in the level scene (temporary, while the
  game doesn't know what it wants to look like yet).

No real gameplay loop yet — that's what the thread is for.

## Running from source

1. Install **Godot 4.6** (standard GDScript build, not Mono).
2. Clone this repo and import `project.godot` via Godot's project
   manager.
3. Press **F5** to run the main scene.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for a more detailed
setup walk-through, coding conventions, and the rules around
third-party assets and AI-assisted contributions.

## Tech

- **Engine:** Godot 4.6, GDScript, `gl_compatibility` renderer (so
  the web build actually runs).
- **Architecture:** small, composable components with
  *call-down / signal-up* wiring; tunable data lives in
  custom `Resource` `.tres` files rather than in scripts.
- **Platforms:** Desktop + Web (via the built-in Godot Web export;
  the `Web` preset lives in `export_presets.cfg`).

## Project layout

```
addons/        Third-party plugins (e.g. Virtual Joystick).
assets/        Art, audio, and other imported media.
blender/       3D sources for characters rendered to pixel art.
docs/          Internal design / tooling notes.
materials/     Shared materials and shaders.
resources/     .tres data resources (tuning, stats, etc.).
scenes/        .tscn scenes (components/, ui/, levels, player).
scripts/       GDScript (components/, resources/, entry points).
build/         Exported builds (web export lands in build/web/).
.github/       GitHub Actions workflows and PR template.
```

## Deployment

Pushes to `master` that touch `build/web/**` trigger
`.github/workflows/deploy-pages.yml`, which uploads the Godot Web
export to GitHub Pages. You can also run the workflow manually from
the Actions tab.

## Contributing

The primary design input channel is the SpaceBattles thread —
that's where direction is decided. For code, issues and pull
requests are welcome on top of whatever the thread has asked for
most recently.

Before opening a PR, please read [`CONTRIBUTING.md`](CONTRIBUTING.md)
— in particular the sections on GDScript style (type everything,
official style guide), the call-down / signal-up architecture
rule, prefer-composition, using `Resource`s for tunable data, what
can and can't be AI-generated, and how to attribute any third-party
asset you add.

## Credits

Third-party plugins and assets, plus original-art pipeline notes,
are listed in [`CREDITS.md`](CREDITS.md).

## License

See [`LICENSE`](LICENSE).
