RegisterCommand("guard", function(s)  bodyguard(0, "npcguards", true) end, false)
RegisterCommand("enemy", function(s)  bodyguard(5, "npcenemy", false) end, false)

local model = "s_m_m_prisguard_01"
local weapon = 'weapon_smg'
local ammo = 50
local health = 200
local accuracy = 50
local range = 2
local car

function bodyguard(what, guard, bg)
    local random = math.random(1,10)
    RequestModel(model) while not HasModelLoaded(model) do Wait(0) end
    SetPedRelationshipGroupHash(PlayerPedId(), 'PLAYER')
    AddRelationshipGroup(guard)
    
   
    local loc = GetRandomSpawnLocation(GetEntityCoords(PlayerPedId()), 6)
    local ground, z = GetGroundZFor_3dCoord(loc.x, loc.y, loc.z, 0)

    local enemy = CreatePed(4, model, loc.x+random, loc.y+random, z, 0, true, true)
    SetEntityHeading(enemy, loc.w)
    GiveWeaponToPed(enemy, weapon, ammo, 0, 1)
    SetCurrentPedWeapon(enemy, weapon, true)
    SetPedCombatAttributes(enemy, 46, true)
    SetPedCombatAttributes(enemy, 5, true)
    SetPedCombatAbility(enemy, 100)
    SetPedCombatMovement(enemy, 1)
    SetEntityHealth(enemy, health) 
    SetPedAccuracy(enemy, accuracy) 
    SetPedCombatRange(enemy, range)
    SetPedRelationshipGroupDefaultHash(enemy, guard)
    SetPedRelationshipGroupHash(enemy, guard)
    SetCanAttackFriendly(enemy, false, false)
    SetCanAttackFriendly(PlayerPedId(), false, false)
    SetRelationshipBetweenGroups(0, guard, guard)
    SetRelationshipBetweenGroups(what, guard, 'PLAYER')
    SetRelationshipBetweenGroups(what, 'PLAYER', guard)

    if bg then

        SetPedAsEnemy(enemy, false)

        while true do

            local dist = Vdist(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, GetEntityCoords(enemy).x, GetEntityCoords(enemy).y, GetEntityCoords(enemy).z)
            if dist < 4 then
                ClearPedTasks(enemy)
            else
                TaskFollowToOffsetOfEntity(enemy, PlayerPedId(), 0.0, 0.0, 0.0, 1.0, -1, 0.0, 1)
            end

            if DoesEntityExist(GetVehiclePedIsIn(PlayerPedId()), false) then
                local seat = FindAvailableVehicleSeat(car)
                TaskEnterVehicle(enemy, car, -1, seat, 1.0, 1, 0)
            end

            Wait(1000)  
        end
    else

        SetPedAsEnemy(enemy, true)
        TaskCombatPed(enemy, PlayerPedId(), 0, 16)

    end
end

function FindAvailableVehicleSeat(v)
    for seatIndex = -1, GetVehicleMaxNumberOfPassengers(v) do
        if not DoesEntityExist(GetPedInVehicleSeat(v, seatIndex)) then
            return seatIndex
        end
    end
    return nil 
end
function GetRandomSpawnLocation(c, min)
    local randomX = 0
    local randomY = 0
    repeat
        randomX = math.random(-min, min)
        randomY = math.random(-min, min)
    until math.sqrt(randomX * randomX + randomY * randomY) >= min
    local spawnX = c.x + randomX
    local spawnY = c.y + randomY
    local spawnZ = c.z
    return vector3(spawnX, spawnY, spawnZ)
end