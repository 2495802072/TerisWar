extends Node2D

func get_tilemap() -> TileMap:
	return get_node_or_null("Map/StaticMap")
