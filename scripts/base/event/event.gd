extends Control

# 初始化数据结构
var data = {
	"key": "",
	"mouse": "",
	"skill": "",
	"space": false,
	"shift": false
}

func _input(event) -> void:
	# 获取窗口的边界
	var viewport_rect = get_viewport_rect()
	# 获取鼠标的位置
	var viewport_mouse_position = get_viewport().get_mouse_position()
	# 如果鼠标是否在窗口内且允许控制
	if viewport_rect.has_point(viewport_mouse_position):
		if event is InputEventKey:
			if event.pressed:
				data["key"] = event.as_text_keycode()
				if event.as_text_keycode() in ["F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8"]:
					data["skill"] = event.as_text_keycode()
				else:
					data["skill"] = ""
			else:
				data["key"] = ""
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.pressed:
				data["mouse"] = "left"
			elif event.button_index == 2 and event.pressed:
				data["mouse"] = "right"
			else:
				data["mouse"] = ""

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shift"):
		data["shift"] = true
	if Input.is_action_just_released("shift"):
		data["shift"] = false
	if Input.is_action_just_pressed("jump"):
		data["space"] = true
	if Input.is_action_just_released("jump"):
		data["space"] = false

# 获取KEY值
func get_key() -> String:
	return data["key"]

# 获取MOUSE值
func get_mouse() -> String:
	return data["mouse"]

# 获取SKILL值
func get_skill() -> String:
	return data["skill"]

# 获取SPACE值
func is_space() -> bool:
	return data["space"]

# 获取SHIFT值
func is_shift() -> bool:
	return data["shift"]
