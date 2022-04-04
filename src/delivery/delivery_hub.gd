extends Node2D

signal pickup

onready var pickup_zone = $PickupZone
onready var pickup_zone_sprite = $PickupZone/DeliveryZoneSprite
onready var shop_zone_sprite = $PickupZone/ShopZoneSprite
onready var is_active = true setget set_active
onready var can_pickup = false setget set_can_pickup

var completion_dialog

func _ready():
	set_active(is_active)


func _physics_process(_delta):
	if can_pickup:
		if Input.is_action_just_released("interact"):
#			generate_delivery_dialog()
			emit_signal("pickup")
			set_active(false)
			set_can_pickup(false)


func new_delivery():
	set_active(true)


func generate_delivery_dialog():
	# TODO - generate these randomly based on organ and lines in a csv
	completion_dialog = Dialogic.start('Test Delivery Text') 
	add_child(completion_dialog)
	get_tree().paused = true
	yield(completion_dialog, "timeline_end")
	get_tree().paused = false


func set_active(value):
	is_active = value
	
	pickup_zone_sprite.visible = is_active
	shop_zone_sprite.visible = !is_active
	GlobalFlags.CAN_SHOP = !is_active


func set_can_pickup(value):
	can_pickup = value
	if can_pickup:
		print("Ready for pickup!")


func _on_PickupZone_body_entered(body):
	if body is Player:
		if is_active:
			set_can_pickup(true)
			GlobalFlags.CAN_SHOP = false
		else:
			GlobalFlags.CAN_SHOP = true


func _on_PickupZone_body_exited(body):
	if body is Player:
		GlobalFlags.CAN_SHOP = false
		if is_active:
			set_can_pickup(false)