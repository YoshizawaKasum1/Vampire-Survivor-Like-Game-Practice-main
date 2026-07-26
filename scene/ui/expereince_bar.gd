extends CanvasLayer

@export var experience_manager : Node
@onready var experience_value = $MarginContainer/ProgressBar

func _ready() -> void:
	experience_value.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)

func on_experience_updated(current_experience : float, target_experience : float):
	experience_value.value = current_experience / target_experience  
	#min max如果是0 100，这里要乘以100
	
