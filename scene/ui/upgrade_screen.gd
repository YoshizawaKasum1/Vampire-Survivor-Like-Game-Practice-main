extends CanvasLayer
signal upgrade_selected(upgrade : AbilityUpgrade)

@export var ability_upgrade_card_scene: PackedScene
@onready var card_container : HBoxContainer = %CardContainer

func _ready() -> void:
	get_tree().paused = true
	#升级跳出弹窗时，停止所有节点，包括当前节点
	#所以在升级场景右侧检查器设置Node--Process--Mode--Always
	
	

func set_ability_upgrades(upgrades : Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade as AbilityUpgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		#默认设置的信号没有任何的参数，想要在connect后加参数必须加bind
		delay += 0.4
		

func on_upgrade_selected(upgrade : AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play('out')
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
	#选完后删除升级选项
	#大致思路是从几个随机的能力选择打印出来，再将玩家选择的传回去
