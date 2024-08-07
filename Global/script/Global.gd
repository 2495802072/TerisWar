## 游戏全局设置，自动加载中命名为G
extends Node

signal game_entered() ##完全进入游戏后触发
signal game_exited() ##从游戏中退出触发

var override_file:String 
var language_file:String 
var multi_file:String

var PLAY_MODE := PLAY_MODES.SINGLEPLAYER ## 单人游戏或者多人游戏
enum PLAY_MODES{
	SINGLEPLAYER,## 单人游戏
	MULTIPLAYER_HOST,## 多人游戏(主机)
	MULTIPLAYER_JOIN,## 多人游戏(客户端)
}

func _init(): ## 初始化设置文件，语言文件，多人设置文件s
	if OS.has_feature("editor"):
		# 从编辑器二进制文件运行。
		override_file = ProjectSettings.globalize_path("res://override.cfg")
		language_file = ProjectSettings.globalize_path("res://language.json")
		multi_file = ProjectSettings.globalize_path("res://multiSetting.cfg")
	else:
		# 从导出的项目运行。
		override_file = OS.get_executable_path().get_base_dir().path_join("override.cfg")
		language_file = OS.get_executable_path().get_base_dir().path_join("language.json")
		multi_file = OS.get_executable_path().get_base_dir().path_join("multiSetting.cfg")

func _ready(): ## 获取语言文件中的地区
	if FileAccess.file_exists(language_file):
		var strs = FileAccess.get_file_as_string(language_file)
		var json = JSON.new()
		var error = json.parse(strs)
		if error == OK:
			var data = json.data
			if typeof(data) == TYPE_DICTIONARY and data.has("language"):
				var lang = data["language"]
				_change_language(lang) #设置游戏语言
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", strs, " at line ", json.get_error_line())
		
	pass

func _get_game_root() -> Node: ## 获取游戏根节点
	return get_node("/root/Game")

func _get_view_manager() -> GUIManager: ## 获得GUI界面管理器
	var manager:GUIManager =  _get_game_root().get_node_or_null("%GUIManager")
	if manager:
		return manager
	else:
		print("can not find manager")
		return

func _save_game_settings(): ## 保存游戏设置
	ProjectSettings.save_custom(override_file)
	pass

func _change_language(lang:String):## 修改游戏地区（语言）
	if TranslationServer.get_locale() != lang:
		TranslationServer.set_locale(lang)

func _save_language(lang:String): ## 保存当前游戏地区（语言）
	var data = {
		"language":lang
	}
	var strs = JSON.stringify(data,"\t")
	var file = FileAccess.open(language_file,FileAccess.WRITE)
	file.store_string(strs)
	pass

func _get_palyer_camera() -> Camera2D: ## 获取玩家相机
	var player_camera:Camera2D = _get_game_root().get_node_or_null("%PlayerCamera")
	if player_camera:
		return player_camera
	else:
		print("can not find camera")
		return

func has_multi_file() -> bool: ## 返回是否存在多人游戏文件
	return FileAccess.file_exists(multi_file)

func get_multi_file_path() -> String:## 返回多人游戏文件
	return multi_file

func host_game() -> void: ##主机创建游戏
	if has_multi_file():##触发该函数时 理论上必然存在Multi文件
		var file = ConfigFile.new()
		var err = file.load(multi_file)
		
		#文件成功加载
		if err == OK:
			#存在host节
			if "host" in file.get_sections():
				var port:String = file.get_value("host","port")
				var max_player:String = file.get_value("host","max_player")
				
				#创建多人主机
				var peer := ENetMultiplayerPeer.new()
				#var error := peer.create_server(7777, 4)
				var error := peer.create_server(int(port),int(max_player))
				if error:
					printerr("host error")
					return
				multiplayer.multiplayer_peer = peer
				
				print("<多人-创建游戏>")
			else:
				printerr("【host】加载失败")
		else:
			printerr("多人文件加载失败")
			return
	else :
		printerr("多人文件丢失")
		return

func join_game() -> void: ##服务端加入游戏
	#缺少判断主机端是否存在
	if has_multi_file():##触发该函数时 理论上必然存在Multi文件
		var file = ConfigFile.new()
		var err = file.load(multi_file)
		
		#文件成功加载
		if err == OK:
			#存在join节
			if "join" in file.get_sections():
				var address:String = file.get_value("join","ip")
				var port:String = file.get_value("join","port")
				
				#创建多人客户端
				var peer := ENetMultiplayerPeer.new()
				#var error := peer.create_client("127.0.0.1", 7777)
				var error := peer.create_client(address,int(port))
				if error:
					printerr("join error")
					return
				multiplayer.multiplayer_peer = peer
				
				print("<多人-加入游戏>")
			else:
				printerr("【Join】加载失败")
				return
		else:
			printerr("多人文件加载失败")
			return
	else :
		printerr("多人文件丢失")
		return

func get_play_mode(): ## 获取游戏模式
	return PLAY_MODE

func _get_BGM_Player() -> AudioStreamPlayer: ## 获取BGM音频节点
	return $BGMAudioStreamPlayer as AudioStreamPlayer

func _get_SFX_Player() -> AudioStreamPlayer:## 获取SFX音频节点
	return $SFXAudioStreamPlayer as AudioStreamPlayer

