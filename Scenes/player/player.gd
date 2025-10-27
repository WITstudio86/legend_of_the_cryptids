extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = -300.0
#获得重力
var gravity = ProjectSettings.get("physics/2d/default_gravity")
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# 实现左右移动
	var direction = Input.get_axis("move_left","move_right")
	velocity.x = direction * SPEED
	# 实现重力
	velocity.y += gravity * delta
	# 跳跃
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# 实现动画
	if is_on_floor():
		# 在地板上近乎为零速度的时候
		if is_zero_approx(direction):
			animated_sprite_2d.play("idle")
		else:
			# 不为零的时候
			animated_sprite_2d.play("runing")
	else:
		animated_sprite_2d.play("jump")
	# 实现左右反转,不近乎为 0 的时候
	if not is_zero_approx(direction):
		animated_sprite_2d.flip_h = direction < 0
	
	move_and_slide()
