extends CharacterBody3D

class_name Enemy

# 移动速度
@export var speed: float = 7.0
# 停止距离
@export var stop_distance: float = 1.5

@onready var body: Node3D = $Body
@onready var body_model: EnemyModel = $Body/Model
# 玩家
@onready var player: Player
# 导航代理节点
@onready var navigation: NavigationAgent3D = $Navigation

func _ready() -> void:
	# 获取目标玩家
	player = get_tree().current_scene.get_node("Player")

func _physics_process(_delta: float) -> void:
	var direction = (navigation.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	if navigation.distance_to_target() > stop_distance:
		body_model.run_action()
		move_and_slide()
	else:
		body_model.idle_action()
	# 朝向玩家
	var direction_2d = Vector2(direction.z, direction.x)
	var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0, direction_2d.angle(), 0))
	body.quaternion = body.quaternion.slerp(target_quaternion, _delta * 10)

func _on_timer_timeout() -> void:
	navigation.target_position = player.global_position
	navigation.target_position = navigation.get_final_position()
