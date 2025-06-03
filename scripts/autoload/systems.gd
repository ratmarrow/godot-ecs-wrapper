## Autoloaded node that instances the systems when components are loaded at runtime.
extends Node

var systems_initialized : bool = false

func _init() -> void:
	Components.components_loaded.connect(_initialize_systems)

func _initialize_systems() -> void:
	print("Signal 'components_loaded' received. Initializing systems...")
	if systems_initialized == true: return
	
	# System instancing goes here.
	
	systems_initialized = true
	print("Systems initialized!")
