extends Node3D

class_name EnemyModel

@onready var animation_player: AnimationPlayer = $Root/AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_tree_play: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var beta_surface: MeshInstance3D = $Root/RootNode/GeneralSkeleton/Beta_Surface

var colors: Array = [
	Color(0.714, 0.161, 0.259, 1), 
	Color(0.158, 0.294, 0.776, 1), 
	Color(0.808, 0.439, 0.122, 1),
	Color(0.714, 0.161, 0.259, 1), 
	Color(0.158, 0.294, 0.776, 1), 
	Color(0.808, 0.439, 0.122, 1)
]

func _ready() -> void:
	for i in range(beta_surface.mesh.get_surface_count()):
		var material = beta_surface.mesh.surface_get_material(i)
		print(randi() % colors.size())
		material.albedo_color = colors[randi() % colors.size()]
	
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
