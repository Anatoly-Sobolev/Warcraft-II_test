extends SceneTree

const DEFAULT_SOURCE_ROOT := "res://../external/wargus_extracted"
const DEFAULT_OUTPUT_ROOT := "res://"

const ATLAS_RECIPES := {
	"content/assets/textures/units/alliance_units_atlas.png": {
		"columns": 2,
		"cell": Vector2i(420, 260),
		"background": Color("#202835"),
		"items": [
			"graphics/human/units/peasant.png",
			"graphics/human/units/peasant_with_gold.png",
			"graphics/human/units/peasant_with_wood.png",
			"graphics/human/units/footman.png",
			"graphics/human/units/elven_archer.png",
			"graphics/human/units/knight.png",
			"graphics/human/units/mage.png",
			"graphics/human/units/ballista.png",
		],
	},
	"content/assets/textures/units/horde_units_atlas.png": {
		"columns": 2,
		"cell": Vector2i(420, 260),
		"background": Color("#352222"),
		"items": [
			"graphics/orc/units/peon.png",
			"graphics/orc/units/peon_with_gold.png",
			"graphics/orc/units/peon_with_wood.png",
			"graphics/orc/units/grunt.png",
			"graphics/orc/units/troll_axethrower.png",
			"graphics/orc/units/ogre.png",
			"graphics/orc/units/death_knight.png",
			"graphics/orc/units/catapult.png",
		],
	},
	"content/assets/textures/buildings/alliance_buildings_atlas.png": {
		"columns": 4,
		"cell": Vector2i(160, 150),
		"background": Color("#1f3347"),
		"items": [
			"graphics/tilesets/summer/human/buildings/town_hall.png",
			"graphics/tilesets/summer/human/buildings/farm.png",
			"graphics/tilesets/summer/human/buildings/barracks.png",
			"graphics/tilesets/summer/human/buildings/elven_lumber_mill.png",
			"graphics/tilesets/summer/human/buildings/blacksmith.png",
			"graphics/tilesets/summer/human/buildings/guard_tower.png",
			"graphics/tilesets/summer/neutral/buildings/gold_mine.png",
			"graphics/neutral/buildings/land_construction_site.png",
		],
	},
	"content/assets/textures/buildings/horde_buildings_atlas.png": {
		"columns": 4,
		"cell": Vector2i(160, 150),
		"background": Color("#3d2521"),
		"items": [
			"graphics/tilesets/summer/orc/buildings/great_hall.png",
			"graphics/tilesets/summer/orc/buildings/pig_farm.png",
			"graphics/tilesets/summer/orc/buildings/barracks.png",
			"graphics/tilesets/summer/orc/buildings/troll_lumber_mill.png",
			"graphics/tilesets/summer/orc/buildings/blacksmith.png",
			"graphics/tilesets/summer/orc/buildings/watch_tower.png",
			"graphics/tilesets/summer/neutral/buildings/gold_mine.png",
			"graphics/neutral/buildings/land_construction_site.png",
		],
	},
	"content/assets/textures/effects/projectiles_atlas.png": {
		"columns": 4,
		"cell": Vector2i(80, 80),
		"background": Color("#1f1c24"),
		"items": [
			"graphics/missiles/arrow.png",
			"graphics/missiles/axe.png",
			"graphics/missiles/ballista_bolt.png",
			"graphics/missiles/catapult_rock.png",
			"graphics/missiles/fireball.png",
			"graphics/missiles/cannon.png",
			"graphics/missiles/dragon_breath.png",
			"graphics/missiles/gryphon_hammer.png",
		],
	},
	"content/assets/textures/effects/effects_atlas.png": {
		"columns": 4,
		"cell": Vector2i(96, 96),
		"background": Color("#211d30"),
		"items": [
			"graphics/missiles/explosion.png",
			"graphics/missiles/ballista-catapult_impact.png",
			"graphics/missiles/heal_effect.png",
			"graphics/missiles/blizzard.png",
			"graphics/missiles/rune.png",
			"graphics/missiles/flame_shield.png",
			"graphics/missiles/death_and_decay.png",
			"graphics/missiles/tornado.png",
		],
	},
	"content/assets/textures/ui/ui_atlas.png": {
		"columns": 2,
		"cell": Vector2i(360, 220),
		"background": Color("#20222c"),
		"items": [
			"graphics/ui/buttons_1.png",
			"graphics/ui/buttons_2.png",
			"graphics/ui/gold,wood,oil,mana.png",
			"graphics/ui/human/panel_1.png",
			"graphics/ui/human/buttonpanel.png",
			"graphics/ui/human/infopanel.png",
			"graphics/ui/human/menubutton.png",
			"graphics/ui/human/statusline.png",
		],
	},
	"content/assets/textures/portraits/portraits_atlas.png": {
		"columns": 2,
		"cell": Vector2i(220, 180),
		"background": Color("#282033"),
		"items": [
			"campaigns/human/interface/introscreen1.png",
			"campaigns/human/interface/introscreen2.png",
			"campaigns/orc/interface/introscreen1.png",
			"campaigns/orc/interface/introscreen2.png",
		],
	},
}

