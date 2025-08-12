## Autoloaded node that loads, caches, and instantiates components at runtime.
extends Node

## Signal that emits when the Components autoload finished loading all component scenes.
signal components_loaded

var _components : Dictionary[StringName, PackedScene] = {
}

func _ready() -> void:
	_load_components("res://components/")

# ANY file with the .tscn extension is gonna get sucked up by this function, so like...
# don't put other things in the path besides what you intend to be components.
func _load_components(path: String) -> void:
	var dir : DirAccess = DirAccess.open(path)
	print("Resolving path: " + path)
	
	if dir == null:
		print("Couldn't resolve path, components not loaded.")
		return 
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			print("Found directory: " + file_name)
		else:
			if file_name.get_extension() == "tscn":
				var full_path = path.path_join(file_name)
				print("found component: " + full_path)
				_components[file_name.get_basename()] = load(full_path)
		file_name = dir.get_next()
	
	print("All components loaded!")
	components_loaded.emit()

## Returns the registry of all components.
func get_component_registry() -> Dictionary[StringName, PackedScene]:
	return _components

## Instantiates the specified component tree. Optionally allows instantiating as a child of an existing component node in the root tree. Returns the instantiated component.
func instantiate_component_tree(component: String, as_child_of_component: Node = null) -> Node:
	if !_components.has(component): return null
	
	var c = _components[component].instantiate()
	
	if as_child_of_component == null:
		add_child(c)
	else: 
		as_child_of_component.add_child(c)
	
	return c
