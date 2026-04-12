class_name DecayTimer extends AnimatedSprite2D
signal element_decayed() 
signal decay_timer_paused()
signal decay_timer_resumed()

var was_paused_flag: bool = false

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	decay_timer_paused.connect(_on_decay_timer_paused)
	decay_timer_resumed.connect(_on_decay_timer_resumed)
	pass

func start_timer(decay_seconds: int) -> void:
	var frames_amount := sprite_frames.get_frame_count("decay_timer_animation")
	var custom_speed_scale:float = float(frames_amount) / decay_seconds	
	set_frame_and_progress(0, 0)
	play('decay_timer_animation', custom_speed_scale)
	modulate = Color(1,1,1,1)
	pass

func pause_decay_timer() -> void:
	if is_playing():
		pause()
		decay_timer_paused.emit()
	pass
	
func resume_decay_timer() -> void:
	if(!is_playing() && was_paused_flag):
		play('decay_timer_animation')
		decay_timer_resumed.emit()
	pass

func _on_animation_finished() -> void:
	modulate = Color(1,1,1,0.5)
	element_decayed.emit()
	pass

func _on_decay_timer_paused() -> void:
	was_paused_flag = true
	pass
	
func _on_decay_timer_resumed() -> void:
	was_paused_flag = false
	pass
