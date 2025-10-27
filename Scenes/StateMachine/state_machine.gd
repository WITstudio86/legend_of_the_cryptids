extends Node

var states:Dictionary = {}
var current_state:State
@export var inital_state:State

func _ready() -> void:
	# 确保在所有的 ready 都执行之后再开始注入
	call_deferred("on_init_state")
	
func on_init_state():
	for child:State in get_children():
		states[child.name.to_lower()] = child
		# 注入 , 让每个状态都可以获取 Player
		child.owner_node = owner
		child.transitioned.connect(on_transitioned)
	
	if inital_state:
		inital_state.entry()
		current_state = inital_state

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physice_process(delta)

func on_transitioned(state :State, next_state_name:String):
	if current_state != state:return
	
	var next_state:State = states.get(next_state_name.to_lower())
	if !next_state:return
	
	if current_state:
		current_state.exit()
	next_state.entry()
	current_state = next_state
