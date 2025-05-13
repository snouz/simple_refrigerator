function isfridge(entity)
    if entity and (entity.name == "simple_refrigerator") then
        return true
    else
        return false
    end
end

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

-- Register event for when a refrigerator is built
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(event)
    local entity = event.created_entity or event.entity
    if isfridge(entity) then
        place_smoke_entity(entity)
    end
end)

-- Register event for when a refrigerator is removed
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(event)
    local entity = event.entity
    if isfridge(entity) then
        remove_smoke_entity(entity)
    end
end)





-- from fridge mod