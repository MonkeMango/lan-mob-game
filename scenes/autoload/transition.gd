extends CanvasLayer


export (String, FILE, "*.tscn") var target_scene;
export var max_load_time = 10000;
var loading_scene_instance : Node;

func transition_out() -> void:
	loading_scene_instance = load("res://scenes/autoload/transition.tscn").instance()
	var anim = loading_scene_instance.get_node("TransAnims")
	get_tree().get_root().call_deferred("add_child", loading_scene_instance)
	anim.play("trans_out")
	

func transition_in(scene_current, _next_scene := target_scene): 
	if !is_instance_valid(loading_scene_instance):
		loading_scene_instance = load("res://scenes/autoload/transition.tscn").instance()
		
		var loader = ResourceLoader.load_interactive(_next_scene)
		
		var anim = loading_scene_instance.get_node("TransAnims")
		get_tree().get_root().call_deferred("add_child", loading_scene_instance)
		anim.play("trans_in")
		yield(anim, "animation_finished")
		scene_current.queue_free()
		
		if loader == null:
			print("cannot load resource at path you stupid FUCK")
			return
		
		# Changes the scene
		while true:
			var err = loader.poll()
			if err == ERR_FILE_EOF:
				var resource = loader.get_resource()
				get_tree().get_root().call_deferred('add_child', resource.instance())
				anim.play("trans_out")
				yield(anim, "animation_finished")
				loading_scene_instance.queue_free()
				return
			elif err == OK:
				var progress = float(loader.get_stage())/loader.get_stage_count()
				print(progress)
			else:
				print("error loading file")
				break
				
			yield(get_tree(), "idle_frame");
	#	get_tree().change_scene(_next_scene)
