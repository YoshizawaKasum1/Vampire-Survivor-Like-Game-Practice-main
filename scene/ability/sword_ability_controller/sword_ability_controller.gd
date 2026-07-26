extends Node

const MAX_RANGE = 150
var base_wait_time
@export var base_damage : int
var increase_damage_percent = 1
@export var sword_ability : PackedScene

func _ready() -> void:
	base_wait_time = $Timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	#alt+上下方向键 可以移动整行代码
	#读取组必须判断是否为null
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	var enemies = get_tree().get_nodes_in_group('enemy') 
	#filter函数意思是根据某些要求过滤出需要的内容 
	#检查距离用distance_square_to比distance_to更加节省性能
	enemies = enemies.filter(func(enemy:Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE,2)
	)
	if enemies.size() == 0:
		return
	#sort_custom根据自定义的规则，a比b谁更应该排在前面，a比b小所以排前面
	enemies.sort_custom(func(a : Node2D, b : Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
		)
		
	var sword_instance = sword_ability.instantiate() as SwordAbility
	#近战攻击位置应随着玩家移动而变化，此时get_parent不能加，如吸血鬼幸存者里面圣水效果可以加上这个，位置只更新一次
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer')
	if foreground_layer == null:
		return
	foreground_layer.add_child(sword_instance)
	#player.add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position
	#sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	sword_instance.hitbox_component.damage = base_damage * increase_damage_percent

	#剑的方向指向enemy
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
	sword_instance.global_position += 15 * enemy_direction.normalized()
	#使用38行时需调整玩家材质的offset为(0,0)，注释掉33行

func on_ability_upgrade_added(upgrade,current_upgrades):
	if upgrade.id == 'sword_rate':
		$Timer.wait_time = max(base_wait_time * (1 - 0.1 * current_upgrades[upgrade.id]["quantity"]), 0.1)
		#print('rate: ', $Timer.wait_time)
		$Timer.start()  #重置timer，以最新的值进行运行
	elif upgrade.id == 'sword_damage':
		increase_damage_percent = 1 + 0.15 * current_upgrades[upgrade.id]["quantity"]


	
	
