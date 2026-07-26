extends Node2D


@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var experience_vial: Sprite2D = $ExperienceVial
const EXPERIENCE_VIAL_AMOUNT = 1
const MAX_VIAL_SPEED = 40

func tween_collect(percent:float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group('player')
	if player == null:
		return
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	var target_rotation_rad = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation_rad, 1- exp(-get_process_delta_time() * 20))
	#按默认的2D平面，0°蜡烛头向右，180°向左（而不是向上），所以要加90°
	#rotation_degrees = rad_to_deg(direction_from_start.angle())+90
	#lerp 处理单个数和向量时，引用不一样
	

func get_duration():
	var player = get_tree().get_first_node_in_group('player')
	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)	
	var duration = distance / MAX_VIAL_SPEED	
	duration = clamp(duration, 0.05, 1.0)
	return duration


func collect():
	GameEvents.emit_experience_vial_collected(EXPERIENCE_VIAL_AMOUNT)  
	#设定经验为1，要等补间动画结束之后，捡起之后才输出经验
	queue_free()


func _on_area_2d_area_entered(other_area: Area2D) -> void:
	
	var tween = create_tween()
	var duration = get_duration()
	print(duration)
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, duration)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_EXPO)
	#补间动画method默认只传from 0.0 to 1.0 的一个值即 percent:float，想额外加必须bind
	tween.tween_property(experience_vial, "scale", Vector2.ZERO, duration * 0.15).set_delay(duration * 0.85)
	#wait 0.35seconds then do this thing
	tween.chain()
	#parallel chain中间的动画同时进行
	call_deferred("disable_collision")
	tween.tween_callback(collect)
	#tween_callback等补间动画结束后再执行
	#使用了新的函数，如果都写在这里，就要 await tween.finish
	#https://easings.net/  网站上已经展示了各种预设，把set_ease set_trans填满就行


func disable_collision():
	collision_shape_2d.disabled = true
