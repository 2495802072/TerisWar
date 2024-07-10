extends BaseGUI

func _on_play_pressed():
	# 打开游戏内的UI
	G._get_view_manager().open_view("GamingUI") 
	# 添加地图
	G._get_game_root().refresh_map()
	# 添加玩家
	G._get_game_root().add_player()
	
	#关闭自身
	_close_self()
	
