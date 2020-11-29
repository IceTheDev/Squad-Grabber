local lastTruck = 0
local lastVeh = 0
local lastTruckCoords = vector3(0,0,0)
local r,g,b = 255,0,0

local vehs = {}
for k,v in ipairs(config.squad_vehicle) do
    table.insert(vehs, GetHashKey(v))
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, true)
        local pos = GetEntityCoords(ped)

        if veh and has_value(vehs, GetEntityModel(veh)) then
           lastTruck = veh
           
           lastTruckCoords = GetEntityCoords(lastTruck)
        else
            lastVeh = veh
        end

        if IsPedInAnyVehicle(ped,true) == false then
            markerCoords = GetOffsetFromEntityInWorldCoords(lastTruck, -1.2, -4.75, 0.0)
            if GetDistanceBetweenCoords(pos,markerCoords) < 5 then
                if not IsVehicleDoorFullyOpen(lastTruck, 2) and not IsVehicleDoorFullyOpen(lastTruck, 3) then
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
                    Citizen.InvokeNative(0x5F68520888E69014, config.labelText)
                    Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, false, -1)
                else
                    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
                    Citizen.InvokeNative(0x5F68520888E69014, config.labelText2)
                    Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, false, -1)
                end
                if GetDistanceBetweenCoords(markerCoords,pos) < 5 then
                    if IsVehicleDoorFullyOpen(lastTruck, 2) and IsVehicleDoorFullyOpen(lastTruck, 3) then
                        print("NO IM WIDE OPEN, LIKE WAY OPEN")
                        if IsControlPressed(0, 51) then 
                            SetVehicleDoorShut(lastTruck, 2, true)
                            SetVehicleDoorShut(lastTruck, 3, true)
                        end
                    else
                        print("YES I AM CLOSED")
                        if IsControlPressed(0, 51) then
                            SetVehicleDoorOpen(lastTruck, 2, false, false)
                            SetVehicleDoorOpen(lastTruck, 3, false, false)
                        end
                    end
                end
            end         
        end
        Wait(0)
    end
end)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end