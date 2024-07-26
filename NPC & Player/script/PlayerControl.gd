##玩家控制 
## 目前完成：左右移动，跳跃，空中快速下落
extends CharacterBody2D

@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D

enum STATE_DB {
	default,
	idle,
	walk,
	falling,
	fast_falling
}
@export var state:STATE_DB = STATE_DB.idle
var speed:int = 300

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # 重力
@export var gravity_open:bool = true

func _physics_process(delta):
	if state!=STATE_DB.idle:
		if is_on_floor():
			change_state_to("idle")
	
	#存在重力
	if gravity_open:
		#空中
		if not is_on_floor():
			# 按下s
			if Input.is_action_just_pressed("falling_down"):
				animated_sprite_2d.set_animation("Down")
				change_state_to("fast_falling")
				auto_map_position()
				velocity.y += 2200
			# 自然下落
			else:
				velocity.y += gravity * delta
		
		#地面
		if Input.is_action_just_pressed("jump") and is_on_floor():
			animated_sprite_2d.set_animation("default")
			change_state_to("falling")
			velocity.y = -500
	
	if state!=STATE_DB.fast_falling:
		var direction = Input.get_axis("move_left", "move_right")
		if direction and state!=STATE_DB.fast_falling:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func auto_map_position() -> void: ## 自动对齐砖块坐标
	var pos_in_map = G._get_game_root().map_root.get_tilemap().local_to_map(position)
	position.x = G._get_game_root().map_root.get_tilemap().map_to_local(pos_in_map).x
	pass

func change_state_to(stateName:String):
	state = STATE_DB[stateName]
	pass
