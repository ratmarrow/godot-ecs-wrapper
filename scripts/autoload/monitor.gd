## Rudimentary monitor for general performance metrics and the ECS structure. Can be safely removed.
extends Node

const INTERVAL : float = 1.0
var timer : float = 0.0

var monitor_string : String = "cpu: null, nan thread(s)\ngpu: null\nfps: nan\nframetime: nan\nmem (mb): nan\n\nentities:\nloaded components:"
var entity_string : String = ""
var component_string : String = ""

var monitor_label : Label

func _init() -> void:
	_instantiate_monitor_label()
	
	Entities.entities_updated.connect(_update_entity_string)
	Components.components_loaded.connect(_create_component_string)

func _instantiate_monitor_label() -> void:
	monitor_label = Label.new()
	monitor_label.add_theme_font_size_override("font_size", 10)
	add_child(monitor_label)

func _update_entity_string() -> void:
	entity_string = ""
	
	for e in Entities.get_all_entities():
		entity_string += "%s: %s\n" % [
			e,
			Entities.get_components(e).keys()
		]
	
	# entities:
	# 0: ["component-a", "component-b"]
	# 1: ["component-x", "component-y"]

func _create_component_string() -> void:
	component_string = ""
	var registry = Components.get_component_registry()
	
	for c in registry:
		component_string += "%s\n" % [
			c,
		]

func _process(delta: float) -> void:
	timer += delta
	
	if timer >= INTERVAL:
		monitor_string = "cpu: %s, %s thread(s)\ngpu: %s\nfps: %s\nframetime: %s\nmem (mb): %s\n\nentities:\n%s\nloaded components:\n%s" % [
			OS.get_processor_name(),
			OS.get_processor_count(),
			RenderingServer.get_video_adapter_name(),
			Performance.get_monitor(Performance.TIME_FPS), 
			Performance.get_monitor(Performance.TIME_PROCESS),
			snappedf(Performance.get_monitor(Performance.MEMORY_STATIC) / 1024 / 1024, 0.0001),
			entity_string,
			component_string
			]
	
	monitor_label.text = monitor_string
