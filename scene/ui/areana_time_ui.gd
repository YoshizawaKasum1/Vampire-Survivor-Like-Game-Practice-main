extends CanvasLayer

@export var areana_time_manager : Node
@onready var label = %Label

func _process(delta: float) -> void:
	if areana_time_manager == null:
		return 
	var time_elapse = areana_time_manager.get_time_elapse()
	label.text = format_second_to_string(time_elapse)


func format_second_to_string(seconds : float):
	var minute = int(floor(seconds / 60))
	var remaining_second = seconds - minute * 60
	return ("%02d" % minute) + ":" + ("%02d" % remaining_second)
	#%d 是“整数占位符”，意思是“这里要放一个整数”。
	#02 的意思是：“这个整数至少要占 2 个字符的位置，如果不够 2 位，就在前面补 0”。
	#% remaining_second：把 remaining_second 这个数字填进那个占位符里。
