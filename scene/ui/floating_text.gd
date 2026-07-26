extends Node2D



func start(text :String):
	$Label.text = text
	global_position = global_position + Vector2(randf_range(-10,10),0)
	text_animation()
	
func text_animation():
	var tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain()
	tween.tween_callback(queue_free)	
	
	var scale_tween = create_tween()
	#因为scale_tween和tween是建立的两个不见动画，所以这两个可以同时运行
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)		
