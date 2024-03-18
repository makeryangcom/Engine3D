extends Node3D

## 角色状态机
class_name StateMachine

@export var current_state: StateBase

# 准备就绪
func _ready() -> void:
	for child in get_children():
		if child is StateBase:
			child.state_machine = self
	await get_parent().ready
	current_state.enter()

# 渲染帧
func _process(delta: float) -> void:
	current_state.process_update(delta)

# 物理帧
func _physics_process(delta: float) -> void:
	current_state.physics_process_update(delta)

# 切换状态
func change_state(target_state_name: String) -> void:
	var target_state = get_node_or_null(target_state_name)
	if target_state == null:
		return
	current_state.exit()
	current_state = target_state
	current_state.enter()
