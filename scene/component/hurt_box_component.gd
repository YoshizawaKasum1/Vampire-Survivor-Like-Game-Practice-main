extends Area2D
class_name HurtBoxComponent

@export var health_component : Node
@export var floating_text_scene : PackedScene

func _on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitBoxComponent:
		return
	if health_component == null:
		return
	var hitbox_component = other_area as HitBoxComponent		
	health_component.damage(hitbox_component.damage)
	var floating_text_instance = floating_text_scene.instantiate()
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer')
	if foreground_layer == null:
		return
	foreground_layer.add_child(floating_text_instance)
	floating_text_instance.global_position = global_position + Vector2.UP * 16
	
	var format_value = "%0.1f"
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_value = "%0.0f"
	floating_text_instance.start(format_value % hitbox_component.damage)
