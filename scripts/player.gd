extends CharacterBody2D

#NOTE! Applying the texture will be done from the outside.

#Top Down controls, no need in falling here
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 20000.0


func _physics_process(delta: float) -> void:




	var directionX := Input.get_axis("ui_left", "ui_right")
	if directionX:
		velocity.x = directionX * SPEED * delta
		animation_player.play('move_a')

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionY:
		velocity.y = directionY * SPEED * delta
		animation_player.play('move_w')
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		

	move_and_slide()
