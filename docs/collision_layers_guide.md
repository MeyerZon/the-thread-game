# Collision Layers & Masks — Top-Down 2D Guide

Godot gives every `CollisionObject2D` two 32-bit bitmasks:

- **Layer** — what this object *is*.
- **Mask** — what this object *scans for*.

A detects B when **A.mask ∩ B.layer ≠ 0**. Set layer names in *Project Settings → Layer Names → 2D Physics* for readable checkboxes.

---

## Typical Layers for a Top-Down 2D Game

| # | Name            | What lives here                                               |
|---|-----------------|---------------------------------------------------------------|
| 1 | World           | Walls, solid terrain, static map colliders                    |
| 2 | PlayerMovement  | The player's body (movement collider)                         |
| 3 | EnemyMovement   | Enemy bodies (movement colliders)                             |
| 4 | PlayerHitbox    | Areas emitted by the player's attacks/projectiles             |
| 5 | EnemyHitbox     | Areas emitted by enemy attacks/projectiles                    |
| 6 | PlayerHurtbox   | The player's "take damage here" Area2D                        |
| 7 | EnemyHurtbox    | Enemies' "take damage here" Area2D                            |
| 8 | Pickups         | Coins, potions, resources, interactables                      |
| 9 | NPC             | Friendly NPCs, vendors, dialog triggers                       |
| 10| Triggers        | Room transitions, cutscene zones, invisible event areas       |
| 11| Projectile      | Generic bullets if you don't want to split by owner           |
| 12| Decoration      | Pushable/breakable props, bushes, pots                        |

Separating **body** (layer 2/3) from **hurtbox** (layer 6/7) lets attacks hit the hurtbox while movement still uses the body — standard for action games where hitboxes extend past the sprite.

---

## Typical Mask Setups

**Player body** — `layer: PlayerMovement` · `mask: World + EnemyMovement + NPC + Decoration + Pickups + Triggers`

**Enemy body** — `layer: EnemyMovement` · `mask: World + PlayerMovement + EnemyMovement + Decoration`
*(include EnemyMovement in the mask if you want enemies to push each other; omit for overlap)*

**Walls / World** — `layer: World` · `mask: 0`
*(static geometry doesn't need to scan; others scan it)*

**Player hitbox (Area2D on sword swing / projectile)** — `layer: PlayerHitbox` · `mask: EnemyHurtbox + World`
*(World so projectiles despawn on walls)*

**Enemy hitbox** — `layer: EnemyHitbox` · `mask: PlayerHurtbox + World`

**Player hurtbox** — `layer: PlayerHurtbox` · `mask: 0`
*(hurtboxes are passive targets — hitboxes scan them)*

**Enemy hurtbox** — `layer: EnemyHurtbox` · `mask: 0`

**Pickup (Area2D)** — `layer: Pickups` · `mask: PlayerMovement`
*(only needs to notice the player walking over it)*

**Trigger zone** — `layer: Triggers` · `mask: PlayerMovement`

**NPC** — `layer: NPC` · `mask: World + PlayerMovement`

---

## Rules of Thumb

- **Static = empty mask.** Walls, pickups, hurtboxes rarely need to scan — flip the relationship to the moving/active side.
- **Hitbox ↔ Hurtbox, never body ↔ body** for damage. Keeps "can I walk through you" separate from "can I hit you."
- **One side scans, one side is scanned.** Don't set both sides to scan each other — duplicates signals and wastes CPU.
- **RayCast2D has only a mask.** It's a scanner, no layer.
- **TileMap physics layers** are configured per-layer in the TileSet; give terrain its own layer (World) and set the player's mask accordingly.
- **Friendly fire / team filtering** is cleaner via layers (PlayerHitbox vs EnemyHitbox) than runtime checks.

---

## Code Reference

```gdscript
# 1-based, matches the inspector checkboxes
set_collision_layer_value(2, true)    # I am on "PlayerMovement"
set_collision_mask_value(1, true)     # I scan "World"
set_collision_mask_value(3, true)     # I scan "EnemyMovement"

# Raw bitmask if you prefer
collision_layer = 0b00000010
collision_mask  = 0b00000101
```
