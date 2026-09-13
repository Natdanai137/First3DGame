extends Node3D

var required_collectibles := 0
var completed := false

@onready var objective_label: Label = $UserInterface/GameUI/ObjectiveLabel
@onready var chest_prompt: Label3D = $Platforms/TreasureChest/ChestPrompt
@onready var finish_panel: Control = $UserInterface/GameUI/FinishPanel


func _ready() -> void:
	GameManager.reset_score()
	required_collectibles = get_tree().get_nodes_in_group("collectibles").size()
	finish_panel.hide()
	update_objective()


func _process(_delta: float) -> void:
	if not completed:
		update_objective()


func update_objective() -> void:
	var remaining: int = max(required_collectibles - GameManager.score, 0)
	if remaining == 0:
		objective_label.text = "All treasures collected!\nGo to the chest"
		chest_prompt.text = "OPEN THE CHEST"
	else:
		objective_label.text = "Collect treasures: %d / %d\nChest opens when all are collected" % [GameManager.score, required_collectibles]
		chest_prompt.text = "CHEST LOCKED\n%d left" % remaining


func _on_treasure_chest_body_entered(body: Node3D) -> void:
	if completed or not body.is_in_group("Player"):
		return
	if GameManager.score < required_collectibles:
		chest_prompt.text = "CHEST LOCKED\nCollect every treasure first"
		return
	completed = true
	finish_panel.show()
	chest_prompt.text = "LEVEL COMPLETE!"
