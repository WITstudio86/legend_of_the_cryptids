extends CharacterBody2D

const SPEED = 160.0
const FLOOR_ACCELERATION = SPEED / 0.2 # 期望 0.2秒完成加速 , 这里求每秒变化多少
const AIR_ACCELERATION = SPEED / 0.02 # 空中变化速度更快
const JUMP_VELOCITY = -320.0
#获得重力
var gravity = ProjectSettings.get("physics/2d/default_gravity")
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var jump_request_timer: Timer = %JumpRequestTimer


func _unhandled_input(event: InputEvent) -> void:
	# 按下跳跃键之后会有一个 0.1秒的跳跃请求时间 , 在个时间内都可以出发跳跃
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	# 松开表示放弃跳跃请求
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		# 实现空格时长控制跳跃高度 , 如果松开的时候还不到一半就
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
		
		

func _physics_process(delta: float) -> void:
	# 实现左右移动
	var direction = Input.get_axis("move_left","move_right")
	# ACCELERATION * delta 获得当前帧时间中应该移动的距离是多少, 实现加速减速的过程
	# 空中和地面不同的速度变化步长
	var acceleration = FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x ,direction * SPEED , acceleration * delta)
	# 实现重力
	velocity.y += gravity * delta
	# 跳跃
	# 在地板上或者处于 coyote time 都可以跳跃
	var can_jump = is_on_floor() or coyote_timer.time_left > 0
	var should_jump = jump_request_timer.time_left > 0 and can_jump
	if should_jump:
		velocity.y = JUMP_VELOCITY
	# 实现动画
	if is_on_floor():
		# 在地板上方向为 0 且速度为 0 的时候静止
		if is_zero_approx(direction) and is_zero_approx(velocity.x):
			animated_sprite_2d.play("idle")
		else:
			# 不为零的时候
			animated_sprite_2d.play("runing")
	else:
		animated_sprite_2d.play("jump")
	# 实现左右反转,不近乎为 0 的时候
	if not is_zero_approx(direction):
		animated_sprite_2d.flip_h = direction < 0
	
	# 实现郊狼时间: 移动之前记录在地板上的状态 , 移动之后判断是否相同 , 
	# 不同且之前在地板上的时候开启时间
	var was_on_floor = is_on_floor()
	move_and_slide()
	if is_on_floor() != was_on_floor:
		# 曾经在地板上并且不是因为按下空格跳跃改变的状态
		if was_on_floor and not should_jump:
			# 那么开启cayote time
			coyote_timer.start()
		else:
			coyote_timer.stop()
