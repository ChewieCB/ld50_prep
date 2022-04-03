extends Node2D

signal delivered(point)

onready var delivery_zone = $DeliveryZone
onready var is_active = false setget set_active
onready var can_deliver = false setget set_can_deliver

var completion_dialog

func _ready():
	set_active(is_active)


func _physics_process(_delta):
	if can_deliver:
		if Input.is_action_just_released("interact"):
			generate_delivery_dialog()
			emit_signal("delivered", self)


func generate_delivery_dialog():
	# TODO - generate these randomly based on organ and lines in a csv
	completion_dialog = Dialogic.start('Test Delivery Text') 
	add_child(completion_dialog)
	get_tree().paused = true
	yield(completion_dialog, "timeline_end")
	get_tree().paused = false


func set_active(value):
	is_active = value
	
	delivery_zone.visible = is_active


func set_can_deliver(value):
	can_deliver = value
	if can_deliver:
		print("Can deliver to " + self.name)
	else:
		print("Exited " + self.name)


func _on_DeliveryZone_body_entered(body):
	if is_active and body is Player:
		set_can_deliver(true)


func _on_DeliveryZone_body_exited(body):
	if is_active and body is Player:
		set_can_deliver(false)
