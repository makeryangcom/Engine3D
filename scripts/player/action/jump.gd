extends StateBase

# 玩家节点
@export var player: Player

func enter() -> void:
	super.enter()
	print("[进入跳跃状态]")
	player.velocity.y = player.jump_velocity
	player.skin.jump_action()

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.is_on_floor():
		state_machine.change_state("Idle")
	if player.velocity.y < 0:
		state_machine.change_state("Fall")
