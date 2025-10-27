class_name PlayerLanding
extends State

var player : Player
func entry():
	player = owner_node as Player
	player.animated_sprite_2d.play("landing")

func physice_process(_delta):
	if not player.animated_sprite_2d.is_playing():
		transitioned.emit(self , "PlayerIdle")
