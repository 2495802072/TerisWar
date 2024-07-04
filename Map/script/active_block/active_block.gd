## 单个活动方块
extends RigidBody2D

var active_blocks:ActiveBlocks
@onready var sprite2d = $Sprite2D

# 替换方块类型(贴图)
func set_block_type(num = 0):
	sprite2d.frame = wrapi(num, 0, sprite2d.hframes * sprite2d.vframes)

# 设置方块组
func set_active_blocks(new_active_blocks: ActiveBlocks):
	active_blocks = new_active_blocks

# 设置矢量速度
func set_velocity(new_velocity: Vector2):
	# 优先向方块组传递速度
	if active_blocks != null:
		if active_blocks.has_method("set_velocity"):
			active_blocks.set_velocity(new_velocity)
		return
	set_axis_velocity(new_velocity)
