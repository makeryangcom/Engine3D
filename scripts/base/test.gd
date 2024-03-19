extends CSGShape3D

# 玩家节点
@export var player: Player
# 弹簧臂相机节点
@export var camera: Camera3D

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	print(player)
	camera = get_tree().current_scene.get_node("Player").get_node("CameraArm").get_node("Camera")
	print(camera)

func _process(delta: float) -> void:
	var query_parameters = PhysicsRayQueryParameters3D.new()
	query_parameters.from = camera.global_transform.origin
	query_parameters.to = player.global_transform.origin
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query_parameters)
	if result.has("collider") and result["collider"] == self:
		set_layer_mask_value(1, false)
		set_layer_mask_value(2, true)
	else:
		set_layer_mask_value(1, true)
		set_layer_mask_value(2, false)
