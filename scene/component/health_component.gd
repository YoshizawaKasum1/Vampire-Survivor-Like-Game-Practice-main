extends Node
class_name HealthComponent
#组件最好加上 class name
@export var max_health : float
#模块化直接使用，生命值不要在这里赋值，在不同场景的右侧检查器修改
var current_health
signal die
signal health_change

func _ready() -> void:
	current_health = max_health


func damage(damage_amount : float):
	current_health = max(current_health - damage_amount, 0)
	#返回最大值，当生命值小于0，返回0
	health_change.emit()
	call_deferred('check_death')

func get_health_perccent():
	if current_health <= 0:
		return 0
	else:
		return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		die.emit()
		owner.queue_free()
		#当前场景没有owner,绑在basic_enemy后，basic_enemy是owner
		#当owner的hp为0后，释放死亡信号，并且删除
