extends Node

func _on_play_button_pressed() -> void:
	print("Button is clicked!")
	get_tree().change_scene_to_file("res://scenes/game_level.tscn")
