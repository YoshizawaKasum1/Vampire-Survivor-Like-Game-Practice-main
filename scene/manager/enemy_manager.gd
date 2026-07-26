extends Node

const SPAWN_RADIUS = 350
@export var basic_enemy_scene : PackedScene
@export var wizard_enemy_scene : PackedScene
@export var arena_time_manager : Node
@onready var timer = %Timer
var base_spawn_time
var enemy_table = WeightedTable.new()

func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
	enemy_table.add_item(wizard_enemy_scene, 1)
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return Vector2.ZERO
		
	#任意方向的单位为1的方向向量.
	var radius_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = Vector2.ZERO
	for i in 4:  #i从0开始 0，1，2，3，不可能到4
		spawn_position = player.global_position + radius_direction * SPAWN_RADIUS
		#apply RayCast to check if there are any collision shape on the line
		#determine a start position and an end position for RayCast
		#if there is a collision shape, change the radius direction by 90 degrees for up to 4 times
		#create(起始点，终点，想要检查的碰撞层 terrain值为1）
		#1<<0就代表mask layer的值，比如mask第20层，值为524288，太长了，写成1 << 19更方便
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position,spawn_position,1 << 0)
		#28行意思就是建立一根检测碰撞的射线
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		#30行意思是把结果放在result里面，intersect_ray返回字典
		if result.is_empty():
			#no collision 
			break
		else:
			radius_direction = radius_direction.rotated(deg_to_rad(90))
	return spawn_position


func _on_timer_timeout() -> void:
	timer.start()
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	if entities_layer == null:
		return
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty : int):
	var time_off = 0.1 * arena_difficulty
	time_off = min(time_off,0.9)
	timer.wait_time = base_spawn_time - time_off
	
	#根据关卡难度，直接修改权重比例即可提高怪刷新概率
	if arena_difficulty == 1:
		enemy_table.add_item(wizard_enemy_scene, 10)
		enemy_table.add_item(basic_enemy_scene, 5)
	
