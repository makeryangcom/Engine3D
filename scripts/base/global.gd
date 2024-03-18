extends Node

# 初始化数据结构
var data = {
	"varsion": "1.0.0",
	"mode": "",
	"config": {
		"map_root_path": "",
	},
	"settings": {
		"player": {
			"walk_speed": 5.0,
			"run_speed": 8.0,
			"jump_height": 1.5,
			"jump_distance": 2.0,
			"jump_velocity": 4.5,
			"jump_peak_time": 0.5,
			"jump_fall_time": 0.5
		}
	}
}

# 获取玩家行走速度设置
func get_settings_player_walk_speed() -> float:
	return data["settings"]["player"]["walk_speed"]

# 获取玩家跑步速度设置
func get_settings_player_run_speed() -> float:
	return data["settings"]["player"]["run_speed"]

# 获取玩家跳跃高度设置
func get_settings_player_jump_height() -> float:
	return data["settings"]["player"]["jump_height"]

# 获取玩家跳跃距离设置
func get_settings_player_jump_distance() -> float:
	return data["settings"]["player"]["jump_distance"]

# 获取玩家跳跃速度设置
func get_settings_player_jump_velocity() -> float:
	return data["settings"]["player"]["jump_velocity"]

# 获取玩家跳跃峰值时间设置
func get_settings_player_jump_peak_time() -> float:
	return data["settings"]["player"]["jump_peak_time"]

# 获取玩家跳跃坠落时间设置
func get_settings_player_jump_fall_time() -> float:
	return data["settings"]["player"]["jump_fall_time"]
