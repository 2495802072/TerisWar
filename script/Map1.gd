extends TileMap

@export var l0_tile_data:PackedInt32Array
var start_vec:Vector2i = Vector2i(-3,20)
var end_vec:Vector2i = Vector2i(53,30)
var task_id:int ##线程任务id

func _ready():
	task_id = WorkerThreadPool.add_task(thread_generate,true)
	pass

func thread_generate()->void: ##线程生成地图
	var array:Array[Vector2i] = []
	
	for x in range(start_vec.x,end_vec.x):
		for y in range(start_vec.y,end_vec.y):
			randomize()
			if randi_range(0,10) < 5:
				var local_vector:Vector2i = Vector2i(x,y)
				array.append(local_vector) #填充图格
	set_cells_terrain_connect(0,array,0,0)
	
	call_deferred("_generate_finished",get("layer_0/tile_data"))
	pass

##由主线程设置图格
func _generate_finished(tile_data:PackedInt32Array) -> void:
	l0_tile_data = tile_data
	pass
