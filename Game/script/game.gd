extends Node

@export var map_root:Node2D
@export var player_root:Node2D
var map_scene:PackedScene = preload("res://Map/scene/map.tscn") ## 基础地图
var player_scene:PackedScene = preload("res://NPC & Player/scene/player.tscn") ## 基础地图

func refresh_map(): ## 刷新地图
	for node in map_root.get_children():
		node.free()
	map_root.add_child(map_scene.instantiate())
	pass

func add_player():## 添加玩家
	player_root.add_child(player_scene.instantiate())
	pass
