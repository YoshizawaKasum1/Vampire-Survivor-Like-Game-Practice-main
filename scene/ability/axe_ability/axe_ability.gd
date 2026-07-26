extends Node2D

const MAX_RADIUS = 100
@onready var hitbox_component = $HitBoxComponent

func _ready() -> void:
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 2)
	#两秒内从0到2转两圈
	tween.tween_callback(queue_free)
	#tween_callback 意思是执行完上一个方法后再执行当前这个，跟下面写法效果一样
	#await get_tree().create_timer(2).timeout
	#queue_free()
	
func tween_method(rotations : float):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	#随着旋转，半径扩大
	var current_direction = Vector2.RIGHT.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	global_position = player.global_position + (current_direction * current_radius)
	
