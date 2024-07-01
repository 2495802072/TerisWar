##玩家控制 
## 目前完成：左右移动，跳跃，空中快速下落
extends CharacterBody2D

@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D


var speed:int = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # 重力

@export var gravity_open:bool = false

func _physics_process(delta):
	if gravity_open:
		if not is_on_floor():
			if Input.is_action_just_pressed("falling_down"):
				animated_sprite_2d.set_animation("Down")
				velocity.y += 1200
			else:
				velocity.y += gravity * delta
		if Input.is_action_just_pressed("jump") and is_on_floor():
			animated_sprite_2d.set_animation("default")
			velocity.y = -500
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
