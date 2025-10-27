class_name PlayerRunning
extends State

var player : Player
func entry():
	player = owner_node as Player
	player.animated_sprite_2d.play("runing")

func physice_process(delta):
	if not player.is_on_floor():
		if player.should_jump:
			transitioned.emit(self , "PlayerJump")
			player.coyote_timer.stop()
		else:
			player.coyote_timer.start()
			transitioned.emit(self , "PlayerFall")

	if player.is_on_floor() and is_zero_approx(player.velocity.x):
		transitioned.emit(self , "PlayerIdle")
