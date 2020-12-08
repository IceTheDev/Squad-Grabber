local lastTruck = 0
local lastVeh = 0
local lastTruckCoords = vector3(0,0,0)
local r,g,b = 255,0,0

local labels = {
    {"REDNECK_HELP1", "Press ~INPUT_CONTEXT~ to ~g~open~w~ compartment doors.~n~Press ~INPUT_FRONTEND_SELECT~ to lift pioneers."},
    {"REDNECK_HELP2", "Press ~INPUT_CONTEXT~ to ~r~close~w~ compartment doors.~n~Press ~INPUT_FRONTEND_SELECT~ to drop pioneers."}
}


local vehs = {}
for k,v in ipairs(config.squad_vehicle) do
    table.insert(vehs, GetHashKey(v))
end

Citizen.CreateThread(function()

    for i = 1, #labels do
		AddTextEntry(labels[i][1], labels[i][2])
	end

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
                    BeginTextCommandDisplayHelp(labels[1][1])
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                else
                    BeginTextCommandDisplayHelp(labels[2][1])
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                end
                if GetDistanceBetweenCoords(markerCoords,pos) < 10 then
                    if IsVehicleDoorFullyOpen(lastTruck, 2) and IsVehicleDoorFullyOpen(lastTruck, 3) then
                        if IsControlPressed(0, 51) then 
                            SetVehicleDoorShut(lastTruck, 2, true)
                            SetVehicleDoorShut(lastTruck, 3, true)
                        end
                    else
                        if IsControlPressed(0, 51) then
                            SetVehicleDoorOpen(lastTruck, 2, false, false)
                            SetVehicleDoorOpen(lastTruck, 3, false, false)
                        end
                    end

                    if IsVehicleDoorFullyOpen(lastTruck, 5) then
                        if IsControlPressed(0, 217) then
                            SetVehicleDoorShut(lastTruck, 5, true)
                        end
                    else
                        if IsControlPressed(0, 217) then
                            SetVehicleDoorOpen(lastTruck, 5, false, false)
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