extends Node

@export var damage : int
@export var axe_ability_scene : PackedScene
var increase_damage_percent = 1

func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return	
	var axe_ability_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage = damage * increase_damage_percent

func on_ability_upgrade_added(upgrade,current_upgrades):
	if upgrade.id == 'axe_damage':
		increase_damage_percent = 1 + 0.15 * current_upgrades[upgrade.id]["quantity"]
