class_name GUIManager extends Node

signal  alert_return_update() ## 警告框(Y/N)做出选择后触发
var alert_imformation:String = "" ## 警告框(Y/N)信息，弹出警告框时，不应为空
var alert_return:bool = false ## 警告框(Y/N)的返回值

@export var ViewConfigList:Array[GUIViewConfig] = []
@export var guiRoot:Control

var viewConfigMap := {} # GUI总列表

var viewInstanceCount := 0 # 编号用方法获取，并自增
var viewInstanceMap := {} # GUI实例化的界面列表（有编号）

var has_language:bool = FileAccess.file_exists(G.language_file) #是否存在Language文件

func _ready():
	_build_view_config_map()
	G._get_view_manager().open_view("PrimaryMenu") # 加载主菜单到guiRoot
	#if not has_language:
		#G._get_view_manager().open_view("SettingsMenu") # 加载设置界面到guiRoot

func open_view(viewId:StringName) ->int: ## 打开名为[viewId]的界面
	var config := _get_view_config(viewId) # 获取对应名字的config
	var instance := _get_new_view_instance_id()# 新界面赋予新的编号
	var prefab:PackedScene = config.prefab #获取对应config下的PackedScene
	var view:BaseGUI = prefab.instantiate() #PackedScene的实例化
	
	# 赋值 & open
	view.config = config
	view.viewInstanceID = instance
	viewInstanceMap[instance] = view
	guiRoot.add_child(view)
	view.open()
	
	# 返回界面编号
	return instance

func close_view(viewInstanceId:int):## 关闭编码为[viewInstanceId]的界面
	var view := _get_view_by_instance(viewInstanceId)
	view.close()
	viewInstanceMap.erase(viewInstanceId)
	view.queue_free()

func hide_view(viewInstanceId:int):## 隐藏编码为[viewInstanceId]的界面
	var view := _get_view_by_instance(viewInstanceId)
	view.be_hide()
	view.hide()

func show_view(viewInstanceId:int):## 显示编码为[viewInstanceId]的界面
	var view := _get_view_by_instance(viewInstanceId)
	view.be_hide()
	view.show()

func _get_view_config(viewId:StringName) -> GUIViewConfig: ## 获取对应名称的config
	return viewConfigMap[viewId]

func _get_new_view_instance_id() -> int: ## 获取编码，并让编码自增
	var t:int = viewInstanceCount
	viewInstanceCount += 1
	return t

func _get_view_by_instance(viewInstanceId:int) -> BaseGUI: ## 通过编码获取实例化的界面
	return viewInstanceMap[viewInstanceId]

func _build_view_config_map(): ## 搭建总界面列表，并自动排除空项
	for config:GUIViewConfig in ViewConfigList:
		if config == null or config.id.is_empty():
			continue
		viewConfigMap[config.id] = config

func jump_alert(imformation:String) -> bool: ## 弹出警告框(Y/N)
	alert_imformation = imformation
	alert_return = false
	G._get_view_manager().open_view("Alert")
	await alert_return_update
	return alert_return

func get_alert_imformation() -> String: ## 获取警告框(Y/N)信息
	return alert_imformation

func set_alert_return(flag:bool) -> void:## 更新警告框(Y/N)的返回值
	alert_return = flag
	alert_return_update.emit()
