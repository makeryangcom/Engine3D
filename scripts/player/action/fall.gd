extends StateBase

# 玩家节点
@export var player: Player

func enter() -> void:
	super.enter()
	print("[进入坠落状态]")
	player.skin.fall_action()

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.is_on_floor():
		state_machine.change_state("Idle")
