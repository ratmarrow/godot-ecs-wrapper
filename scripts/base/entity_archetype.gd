## An object that stores references to entities collected based on it's list of components.
class_name Archetype extends RefCounted

var _component_array : Array[String]
var _entities : Array[int]

func _init(components: Array[String]) -> void:
	Entities.entities_updated.connect(_refresh_entities)
	self._component_array = components

## Returns an array of the entity IDs associated with the component archetype.
func get_entities() -> Array[int]:
	return _entities

## Returns an array of the components (as strings) the component archetype uses.
func get_component_array() -> Array[String]:
	return _component_array

## Clears the associated entity IDs from the component archetype and queries for valid entities.
func _refresh_entities() -> void:
	# This probably sucks bad but ¯\_(ツ)_/¯
	_entities = Entities.query(self)
