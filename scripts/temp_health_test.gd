extends Area2D

func _ready() -> void:
	var health_component := $HealthComponent
	health_component.hp_changed.connect(_on_health_change)
	body_entered.connect(_on_body_entered)
	
	
	
func _on_health_change(new_hp:int, old_hp:int) -> void:
	if(new_hp<old_hp):
		print("Ouch")
		if(new_hp<=0):
			print("I'm ded")
			queue_free()
	pass



func _on_body_entered(body: Node2D) -> void:
	print("Something entered")
	$HealthComponent.reduce_hp(2)
	pass # Replace with function body.
