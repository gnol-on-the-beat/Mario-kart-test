extends Node

var Utils = preload("res://art/Utils.gd") # A collection of pure functions


func _ready():
	print(Utils.test())
	get_tree().quit()
