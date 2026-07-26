extends Node

@export var health_component : Node
@export var sprite : Sprite2D
@export var hit_flash_material : ShaderMaterial
var hit_flash_tween : Tween


func _ready() -> void:
	health_component.health_change.connect(on_health_change)
	sprite.material = hit_flash_material

func on_health_change():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	#一个怪可能被打中多下，所以在执行不见动画时 不再触发新的补间动画。
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 0.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 1.0, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
