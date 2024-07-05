extends Node2D

var active_blocks_array = []

func _input(event):
	if event.is_action_released("jump"):
		var mouse_position = get_local_mouse_position()
		var new_active_blocks = ActiveBlocks.new()
		new_active_blocks.core_block.position = mouse_position
		new_active_blocks.core_block.rotation = randf_range(0,PI)
		add_child(new_active_blocks)
		active_blocks_array.append(new_active_blocks)
	if event.is_action_released("falling_down"):
		active_blocks_array.pick_random().core_block.apply_impulse(Vector2(10,0))

func _on_timer_timeout():
	if active_blocks_array.size() < 1:
		return
	var lucky_active_blocks:ActiveBlocks = active_blocks_array.pick_random()
	lucky_active_blocks.add_block(lucky_active_blocks.core_block, Vector2(0,-1), active_blocks_array.pick_random().core_block)
