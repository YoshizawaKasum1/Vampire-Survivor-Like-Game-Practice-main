extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
#速度模块可以单独设置怪物移动速度以及加速度，加速度可以让怪不会这么快的锁定你


func _physics_process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	var move_sign = sign(velocity.x)
	if move_sign == 0:
		return
	else:
		$Visuals.scale = Vector2(move_sign,1) 
  





	
