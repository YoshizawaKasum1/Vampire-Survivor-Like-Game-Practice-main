extends Node


#可以修改数列的大小，把之前的sword_rate.tres拖入右侧的相互列里面
#可以建立多个数值提升resource，再把ability_upgrade绑上去
#任何带有abilityUpgrade标签的resourc都可以加入到这个数组
@export var experience_manager : Node
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {}
var upgrade_pool : WeightedTable = WeightedTable.new()
var upgrade_axe = preload("res://resource/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resource/upgrades/axe_damage.tres")
var upgrade_sword_damage = preload("res://resource/upgrades/sword_damage.tres")
var upgrade_sword_rate = preload("res://resource/upgrades/sword_rate.tres")

func _ready() -> void:
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	experience_manager.level_up.connect(on_level_up)
	

func update_upgrade_pool(chosen_upgrade : AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)


func pick_upgrades():
	#保证两张卡片不一样
	var chosen_upgrades : Array[AbilityUpgrade]= []
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	return  chosen_upgrades


func on_level_up(current_level : int):
	#生成卡片，释放卡片选择的信号
	var chosen_upgrade = pick_upgrades()
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrade as Array[AbilityUpgrade]) 
	#把升级的选项显示出来，显示的内容就是chosen_upgrade
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func apply_upgrade(upgrade : AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	#如果该字典包含给定的键 key，则返回 true。
	if !has_upgrade:
		current_upgrades[upgrade.id] = {"resource" : upgrade, "quantity" : 1}
		#嵌套式字典，能力叠加算法，默认没有叠加，has_upgrade为false,则在此id上新建字典
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		#如果已有叠加，则读取嵌套字典的能力获取次数，并+1
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)


func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)

	
