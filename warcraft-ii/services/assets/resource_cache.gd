class_name ResourceCache
extends RefCounted

var _resources: Dictionary = {}
var _failed_paths: Dictionary = {}

func has_resource(path: String) -> bool:
	return _resources.has(path)

func get_resource(path: String) -> Resource:
	return _resources.get(path, null)

func put_resource(path: String, resource: Resource) -> void:
	if path.is_empty() or resource == null:
		return
	_resources[path] = resource
	_failed_paths.erase(path)

func mark_failed(path: String, reason: String = "") -> void:
	if path.is_empty():
		return
	_failed_paths[path] = reason

func has_failed(path: String) -> bool:
	return _failed_paths.has(path)

func get_failed_reason(path: String) -> String:
	return String(_failed_paths.get(path, ""))

func clear() -> void:
	_resources.clear()
	_failed_paths.clear()
