## Empty System template.
##
## How to create a system.
##    - Define a class name for your system. (i.e. `class_name HealthSystem`)
##    - Add your system class to the Systems autoload. (res://scripts/base/autoload/systems.gd)
##    - Define component archetypes.
##
## You run logic on entities by iterating through entities collected in archetypes.

extends System

var archetype := Archetype.new([""])
