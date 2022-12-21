extends KinematicBody2D

enum {
	IDLE,
	MOVE,
	UNHANDLED
};

export var run : float = 180;
export var speed : float = 100;
var xval : float
var velocity : Vector2 = Vector2.ZERO;
var direction : Vector2
var states : int = MOVE;
onready var animation_tree : AnimationTree = $CollisionShape2D/AnimationTree;
onready var animation_state  = animation_tree.get("parameters/playback");

	
func _physics_process(_delta) -> void:
	
	if OS.is_debug_build():
		if Input.is_action_pressed("reset"):
			 var _success = get_tree().reload_current_scene()
	
	direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	);
	
	direction = direction.normalized()
	
	#NOTE: saves the player's direction and decides what state they're in
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", direction);
		velocity = direction;
		states = MOVE;
	else:
		states = IDLE;
		velocity = Vector2.ZERO;
	
	
	match states:
		
		IDLE:
			idle();
			
		MOVE:
			walk();
			
		UNHANDLED:
			pass
	
	
	
	
func walk() -> void:
	animation_tree.set("parameters/walk/blend_position", direction);
	animation_state.travel("walk")
	
	#NOTE: run shit pretty basic, i might add an animation for running later and change it into it's own function
	if !Input.get_action_strength("run"):
		xval = speed
	else:
		xval = run;
	
	velocity = move_and_slide(xval * velocity);	
		

func idle() -> void:
	animation_state.travel("idle");