const COPY_RECIPES := {
	"content/assets/textures/terrain/forest_atlas.png": "graphics/tilesets/summer/terrain/summer.png",
	"content/assets/textures/terrain/winter_atlas.png": "graphics/tilesets/winter/terrain/winter.png",
	"content/assets/textures/terrain/wasteland_atlas.png": "graphics/tilesets/wasteland/terrain/wasteland.png",
	"content/assets/textures/terrain/other_world_atlas.png": "graphics/tilesets/swamp/terrain/swamp.png",
}

func _init() -> void:
	var source_root := _get_arg("--source-root", DEFAULT_SOURCE_ROOT)
	var output_root := _get_arg("--output-root", DEFAULT_OUTPUT_ROOT)
	var failed := 0

	for output_path in ATLAS_RECIPES.keys():
		var recipe: Dictionary = ATLAS_RECIPES[output_path]
		var error := _build_atlas(source_root, output_root, output_path, recipe)
		if error != OK:
			failed += 1

	for output_path in COPY_RECIPES.keys():
		var error := _copy_image(source_root, output_root, COPY_RECIPES[output_path], output_path)
		if error != OK:
			failed += 1

	quit(failed)

func _get_arg(name: String, default_value: String) -> String:
	var args := OS.get_cmdline_user_args()
	for index in args.size():
		if args[index] == name and index + 1 < args.size():
			return args[index + 1]
	return default_value

func _build_atlas(source_root: String, output_root: String, output_path: String, recipe: Dictionary) -> Error:
	var items: Array = recipe["items"]
	var columns: int = recipe["columns"]
	var cell: Vector2i = recipe["cell"]
	var rows := int(ceil(float(items.size()) / float(columns)))
	var atlas := Image.create(columns * cell.x, rows * cell.y, false, Image.FORMAT_RGBA8)
	atlas.fill(recipe["background"])

	for index in items.size():
		var source_rel := String(items[index])
		var image := Image.load_from_file(_join(source_root, source_rel))
		if image == null:
			push_error("Missing placeholder source: %s" % source_rel)
			return ERR_FILE_NOT_FOUND

		var max_size := cell - Vector2i(8, 8)
		var scale = min(float(max_size.x) / float(image.get_width()), float(max_size.y) / float(image.get_height()))
		if scale > 1.0:
			scale = 1.0
		var draw_size := Vector2i(max(1, int(image.get_width() * scale)), max(1, int(image.get_height() * scale)))
		image.resize(draw_size.x, draw_size.y, Image.INTERPOLATE_NEAREST)

		var column := index % columns
		var row := index / columns
		var position := Vector2i(column * cell.x, row * cell.y) + ((cell - draw_size) / 2)
		atlas.blit_rect(image, Rect2i(Vector2i.ZERO, draw_size), position)

	return atlas.save_png(_join(output_root, output_path))

func _copy_image(source_root: String, output_root: String, source_path: String, output_path: String) -> Error:
	var image := Image.load_from_file(_join(source_root, source_path))
	if image == null:
		push_error("Missing placeholder source: %s" % source_path)
		return ERR_FILE_NOT_FOUND
	return image.save_png(_join(output_root, output_path))

func _join(root: String, relative_path: String) -> String:
	if root.ends_with("/"):
		return root + relative_path
	return root + "/" + relative_path
