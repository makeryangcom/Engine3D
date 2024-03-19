extends SpringArm3D

class_name PlayerCamera

@onready var camera: Camera3D = $Camera
@onready var backgroud_viewport: SubViewport = $Camera/backgroud_viewport_container/backgroud_viewport
@onready var forgroud_viewport: SubViewport = $Camera/forgroud_viewport_container/forgroud_viewport
@onready var backgroud_camera: Camera3D = $Camera/backgroud_viewport_container/backgroud_viewport/backgroud_camera
@onready var forgroud_camera: Camera3D = $Camera/forgroud_viewport_container/forgroud_viewport/forgroud_camera

## 弹簧臂的x、y轴的旋转欧拉角
@export var arm_x: float = 0
@export var arm_y: float = 0
## 弹簧臂X轴旋转速度
@export var arm_x_speed: float = 5
## 弹簧臂Y轴旋转速度
@export var arm_y_speed: float = 5
## 相机与地面的最小夹角角度
@export_range(10, 80) var camera_min_limit_angle: float = -5
## 相机与地面的最大夹角角度
@export_range(10, 80) var camera_max_limit_angle: float = 80
## 相机的视距
@export var camera_distance: float = 5
## 相机的最小视距
@export var camera_min_distance: float = 2
## 相机的最大视距
@export var camera_max_distance: float = 10
## 相机视角缩放速度
@export var camera_distance_speed: float = 40
## 相机视角是否启动阻尼
@export var camera_is_need_damping: bool = true
## 相机视角阻尼大小
@export var camera_need_damping: float = 10

var collider = null

# 鼠标右键是否按下
var mouse_right_press: bool = false
# 鼠标滑动的状态枚举
enum MOUSE_WHEEL_STATE {
	NONE = 0, # 未滑动
	UP = -1, # 向前滑动
	DOWN = 1, # 向后滑动
}
# 鼠标的滚轮状态
var mouse_wheel: MOUSE_WHEEL_STATE = MOUSE_WHEEL_STATE.NONE

func _input(event: InputEvent) -> void:
	# 判断当前事件是否为鼠标移动且鼠标右键被按下，来更新x,y的值
	if event is InputEventMouseMotion and mouse_right_press:
		# 鼠标上下位移，调整的是视野上下移动，此时旋转的是x轴
		arm_x = arm_x + -event.relative.y * arm_x_speed * 0.001
		# 鼠标左右移动，调整的是视野的左右移动，旋转的是y轴
		arm_y = arm_y + -event.relative.x * arm_x_speed * 0.001
		# 根据视角角度边界，来限制x的值
		var x_min_limit = camera_min_limit_angle / 180 * PI # -3.14到+3.14
		var x_max_limit = camera_max_limit_angle / 180 * PI
		arm_x = -clamp(-arm_x, x_min_limit, x_max_limit) # 限制x

func _ready() -> void:
	update_viewport_size()
	# 初始化弹簧臂的x、y值
	arm_x = transform.basis.get_euler().x
	arm_y = transform.basis.get_euler().y

func _process(delta: float) -> void:
	update_viewport_camera_position()
	update_viewport_camera_mask()
	update_mouse_input()
	# 根据已有的欧拉角，来获取3D旋转的单位四元数
	var _rotation: Quaternion = Quaternion.from_euler(Vector3(arm_x , arm_y, 0))
	# 根据滚轮事件，来调整视距
	camera_distance += mouse_wheel * camera_distance_speed * delta
	# 限定camera_distance长短，不越界
	camera_distance = clamp(camera_distance, camera_min_distance, camera_max_distance)
	# 判断是都需要阻尼
	if camera_is_need_damping:
		# 使用slerp方法，来逐帧调整数值
		quaternion = quaternion.slerp(_rotation, delta * camera_need_damping)
		# 使用lerp方法，来逐帧调整数值
		spring_length = lerp(spring_length, camera_distance, delta * camera_need_damping)
	else:
		quaternion = _rotation
		spring_length = camera_distance

func update_mouse_input() -> void:
	# 判断鼠标有没有按下右键
	mouse_right_press = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	# 判断鼠标是否前滑
	var is_wheel_up = Input.is_action_just_released("mouse_scroll_up")
	# 判断鼠标是否后滑
	var is_wheel_down = Input.is_action_just_released("mouse_scroll_down")
	if is_wheel_up:
		mouse_wheel = MOUSE_WHEEL_STATE.UP
	elif is_wheel_down:
		mouse_wheel = MOUSE_WHEEL_STATE.DOWN
	else:
		mouse_wheel = MOUSE_WHEEL_STATE.NONE

func update_viewport_size() -> void:
	backgroud_viewport.size = DisplayServer.window_get_size()
	forgroud_viewport.size = DisplayServer.window_get_size()

func update_viewport_camera_position() -> void:
	backgroud_camera.global_transform = camera.global_transform
	forgroud_camera.global_transform = camera.global_transform

func update_viewport_camera_mask() -> void:
	var query_parameters = PhysicsRayQueryParameters3D.new()
	query_parameters.from = camera.global_transform.origin
	query_parameters.to = get_parent().global_transform.origin
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query_parameters)
	if result["collider"] != get_parent():
		if result["collider"].has_method("set_layer_mask_value"):
			if collider:
				collider.set_layer_mask_value(1, true)
				collider.set_layer_mask_value(2, false)
			collider = result["collider"]
			collider.set_layer_mask_value(1, false)
			collider.set_layer_mask_value(2, true)
	else:
		if collider:
			collider.set_layer_mask_value(1, true)
			collider.set_layer_mask_value(2, false)
			collider = null
