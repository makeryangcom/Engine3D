extends StateBase

# 玩家节点
@export var player: Player

func enter() -> void:
	super.enter()
	print("[进入站立状态]")
	player.speed = Global.get_settings_player_walk_speed()
	player.body_model.idle_action()

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 移动状态检测
	if player.direction:
		if Event.is_shift():
			state_machine.change_state("Run")
		else:
			state_machine.change_state("Walk")
