class_name ResourceComponent extends Node2D

@export var WOOD = 100
@export var WATER = 100
@export var SUGAR = 100

var wood : int
var water : int
var sugar : int

func _ready():
	wood = WOOD
	water = WATER
	sugar = SUGAR

func transact_material(material: uMaterial, quantity:int):
	var owned
	if is_instance_of(material, Wood): owned = wood
	#elif is_instance_of(material, Wood): owned = water
	#elif is_instance_of(material, Wood): owned = sugar
	return owned - quantity >= 0

func add_material(material: uMaterial, quantity:int):
	if is_instance_of(material, Wood): 
		wood += quantity
	#elif is_instance_of(material, Wood): owned = water
	#elif is_instance_of(material, Wood): owned = sugar
	
func subtract_material(material: uMaterial, quantity:int):
	if is_instance_of(material, Wood):
		wood -= quantity
	#elif is_instance_of(material, Wood): owned = water
	#elif is_instance_of(material, Wood): owned = sugar
