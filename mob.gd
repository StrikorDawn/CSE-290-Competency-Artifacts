# mob.gd
extends CharacterBody2D

@warning_ignore("unused_signal")
signal mob_killed
@onready var player = get_node("/root/Game/Player")
@onready var mob: CharacterBody2D = $"."
@onready var timer: Timer = $Timer

var health
var large = 175
var medium = 225
var small = 275
var size_speed : float
var speed

func _ready():
	$Slime.play_walk()
	initialize_mob()

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func initialize_mob():
	if mob.scale >= Vector2(0.75, 0.75):
		speed = large
		health = 5
	elif mob.scale > Vector2(0.65, 0.65):
		speed = medium
		health = 3
	else:
		speed = small
		health = 1

func take_damage():
	health -= 1
	$Slime.play_hurt()
	if health <= 0:
		emit_signal("mob_killed", self)
		queue_free()
		const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		timer.one_shot
		_on_timer_timeout(smoke)
		

func _on_timer_timeout(smoke) -> void:
	queue_free()
