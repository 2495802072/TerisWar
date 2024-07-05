class_name ActiveBlocks
extends Node
# 活动方块组 保持活动方块整体

# 活动方块单体
const ACTIVE_BLOCK = preload("res://Map/scene/active_block/active_block.tscn")
# 核心方块附加材质
const ACTIVE_BLOCK_CORE_MATERIAL = preload("res://material/active_block_core.tres")
# 此方块分组的核心方块
var core_block

# 设置核心方块
func set_core_block(new_core_block):
	if core_block != null:
		core_block.material = null
	new_core_block.material = ACTIVE_BLOCK_CORE_MATERIAL
	core_block = new_core_block

# 添加新方块到组 传入起点方块 方向 新方块
func add_block(source_block, direction:Vector2, new_block):
	if source_block == new_block:
		return
	source_block.link_new_block(direction, new_block)

func _init(_data = null):
	_init_core_block()

func _init_core_block():
	var new_core_block = ACTIVE_BLOCK.instantiate()
	add_child(new_core_block)
	set_core_block(new_core_block)
	new_core_block.active_blocks = self
