extends Area3D

@export_file("*.tscn") var target_scene: String

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not target_scene.is_empty():
		get_tree().change_scene_to_file(target_scene)
