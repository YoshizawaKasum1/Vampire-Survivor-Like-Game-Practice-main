extends Camera2D

var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()   #选用开启当前摄像机，摄像机不要放在玩家场景下面



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acquire_target()
	global_position = global_position.lerp(target_position,1.0 - exp(-delta * 20))  
	#lerp stands for linear interpolation
	#global_position = target_position  #采用position smoothing也可以wdddd


func acquire_target():
	#group返回array,检测必须有玩家才会返回位置
	var player_nodes = get_tree().get_nodes_in_group('player')  
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position

	
