extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
#速度模块可以单独设置怪物移动速度以及加速度，加速度可以让怪不会这么快的锁定你
#tips：左键拖动左侧场景树，在这里按住ctrl再释放左键，直接会补全代码
var is_moving = false

func _physics_process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.deccelerate()
	velocity_component.move(self)
	var move_sign = sign(velocity.x)
	if move_sign == 0:
		return
	else:
		$Visuals.scale = Vector2(move_sign,1) 

func set_is_moving(moving : bool):
	is_moving = moving
