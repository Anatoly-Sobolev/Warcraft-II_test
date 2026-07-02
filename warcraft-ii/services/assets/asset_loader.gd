class_name AssetLoader
extends RefCounted

const ContentManifestScript := preload("res://services/assets/content_manifest.gd")
const ResourceCacheScript := preload("res://services/assets/resource_cache.gd")

enum AssetStatus {
	MISSING,
	READY,
	FAILED
}

var manifest
var cache

func _init(content_manifest = null, resource_cache = null) -> void:
	manifest = content_manifest if content_manifest != null else ContentManifestScript.new()
	cache = resource_cache if resource_cache != null else ResourceCacheScript.new()

func get_asset_status(asset_id: String) -> int:
	var path: String = manifest.get_asset_path(asset_id)
	if path.is_empty():
		return AssetStatus.MISSING
	if cache.has_resource(path):
		return AssetStatus.READY
	if cache.has_failed(path):
		return AssetStatus.FAILED
	return AssetStatus.MISSING

func get_asset_path(asset_id: String) -> String:
	return manifest.get_asset_path(asset_id)

func load_now(asset_id: String) -> Resource:
	var path: String = manifest.get_asset_path(asset_id)
	if path.is_empty():
		return null
	if cache.has_resource(path):
		return cache.get_resource(path)
	if cache.has_failed(path):
		return null

	var resource := ResourceLoader.load(path)
	if resource == null:
		cache.mark_failed(path, "ResourceLoader.load returned null")
		return null

	cache.put_resource(path, resource)
	return resource

func get_package_asset_ids(package_id: String) -> Array:
	return manifest.get_package_asset_ids(package_id)

func load_package_now(package_id: String) -> Dictionary:
	var result := {}
	for asset_id in manifest.get_package_asset_ids(package_id):
		var id := String(asset_id)
		result[id] = load_now(id)
	return result
