extends CanvasLayer

@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var panel_container = %PanelContainer

func _ready() -> void:
	panel_container.pivot_offset = panel_container.size/ 2
	#set the pivot position to the center of the container
	var tween = create_tween()
	tween.tween_property(panel_container, 'scale', Vector2.ZERO, 0)	
	tween.tween_property(panel_container, 'scale', Vector2.ONE, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	get_tree().paused = true
	

func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lost"


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/main/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
