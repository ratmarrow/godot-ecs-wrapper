## Autoloaded node that manages the entities being simulated.
extends Node

var _entities : Dictionary[int, Dictionary] = {}
var _next_available_entity_id : int = 0

## Emits whenever an entity is created, removed, or modified.
signal entities_updated

## Creates an empty entity in the entity stack. Returns the ID of the created entity.
func create_entity() -> int:
	var id = _next_available_entity_id
	_entities[id] = {}
	_next_available_entity_id += 1
	return id

## Clears the specified and all it's components from the stack.
func remove_entity(id: int) -> void:
	for c in _entities[id]:
		c.queue_free()
	
	_entities.erase(id)
	entities_updated.emit()
	pass

## Queries the entity stack using the specified Archetype. Returns list of correlated entity IDs.
func query(archetype: Archetype) -> Array[int]:
	var ent_query : Array[int] = []
	var components : Array[String] = archetype.get_component_array()
	
	for e in _entities:
		if _entities[e].has_all(components):
			ent_query.append(e)
	
	return ent_query

## Adds component to the specified entity. Can be created as a child of an existing component in the tree. Returns the component Node.
func add_component(component: String, entity: int, as_child_of_component: Node = null) -> Node:
	var c = Components.instantiate_component_tree(component, as_child_of_component)
	
	if c == null: return null

	c.name = str(entity) + "-" + component
	_entities[entity][component] = c
	entities_updated.emit()
	
	return c

## Removes component from the specified entity.
func remove_component(component: String, entity: int) -> void:
	if _entities[entity].has(component):
		var c = _entities[entity][component]
		c.queue_free()
		_entities[entity].erase(component)
		entities_updated.emit()
	else:
		pass

## Returns the component table assigned to the specified entity ID.
func get_components(entity: int) -> Dictionary:
	return _entities[entity]

## Returns the stack of all currently existing entities.
func get_all_entities() -> Dictionary[int, Dictionary]:
	return _entities
