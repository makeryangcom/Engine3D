extends StateBase

# 玩家节点
@export var player: Player

func enter() -> void:
	super.enter()
	print("[进入行走状态]")
	player.speed = Global.get_settings_player_walk_speed()
	player.body_model.walk_action()

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 退出状态
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
