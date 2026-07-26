extends Node2D

@export var health_component : Node
@export var sprite : Sprite2D

func _ready() -> void:
	$GPUParticles2D.texture = sprite.texture
	health_component.die.connect(on_die)
	

func on_die():
	#用粒子系统做死亡动画可以更加随机
	#敌人敌后继续播放死亡动画，会导致攻击依旧锁定已死亡敌人
	#需要想将敌人删除后，再添加上去播放动画
	if owner == null || not owner is Node2D:
		return
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group('entities_layer')
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	$AnimationPlayer.play("default")
	
