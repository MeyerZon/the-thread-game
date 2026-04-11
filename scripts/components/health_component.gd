class_name HealthComponent extends Node

@export var hp:int
@export var max_hp:int
const min_hp := -999 #For overkills
signal hp_changed(new_hp: int, old_hp: int) #Add reason param? (for clamping max hp)
signal max_hp_changed(new_max_hp: int, old_max_hp: int)

#Getters
func get_hp() -> int:
	return hp

func get_max_hp() -> int:
	return max_hp
	
#HP Setters
func reduce_hp(points:int) -> void:
	var old_hp := hp
	var new_hp : int = clampi(hp - points, min_hp, max_hp)
	hp = new_hp
	hp_changed.emit(new_hp, old_hp)
	pass
	
func increase_hp(points:int) -> void:
	var old_hp := hp
	var new_hp : int = clampi(hp + points, min_hp, max_hp)
	hp = new_hp
	hp_changed.emit(new_hp, old_hp)
	pass
	
#Max HP Setters
func reduce_max_hp(points:int) -> void:
	var old_max_hp := max_hp
	var new_max_hp := max_hp-points
	if(hp>max_hp):
		var old_hp := hp
		hp = clampi(hp, min_hp, max_hp)
		hp_changed.emit(hp, old_hp)
	max_hp = new_max_hp
	max_hp_changed.emit(new_max_hp, old_max_hp)
	pass
	
func increase_max_hp(points:int) -> void:
	var old_max_hp := max_hp
	var new_max_hp := max_hp+points
	if(hp>max_hp): #Here needed as well, because increasing can be negative
		var old_hp := hp
		hp = clampi(hp, min_hp, max_hp)
		hp_changed.emit(hp, old_hp)
	max_hp = new_max_hp
	max_hp_changed.emit(new_max_hp, old_max_hp)
	pass
