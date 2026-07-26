extends Node

@export var end_screen_scene : PackedScene

func _ready() -> void:
	%Player.health_component.die.connect(on_player_die)
	
func on_player_die():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
