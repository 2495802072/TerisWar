## 单个活动方块 不应被直接创建 如果需要单个方块 请新建`方块组`
extends RigidBody2D

const BLOCK_SIZE = 48 # 方块大小
var block_linkers := {} # 记录连接器 键为方向(Vector2) 值为连接器实体
var active_blocks:ActiveBlocks # 方块所在的组
@onready var sprite2d = $Sprite2D

# 替换方块类型(贴图)
func set_block_type(num = 0):
	sprite2d.frame = wrapi(num, 0, sprite2d.hframes * sprite2d.vframes)

# 设置方块分组
func set_active_blocks(new_active_blocks: ActiveBlocks):
	active_blocks.set_core_block(new_active_blocks.core_block)

# 设置矢量速度
func set_velocity(new_velocity: Vector2):
	# 优先向方块组传递速度
	if active_blocks != null:
		if active_blocks.has_method("set_velocity"):
			active_blocks.set_velocity(new_velocity)
		return
	set_axis_velocity(new_velocity)

# 链接新方块 传入方向和新方块
func link_new_block(direction:Vector2, new_block):
	freeze = true
	new_block.freeze = true
	# 位置校准
	var target_angle = wrap(global_rotation, -PI/2, PI/2)
	var target_global_position = global_position + (direction.rotated(target_angle).normalized() * BLOCK_SIZE)
	var tween = create_tween()
	tween.tween_property(new_block, "global_rotation", target_angle, 1)
	tween.tween_property(new_block, "global_position", target_global_position, 1)
	await tween.finished
	# 固定 TODO 完全固定
	var linker = ActiveBlockLinker.new(self, new_block)
	block_linkers[direction] = linker
	add_child(linker)
	# 调整方块分组
	new_block.set_active_blocks(active_blocks)
	new_block.freeze = false
	freeze = false
