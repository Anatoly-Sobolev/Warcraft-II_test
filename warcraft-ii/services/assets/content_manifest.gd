class_name ContentManifest
extends Resource

const STATUS_PROJECT_FINAL := "project_final"
const STATUS_PROJECT_PLACEHOLDER := "project_placeholder"
const STATUS_ORIGINAL_PLACEHOLDER := "original_placeholder"
const STATUS_REPLACEMENT_READY := "replacement_ready"
const STATUS_DEPRECATED_PLACEHOLDER := "deprecated_placeholder"

const ORIGIN_PROJECT := "project"
const ORIGIN_PROJECT_PLACEHOLDER := "project_placeholder"
const ORIGIN_ORIGINAL_PLACEHOLDER := "original_placeholder"
const SELF_SCRIPT_PATH := "res://services/assets/content_manifest.gd"

@export var packages: Dictionary = {}
@export var assets: Dictionary = {}

static func load_from_json_file(path: String):
	if not FileAccess.file_exists(path):
		push_warning("Content manifest not found: %s" % path)
		return _new_manifest()

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Cannot open content manifest: %s" % path)
		return _new_manifest()

	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		push_warning("Content manifest is not a JSON object: %s" % path)
		return _new_manifest()

	return from_dictionary(parsed)

static func from_dictionary(data: Dictionary):
	var manifest = _new_manifest()
	manifest.packages = data.get("packages", {}).duplicate(true)

	for entry in data.get("assets", []):
		if not (entry is Dictionary):
			continue
		var asset_id := String(entry.get("asset_id", ""))
		if asset_id.is_empty():
			continue
		manifest.assets[asset_id] = entry.duplicate(true)

	return manifest

static func _new_manifest():
	return load(SELF_SCRIPT_PATH).new()

func get_asset_entry(asset_id: String) -> Dictionary:
	return assets.get(asset_id, {})

func get_asset_path(asset_id: String) -> String:
	return String(get_asset_entry(asset_id).get("runtime_path", ""))

func get_asset_status(asset_id: String) -> String:
	return String(get_asset_entry(asset_id).get("status", ""))

func is_placeholder(asset_id: String) -> bool:
	var status := get_asset_status(asset_id)
	return status == STATUS_PROJECT_PLACEHOLDER or status == STATUS_ORIGINAL_PLACEHOLDER

func is_original_placeholder(asset_id: String) -> bool:
	var entry := get_asset_entry(asset_id)
	return String(entry.get("origin", "")) == ORIGIN_ORIGINAL_PLACEHOLDER \
		or String(entry.get("status", "")) == STATUS_ORIGINAL_PLACEHOLDER

func get_asset_origin(asset_id: String) -> String:
	return String(get_asset_entry(asset_id).get("origin", ""))

func get_asset_type(asset_id: String) -> String:
	return String(get_asset_entry(asset_id).get("type", ""))

func get_source_paths(asset_id: String) -> Array:
	return get_asset_entry(asset_id).get("source_paths", [])

func get_package_asset_ids(package_id: String) -> Array:
	return packages.get(package_id, [])

func get_replacement_target(asset_id: String) -> String:
	return String(get_asset_entry(asset_id).get("replacement_target", ""))

func get_replacement_strategy(asset_id: String) -> String:
	return String(get_asset_entry(asset_id).get("replacement_strategy", ""))

func get_asset_ids_by_status(status: String) -> Array:
	var result := []
	for asset_id in assets.keys():
		if get_asset_status(String(asset_id)) == status:
			result.append(asset_id)
	return result
