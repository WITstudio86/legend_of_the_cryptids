class_name State
extends Node

var owner_node : Node
signal transitioned(state:State , next_state_name:String)

func entry():pass
func exit():pass
func process(delta):pass
func physice_process(delta):pass
