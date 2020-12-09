local lastTruck = 0

local labels = {
    {"REDNECK_HELP1", "~b~Instructional Buttons:~n~~w~Press ~INPUT_CONTEXT~ to ~g~open~w~ compartment doors.~n~Press ~INPUT_DETONATE~ to lift pioneers."},
    {"REDNECK_HELP2", "~b~Instructional Buttons:~n~~w~Press ~INPUT_CONTEXT~ to ~r~close~w~ compartment doors.~n~Press ~INPUT_DETONATE~ to lift pioneers."},
    {"REDNECK_HELP3", "~b~Instructional Buttons:~n~~w~Press ~INPUT_CONTEXT~ to ~g~open~w~ compartment doors.~n~Press ~INPUT_DETONATE~ to drop pioneers."},
    {"REDNECK_HELP4", "~b~Instructional Buttons:~n~~w~Press ~INPUT_CONTEXT~ to ~r~close~w~ compartment doors.~n~Press ~INPUT_DETONATE~ to drop pioneers."}
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
        end

        if IsPedInAnyVehicle(ped,true) == false then
            markerCoords = GetOffsetFromEntityInWorldCoords(lastTruck, -1.2, -4.75, 0.0)
            if GetDistanceBetweenCoords(pos,markerCoords) < 5 then
                if not IsVehicleDoorFullyOpen(lastTruck, 5) then
                    BeginTextCommandDisplayHelp(labels[1][1]) -- open compartment
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                else
                    BeginTextCommandDisplayHelp(labels[2][1]) -- close compartment
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                end
                if IsVehicleDoorFullyOpen(lastTruck, 5) then
                    if IsControlJustPressed(0, 51) then 
                        SetVehicleDoorShut(lastTruck, 5, false)
                    end
                else
                    if IsControlJustPressed(0, 51) then
                        SetVehicleDoorOpen(lastTruck, 5, false, false)
                    end
                end

                if IsVehicleDoorFullyOpen(lastTruck, 4) then
                    if IsControlJustPressed(0, 47) then
                        SetVehicleDoorShut(lastTruck, 4, false)
                    end
                else
                    if IsControlJustPressed(0, 47) then
                        SetVehicleDoorOpen(lastTruck, 4, false, false)
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