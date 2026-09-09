class_name Minotaur 
extends CharacterBody2D

######## TILAT ########
enum State {
	IDLE,
	WALK,
	ATTACK
}

var current_state: State

###### LIIKE ##########
var direction: Vector2

@export var walk_speed := 100.0
@export var run_speed := 180.0


###### NODET #########
@onready var animation_player = $AnimatedSprite2D


func _ready():
	change_state(State.IDLE)

####### PÄÄSILMUKKA ########

func _physics_process(delta: float) -> void:

	match current_state:
		State.IDLE:
			state_idle(delta)
		State.WALK:
			state_walk(delta)
		State.ATTACK:
			state_attack(delta)



####### TILA-FUNKTIOT #########

func state_idle(_delta: float) -> void:
	# varmistetaan että liike on pysähtynyt
	velocity = Vector2.ZERO

	# Näppäinten seuranta
	get_direction()
	if direction != Vector2.ZERO:
		change_state(State.WALK)
		return
	if Input.is_action_just_pressed("ui_accept"):
		change_state(State.ATTACK)
		return


func state_walk(_delta: float) -> void:
	get_direction()
	animation_player.play("walk_front")
	velocity = direction * walk_speed
	move_and_slide()

	if direction == Vector2.ZERO:
		change_state(State.IDLE)
		return
	if Input.is_action_just_pressed("ui_accept"):
		change_state(State.ATTACK)
		return


func state_attack(_delta: float) -> void:
	pass

func state_run(_delta: float) -> void:
	pass

func state_dead(_delta: float) -> void:
	pass


##### APUFUNKTIOITA ########

func get_direction(): 
	direction = Input.get_vector( "ui_left", "ui_right", "ui_up", "ui_down" )


func change_state(new_state: State) -> void:
	print("Tila muuttuu: " + str(current_state) + " -> " + str(new_state))
	current_state = new_state
	# Animaatiot
	match current_state:
		State.IDLE:
			animation_player.play("idle_front")
		State.WALK:
			animation_player.play("walk_front")
		State.ATTACK:
			animation_player.play("slash_front")


func take_damage() -> void: 
	pass


######## SIGNAALIT ###########

func _on_animated_sprite_2d_animation_finished():
	if current_state == State.ATTACK:
		change_state(State.IDLE)
