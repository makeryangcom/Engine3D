extends CharacterBody3D

## 玩家
class_name Player

@onready var body: Node3D = $Body
@onready var skin: PlayerSkin = $Body/Skin
@onready var camera_arm: SpringArm3D = $CameraArm
@onready var camera: Camera3D = $CameraArm/Camera
@onready var state_machine: StateMachine = $StateMachine

# 方向向量
@export var direction: Vector3
# 移动速度
@export var speed: float = 5.0
# 跳跃速度
@export var jump_velocity: float = 4.5
# 跳跃峰值时间
@export var jump_peak_time: float = 0.5
# 跳跃坠落时间
@export var jump_fall_time: float = 0.5
# 跳跃高度
@export var jump_height: float = 1.5
# 跳跃距离
@export var jump_distance: float = 4.0
# 跳跃重力
var jump_gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
# 跳跃坠落重力
var jump_fall_gravity: float = 5.0

# 计算参数
func Calculate_Parameter() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	jump_fall_gravity = (2 * jump_height)/ pow(jump_fall_time, 2)
	jump_velocity = jump_gravity * jump_peak_time
	speed = jump_distance / (jump_peak_time + jump_fall_time)

func _ready() -> void:
	Calculate_Parameter()

# 每个物理帧触发函数
func _physics_process(_delta: float) -> void:
	# 跳跃状态检测
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= jump_gravity * _delta
		else:
			velocity.y -= jump_fall_gravity * _delta
		if state_machine.current_state.name != "Jump" and state_machine.current_state.name != "Fall":
			state_machine.change_state("Fall")
	if Event.is_space() and is_on_floor():
		state_machine.change_state("Jump")
	# 获取输入向量
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	# 获取方向
	var _rotation: Quaternion = Quaternion.from_euler(Vector3(0, camera_arm.transform.basis.get_euler().y, 0))
	direction = (_rotation * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# 如果方向有值，说明在移动
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if !Event.is_shift():
			state_machine.change_state("Walk")
		else:
			state_machine.change_state("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	# 更新玩家朝向
	if abs(velocity.x) + abs(velocity.z) > 0.1:
		var player_current_direction = Vector2(velocity.z, velocity.x)
		var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0, player_current_direction.angle(), 0))
		body.quaternion = body.quaternion.slerp(target_quaternion, _delta * 10)
	# 移动
	move_and_slide()
