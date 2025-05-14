
function place_smoke_entity(refrigerator)
  local surface = refrigerator.surface
  local position = refrigerator.position
  local smokeeffect = "simple_refrigerator_smoke_effect"
  
  local existing_smokes = surface.find_entities_filtered{position = position, name = smokeeffect}
  if #existing_smokes == 0 then
    surface.create_entity{name = smokeeffect, position = position, force = refrigerator.force}
  end
end

function remove_smoke_entity(refrigerator)
  local surface = refrigerator.surface
  local position = refrigerator.position
  local smokeeffect = "simple_refrigerator_smoke_effect"
  
  -- Find and remove the hidden pole
  local smokes = surface.find_entities_filtered{position = position, name = smokeeffect}
  for _, smoke in pairs(smokes) do
    smoke.destroy()
  end
end


-------------------------------------------------------------------
-- from fridge by LightningMaster
-- @author LightningMaster, modified by snouz
-- @license MIT
-- @copyright 2025

local freeze_rates = settings.global["simple_refrigerator-freeze-rate"].value

local function remove_item(tbl, item)
  local new_tbl = {}
  if type(tbl) == "table" then
    -- If input is array-like table
    if #tbl > 0 then
      for _, v in ipairs(tbl) do
        if v ~= item then
          table.insert(new_tbl, v)
        end
      end
    -- If input is dictionary-like table
    else
      for k, v in pairs(tbl) do
        if k ~= item then
          new_tbl[k] = v
        end
      end
    end
  end
  return new_tbl
end

local function init_storages()
  storage.simple_refrigerator = storage.simple_refrigerator or {}
end

local function check_fridges(recover_number)
  -- Process each refrigerator in storage
  for _, fridge in pairs(storage.simple_refrigerator) do
    -- Verify refrigerator is still valid
    if fridge and fridge.valid then
      -- Get refrigerator inventory
      local inv = fridge.get_inventory(defines.inventory.chest)
      
      --local quality = fridge.quality
      --local quality_multiplier = 0
      --if quality and quality.level and quality.level ~= 0 then
      --  quality_multiplier = quality_multiplier + (quality.level / 2)
      --end

      --fridge.force.print("quality_multiplier " .. quality_multiplier .. " recover_number " .. recover_number)
      
      
      -- Process each item in the inventory
      for i = 1, #inv do
        local itemStack = inv[i]
        -- Check if item exists and can spoil
        if itemStack and itemStack.valid_for_read and itemStack.spoil_tick > 0 then
          -- Extend spoilage time while respecting maximum duration
          local max_spoil_time = game.tick + itemStack.prototype.get_spoil_ticks(itemStack.quality) - 3
          itemStack.spoil_tick = math.min(
            itemStack.spoil_tick + recover_number, -- + math.floor((freeze_rates - 1) * quality_multiplier),-- quality_multiplier, --) * quality_multiplier,
            max_spoil_time
          )
          --fridge.force.print("itemStack.spoil_tick " .. itemStack.spoil_tick .. " | max_spoil_time" .. max_spoil_time)
        end
      end
    else
      -- Remove invalid refrigerator from storage
      storage.simple_refrigerator = remove_item(storage.simple_refrigerator, unit_number)
    end
  end
end

local function on_tick(event)

      --local quality = fridge.quality
      --local quality_multiplier = 1
      --if quality and quality.level and quality.level ~= 0 then
      --  quality_multiplier = quality_multiplier + (quality.level / (recover_number * 4))
      --end
  if storage.simple_refrigerator ~= {} then
    --if freeze_rates < 10 then -- avoiding hurt too much of ups
      if game.tick%(10 * freeze_rates) == 0 then
        check_fridges((freeze_rates - 1) * 10)
      end
    --elseif freeze_rates < 15 then
    --  if game.tick%(15 * freeze_rates) == 0 then
    --    check_fridges((freeze_rates - 1) * 15)
    --  end
    --elseif game.tick%freeze_rates == 0 then
    --  check_fridges(freeze_rates - 1)
    --end
  end
end

local function OnEntityCreated(event)
  -- Get entity from either player or script creation
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid) then return end
  
  -- Handle entity based on type
  if entity.name == "simple_refrigerator" then
    -- Register basic or logistic refrigerator
    storage.simple_refrigerator[entity.unit_number] = entity
    place_smoke_entity(entity)
  end
end

local function OnEntityRemoved(event)
  -- Verify entity is valid
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid) then return end
  
  -- Handle entity based on type
  if entity.name == "simple_refrigerator" then
    -- Remove refrigerator from storage
    storage.simple_refrigerator = remove_item(storage.simple_refrigerator, entity.unit_number)
    remove_smoke_entity(entity)
  end
end

local function init_settings()
  freeze_rates = settings.global["simple_refrigerator-freeze-rate"].value
end

local function init_entities()
  storage.simple_refrigerator = {}

  for _, surface in pairs(game.surfaces) do
    local refrigerators = surface.find_entities_filtered{name = {"simple_refrigerator"}}
    for _, fridge in pairs(refrigerators) do
      storage.simple_refrigerator[fridge.unit_number] = fridge
    end
  end
end

local function init_events()
  -- Define entity filter for all preservation-related entities
  local entity_filter = {{filter = "name", name = "simple_refrigerator"}}

  -- Register entity creation events
  local creation_events = {
    defines.events.on_built_entity,        -- Player built
    defines.events.on_entity_cloned,       -- Entity copied
    defines.events.on_robot_built_entity,    -- Robot built
    defines.events.on_space_platform_built_entity, -- Space platform
    defines.events.script_raised_built,      -- Script created
    defines.events.script_raised_revive      -- Entity revived
  }
  for _, event in pairs(creation_events) do
    script.on_event(event, OnEntityCreated, entity_filter)
  end
  
  -- Register entity removal events
  local removal_events = {
    defines.events.on_player_mined_entity,     -- Player removed
    defines.events.on_robot_mined_entity,      -- Robot removed
    defines.events.on_space_platform_mined_entity, -- Space platform
    defines.events.on_entity_died,         -- Entity destroyed
    defines.events.script_raised_destroy       -- Script removed
  }
  for _, event in pairs(removal_events) do
    script.on_event(event, OnEntityRemoved, entity_filter)
  end
  
  -- Register update events
  script.on_event(defines.events.on_tick, on_tick)
  script.on_event(defines.events.on_runtime_mod_setting_changed, init_settings)
end

---- Script Lifecycle Handlers ----

-- Handle mod loading (called when save is loaded)
script.on_load(function()
  init_events()
end)

-- Handle initial mod setup (called when mod is first added to save)
script.on_init(function()
  init_storages()
  init_entities()
  init_events()
end)

-- Handle mod configuration changes
script.on_configuration_changed(function(data)
  init_settings()
  init_entities()
  init_events()
end)
