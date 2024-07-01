extends TileMap

## 手动预设图案
@export var cells_dic:Array[CellsConfig] = [] 

var task_id:int ##线程任务id

func _ready():
	task_id = WorkerThreadPool.add_task(thread_generate,true)

func thread_generate()->void: ##线程生成地图
	randomize()
	print(cells_dic.size())
	var i = randi_range(0,cells_dic.size()-1)
	set_cells_terrain_connect(0,cells_dic[i].cells_array,0,0,true)
	pass

