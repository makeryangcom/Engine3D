extends Node3D

## 基础状态
class_name StateBase

var state_machine: StateMachine

# 进入状态
func enter() -> void:
	pass

# 退出状态
func exit() -> void:
	pass

# 渲染帧
func process_update(_delta: float) -> void:
	pass

# 物理帧
func physics_process_update(_delta: float) -> void:
	pass
