extends Node2D
var blocks_scene:PackedScene = preload("res://Map/scene/Blocks.tscn") ## 基础图格

func add_next_blocks():
	add_child(blocks_scene.instantiate())
	pass
