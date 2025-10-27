extends Node2D

@onready var tile_map_layer: TileMapLayer = %Trunks
@onready var camera_2d: Camera2D = %Camera2D


func _ready() -> void:
	# 实现相机自动根据已经存在图块的区域限制自身的可视区域
	# 获取已经存在的图块数量
	# grow可以在矩形基础上扩展 , -1是减少一圈 , 为了让边缘不出现在相机中
	var uesed := tile_map_layer.get_used_rect().grow(-1)
	# 获取图块的大小
	var tile_size := tile_map_layer.tile_set.tile_size
	# 计算边界
	camera_2d.limit_left = uesed.position.x * tile_size.x
	camera_2d.limit_right = uesed.end.x * tile_size.x
	camera_2d.limit_top = uesed.position.y * tile_size.y
	camera_2d.limit_bottom = uesed.end.y * tile_size.y
	# 重置 smooth , 使添加边界之后的第一次 smooth 失效避免错误的镜头晃动
	camera_2d.reset_smoothing()
