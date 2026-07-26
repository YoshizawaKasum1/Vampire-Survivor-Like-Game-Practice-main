extends Node

@export_range(0,1) var drop_percent : float = 0.95
@export var health_component : Node
@export var vial_scene : PackedScene

func _ready() -> void:
	(health_component as HealthComponent).die.connect(on_die)
	

func on_die():
	if randf() > drop_percent:
		#掉落率
		return
	if vial_scene == null:
		return
	if not owner is Node2D:
		return
	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	if entities_layer == null:
		return
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
	#使用组，把vial放在和player同一个node下面，方便进行y sort
