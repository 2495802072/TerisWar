## 玩家相机，多人未实现
extends Camera2D

@onready var player:CharacterBody2D = $"../Player" as CharacterBody2D

func _ready():
	position = player.position

func _process(delta):
	position = player.position
