class_name PlayerFall
extends State

var player : Player
func entry():
	player = owner_node as Player
	player.animated_sprite_2d.play("fall")

func physice_process(_delta):
	if player.is_on_floor():
		transitioned.emit(self , "PlayerLanding")
		
