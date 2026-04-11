class_name DecayTimer extends AnimatedSprite2D
signal element_decayed() 

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	pass # Replace with function body.

func start_timer(decay_seconds: int) -> void:
	var frames_amount := sprite_frames.get_frame_count("decay_timer_animation")
	var custom_speed_scale:float = float(frames_amount) / decay_seconds	
	set_frame_and_progress(0, 0)
	play('decay_timer_animation', custom_speed_scale)
	modulate = Color(1,1,1,1)
	pass

func _on_animation_finished() -> void:
	modulate = Color(1,1,1,0.5)
	element_decayed.emit()
	pass
