@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/custom_class_plug/custom_class_plug.tscn").instantiate()
	add_control_to_dock(3,dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
