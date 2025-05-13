local item_sounds = require("__base__.prototypes.item_sounds")
require ("sound-util")
require ("circuit-connector-sprites")
require ("util")

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local meld = require("meld")
local procession_graphic_catalogue_types = require("__base__/prototypes/planet/procession-graphic-catalogue-types")



data:extend({
  {
    type = "item",
    name = "simple_refrigerator",
    icon = "__simple_refrigerator__/graphics/icons/simple_refrigerator.png",
    subgroup = "logistic-network",
    color_hint = { text = "B" },
    order = "b[storage]-f[simple_refrigerator]",
    inventory_move_sound = item_sounds.mechanical_inventory_move,
    pick_sound = item_sounds.mechanical_inventory_pickup,
    drop_sound = item_sounds.mechanical_inventory_move,
    place_result = "simple_refrigerator",
    stack_size = 20,
    default_import_location = "aquilo",
    weight = 50 * kg
  },



  {
    type = "recipe",
    name = "simple_refrigerator",
    energy_required = 30,
    category = "cryogenics",
    ingredients =
    {
      --{type = "item", name = "refined-concrete", amount = 10},
      {type = "fluid", name = "fluoroketone-cold", amount = 50},
      {type = "item", name = "foundation", amount = 5},
      --{type = "item", name = "quantum-processor", amount = 1},
      {type = "item", name = "fusion-reactor-equipment", amount = 1},
      {type = "item", name = "buffer-chest", amount = 1},
    },
    results = {{type = "item", name = "simple_refrigerator", amount = 1}},
    allow_productivity = false,
    enabled = false,
    surface_conditions = -- aquilo only
    {
      {
        property = "pressure",
        min = 100,
        max = 600
      }
    },
  },


  {
    type = "technology",
    name = "simple_refrigerator",
    icon_size = 256,
    icon = "__simple_refrigerator__/graphics/technology/simple_refrigerator-tech.png",
    effects = 
    {
      {
        type = "unlock-recipe",
        recipe = "simple_refrigerator"
      },
    },
    prerequisites = {"foundation", "fusion-reactor-equipment"},
    unit =
    {
      count_formula = "2500",
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
        {"agricultural-science-pack", 1},
        {"electromagnetic-science-pack", 1},
        {"cryogenic-science-pack", 1}
      },
      time = 60
    }
    --upgrade = true,
    --order = "e-c-c-b"
  },




  {
    type = "logistic-container",
    name = "simple_refrigerator",
    icon = "__simple_refrigerator__/graphics/icons/simple_refrigerator.png",
    flags = {"placeable-player", "player-creation"},
    minable = {mining_time = 0.2, result = "simple_refrigerator"},
    max_health = 550,
    corpse = "medium-small-remnants",
    dying_explosion = "buffer-chest-explosion",
    collision_box = {{-0.85, -0.85}, {0.85, 0.85}},
    selection_box = {{-1, -1}, {1, 1}},
    damaged_trigger_effect = hit_effects.entity(),
    surface_conditions =
    {
      {
        property = "gravity",
        min = 1
      }
    },
    resistances =
    {
      {
        type = "fire",
        percent = 10
      },
      {
        type = "impact",
        percent = 60
      }
    },
    working_sound =
    {
      sound =
      {
        filename = "__simple_refrigerator__/sound/fridge.ogg",
        volume = 0.6,
        speed_smoothing_window_size = 60,
        audible_distance_modifier = 0.8,
      },
      --match_speed_to_activity = true,
      max_sounds_per_prototype = 2,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },
    fast_replaceable_group = "simple_refrigerator",
    inventory_size = 24,
    icon_draw_specification = {scale = 0.7},
    trash_inventory_size = 20,
    logistic_mode = "buffer",
    open_sound = sounds.metallic_chest_open,
    close_sound = sounds.metallic_chest_close,
    animation_sound = sounds.logistics_chest_open,
    impact_category = "metal",
    opened_duration = logistic_chest_opened_duration,
    animation =
    {
      layers =
      {
        {
          filename = "__simple_refrigerator__/graphics/entity/simple_refrigerator-base.png",
          priority = "extra-high",
          width = 256,
          height = 256,
          repeat_count = 7,
          shift = util.by_pixel(0, 0),
          scale = 0.5
        },
        {
          filename = "__simple_refrigerator__/graphics/entity/simple_refrigerator-door.png",
          priority = "extra-high",
          width = 66,
          height = 30,
          frame_count = 7,
          shift = util.by_pixel(0, -10),
          scale = 0.5
        },
        {
          filename = "__simple_refrigerator__/graphics/entity/simple_refrigerator-shadow.png",
          priority = "extra-high",
          width = 256,
          height = 256,
          repeat_count = 7,
          shift = util.by_pixel(0, 0),
          draw_as_shadow = true,
          scale = 0.5
        }
      }
    },
    circuit_connector = circuit_connector_definitions["chest"],
    circuit_wire_max_distance = default_circuit_wire_max_distance
  },


{
    type = "simple-entity",
    name = "simple_refrigerator_smoke_effect",
    flags = {"not-on-map", "not-selectable-in-game", "not-rotatable", "not-blueprintable", "hide-alt-info"},
    icon = "__simple_refrigerator__/graphics/icons/simple_refrigerator.png",
    --subgroup = "grass",
    --order = "e[simple-cottage]",
    hidden = true,
    hidden_in_factoriopedia = true,
    --collision_box = {{-1.0, -1.0}, {1.0, 1.0}},
    --selection_box = {{-1.0, -1.0}, {1.0, 1.0}},
    drawing_box_vertical_extension = 1,
    --damaged_trigger_effect = hit_effects.rock(),
    --dying_trigger_effect = decorative_trigger_effects.huge_rock(),
    --minable =
    --{
    --  mining_particle = "stone-particle",
    --  mining_time = 1,
    --  results = {}
    --},
    --map_color = {169, 68, 46, 200},
    --count_as_rock_for_filtered_deconstruction = true,
    --mined_sound = sounds.deconstruct_bricks(1.0),
    --impact_category = "stone",
    --render_layer = "object",
    max_health = 70,
    --resistances =
    --{
    --  { type = "poison",  percent = 100 },
    --},
    animations = {
      layers =
      {
        {
          filename = "__simple_refrigerator__/graphics/entity/simple_refrigerator-smoke-effect.png",
          priority = "extra-high",
          width = 256,
          height = 256,
          frame_count = 60,
          line_length = 8,
          shift = util.by_pixel(0, -6),
          scale = 0.5,
          animation_speed = 0.15,
          blend_mode = "additive"
        },
      }
    },
    render_layer = "higher-object-under"
  },


})