class_name ElementData extends Resource

@export var id: Elements  # "fire", "steam", "lava"
@export var display_name: String
@export var color: Color
@export var aura_effect: AuraEffect  # another resource
@export var is_combined: bool
@export var recipe: Array[StringName]  # ["fire", "water"] for steam

enum Elements {
	FIRE,
	WATER,
	WIND,
	EARTH
}
