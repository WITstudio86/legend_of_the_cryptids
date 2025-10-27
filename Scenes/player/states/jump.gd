class_name PlayerJump
extends State

var player : Player
func entry():
	player = owner_node as Player
	player.animated_sprite_2d.play("jump")

func physice_process(_delta):
	if player.velocity.y > 0 :
		transitioned.emit(self , "PlayerFall")
