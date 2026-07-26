extends Node
signal arena_difficulty_increased(arena_difficulty : int)
const DIFFICULTY_INTERVAL = 10
@export var end_screen_scene : PackedScene
#@onready 可以在运行后自动赋值，下面引用不需要写$符号
@onready var timer = $Timer

var arena_difficulty = 0
var previous_time = 0

func _ready() -> void:
	previous_time = timer.wait_time


func _process(delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
	#每5秒难度等级提升1，next_time_target就是 70/65/60/55这种时间节点，如果当前剩余时间小于等于next_time_target
	#就提升难度等级
	

func get_time_elapse():
	return timer.wait_time - timer.time_left


func _on_timer_timeout() -> void:
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
