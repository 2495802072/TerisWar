extends BaseGUI

func _open():
	hide() ## 打开界面时默认隐藏自身

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		if visible:
			hide()
		else:
			show()

func _on_exit_pressed():
	_close_self()
	G._get_view_manager().open_view("PrimaryMenu")
