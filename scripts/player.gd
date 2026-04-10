extends CharacterBody2D


#Top Down controls, no need in falling here
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var joystick_movement : VirtualJoystick
@export var SPEED : float

func _ready() -> void:
	print("SCRIPT RUNNING")


func _get_direction_anim(dir: Vector2) -> String:
	var x : float = sign(dir.x)
	var y : float = sign(dir.y)

	var anims := {
		Vector2(1, 0): "move_d",
		Vector2(-1, 0): "move_a",
		Vector2(0, 1): "move_s",
		Vector2(0, -1): "move_w",
		Vector2(1, 1): "move_sd",
		Vector2(-1, 1): "move_sa",
		Vector2(1, -1): "move_wd",
		Vector2(-1, -1): "move_wa",
	}

	return anims.get(Vector2(x, y), "idle")


func _physics_process(delta: float) -> void:

	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		var anim := _get_direction_anim(direction)
		animation_player.play(anim)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		if (velocity == Vector2.ZERO):
			animation_player.play("idle")
	
	move_and_slide()
