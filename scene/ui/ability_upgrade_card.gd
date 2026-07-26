extends PanelContainer
signal selected

@onready var name_label : Label = %NameLabel
@onready var description_label : Label = %DescriptionLabel

var select_disable = false

func set_ability_upgrade(upgrade : AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func play_in(delay : float = 0):
	modulate = Color.TRANSPARENT
	#防止两张牌同时出现播放动画，设定延迟时间，设定颜色为透明，延迟时间结束后颜色设定为白色
	#self_modulate子节点不受影响，所以这里用modulate
	await get_tree().create_timer(delay).timeout
	#modulate = Color.WHITE 这行写进animationplayer里面，变色和播放动画要在同一帧进行
	#通过修改HBoxContainer 或VBoxContainer 的theme overrides/constants/separation调整间隔
	$AnimationPlayer.play("in")


func select_card():
	select_disable = true
	$AnimationPlayer.play('selected')
	for other_card in get_tree().get_nodes_in_group('upgrade_card'):
		if other_card == self:
			#self 就是鼠标点击的card
			continue
		other_card.play_discard()
	await $AnimationPlayer.animation_finished
	#删掉的话，这段动画会被打断
	selected.emit()


func _on_gui_input(event: InputEvent) -> void:
	if select_disable == true:
		return
	#防止玩家反复点击鼠标，导致重复播放动画
	
	if event.is_action_pressed('left_click'):
		select_card()


func play_discard():
	$AnimationPlayer.play('discard')


func _on_mouse_entered() -> void:
	if select_disable == true:
		return
	$HoverAnimationPlayer.play("hover")
	

func _on_mouse_exited() -> void:
	$HoverAnimationPlayer.play("RESET")
