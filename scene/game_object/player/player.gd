extends CharacterBody2D
#$ProgressBar，修改custom minimum size 然后点击transform--size，可以修改血条的大小
#$ProgressBar, control--pivot offset可以修改原点的位置至进度条的中心，方便对其

const MAX_SPEED : int = 125
const ACCELERATION_SMOOTHING = 25
@onready var health_component = $HealthComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animationplayer = $AnimationPlayer
@export var hitted_damage : int
var number_colliding_bodies = 0

func _ready() -> void:
	health_component.health_change.connect(on_health_change)
	update_health_display()
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _physics_process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animationplayer.play("walk")
	else:
		animationplayer.play('RESET')
	
	var move_sign = sign(movement_vector.x)
	if move_sign == 0:
		return
	else:
		$Visuals.scale = Vector2(move_sign,1) 
	#角色面部朝向
	
func get_movement_vector():
	var x_movement = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x_movement, y_movement)

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(hitted_damage * number_colliding_bodies)
	#print(health_component.current_health)
	damage_interval_timer.start()
	#当敌人进入后，触发无敌时间，在无敌时间内，无法触发伤害检测
	on_health_change()

func update_health_display():
	health_bar.value = health_component.get_health_perccent()
	health_bar.show()
	await get_tree().create_timer(1.0).timeout
	health_bar.hide()

func _on_collision_area_body_entered(body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()

func _on_collision_area_body_exited(body: Node2D) -> void:
	number_colliding_bodies -= 1
	
func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()
	#当怪物在玩家身边超过无敌时间后，继续执行伤害检测
	on_health_change()

func on_health_change():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if not ability_upgrade is Ability:
		return
	var ability = ability_upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())
