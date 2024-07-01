## GUI的基类
## 包含GUI的主要操作以及功能的预编译
class_name BaseGUI extends Control

signal be_opened
signal be_closed
signal be_hided
signal be_showed

var config:GUIViewConfig ## 该界面所在的config
var viewInstanceID:int = -1 ## 实例化该界面时，存储其编码


func open(): ## 打开该界面
	be_opened.emit()
	_open()

func close():## 关闭该界面
	be_closed.emit()
	_close()

func be_hide():## 该界面被隐藏
	be_hided.emit()
	_be_hide()

func be_show():## 该界面被显示
	be_showed.emit()
	_be_show()

func _open():## 打开该界面时触发的方法
	pass

func _close():## 关闭该界面时触发的方法
	pass

func _be_hide():## 该界面被隐藏时触发的方法
	pass

func _be_show():## 该界面被显示时触发的方法
	pass

func _close_self():## 当前界面面关闭自己
	G._get_view_manager().close_view(viewInstanceID)

func _hide_others():## 隐藏该界面外其他界面
	for InstanceId:int in G._get_view_manager().viewInstanceMap:
		if InstanceId != viewInstanceID:
			G._get_view_manager().hide_view(InstanceId)

func _show_others():## 显示该界面外其他界面
	for InstanceId:int in G._get_view_manager().viewInstanceMap:
		if InstanceId != viewInstanceID:
			G._get_view_manager().show_view(InstanceId)
