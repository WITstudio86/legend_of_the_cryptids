class_name PlayerIdle
extends State

var player : Player
func entry():
	player = owner_node as Player
	player.animated_sprite_2d.play("idle")

func physice_process(_delta):
	if player.is_on_floor() and not is_zero_approx(player.velocity.x):
		transitioned.emit(self , "PlayerRunning")
	if not player.is_on_floor() and player.velocity.y < 0:
		transitioned.emit(self , "PlayerJump")

	
