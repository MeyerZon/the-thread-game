# Credits

Third-party assets and plugins bundled in this repository. See
`CONTRIBUTING.md` → *Adding assets* for the rules that apply when
adding new entries here.

Each entry should include:

- **Path** in this repo
- **Name / description** of the asset or plugin
- **Author**
- **Source** (URL to the original)
- **License** (with URL if the license requires attribution)
- **Notes** — any permission emails, modifications made, or
  caveats worth recording

---

## Plugins

### Virtual Joystick

- **Path:** `addons/virtual_joystick/`
- **Name:** Virtual Joystick — a simple virtual joystick for
  touchscreens.
- **Author:** Marco Fazio
- **Source:** https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot
- **License:** MIT
- **Notes:** —

---

## Art

### Original assets — pipeline notes

Some character art in this project isn't hand-drawn pixel art — it's
made by modelling and animating a character in 3D (Blender) and then
rendering the animation out as a pixel-art spritesheet. The Blender
source file lives alongside the exported frames so contributors can
reproduce or extend the animation set.

- **Slime character** — modelled/animated in Blender, rendered to
  pixel art.
  - Blender source: `blender/slime.blend`

The `blender/` directory is otherwise git-ignored (it's a working
folder); only source files we want to ship are explicitly whitelisted
in `.gitignore`.

### Third-party art

_No third-party art currently bundled. Add entries here when
importing sprites, textures, tilesets, icons, fonts, etc._

Template:

```
### <asset name>

- **Path:** assets/<path>
- **Author:** <name>
- **Source:** <url>
- **License:** <license name + url>
- **Notes:** <modifications, permission record, etc.>
```

---

## Audio

_No third-party audio currently bundled. Add entries here for music
and sound effects._

Template:

```
### <track / sfx name>

- **Path:** assets/<path>
- **Author:** <name>
- **Source:** <url>
- **License:** <license name + url>
- **Notes:** <modifications, permission record, etc.>
```

---

## Models / animations

_No third-party 3D assets currently bundled._

Template:

```
### <model name>

- **Path:** assets/<path>
- **Author:** <name>
- **Source:** <url>
- **License:** <license name + url>
- **Notes:** <modifications, permission record, etc.>
```

---

## Fonts

_No third-party fonts currently bundled._

Template:

```
### <font name>

- **Path:** assets/<path>
- **Author / foundry:** <name>
- **Source:** <url>
- **License:** <license name + url, e.g. SIL OFL 1.1>
- **Notes:** <modifications, permission record, etc.>
```
