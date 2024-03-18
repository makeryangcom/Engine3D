extends Node3D

class_name PlayerModel

@onready var animation_player: AnimationPlayer = $Root/AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_tree_play: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

func idle_action() -> void:
	animation_tree_play.travel("Idle")

func walk_action() -> void:
	animation_tree_play.travel("Walk")

func run_action() -> void:
	animation_tree_play.travel("Run")

func jump_action() -> void:
	animation_tree_play.travel("Jump")

func fall_action() -> void:
	animation_tree_play.travel("Fall")
