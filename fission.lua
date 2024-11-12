shell.run('clear')
reactor = peripheral.wrap('back')
turbine = peripheral.find('turbineValve')
state = 0

function setBurnRate ()
    local maxFlow = turbine.getMaxFlowRate()
    local maxOut = turbine.getMaxWaterOutput()

    local boilRate = 20000
    local coolant = reactor.getCoolant()
    if coolant['name'] == 'mekanism:sodium' then
        boilRate = 200000
    end

    reactor.setBurnRate(turbine.getFlowRate()/boilRate)
end

function updateInfo ()
    energyLevel = turbine.getEnergyFilledPercentage() * 100
    reactorStatus = reactor.getStatus()
    heatedCoolantLevel = reactor.getHeatedCoolantFilledPercentage() * 100
    fuelLevel = reactor.getFuelFilledPercentage() * 100
end

function reactorOFF ()
    setBurnRate()

    while energyLevel < 100 and state == 2 do
        if energyLevel == 100 then
            broadcast('Energy full! Disabling reactor...')
            reactor.scram()
            state = 0
        elseif heatedCoolantLevel > 25 then
            broadcast('Coolant backup! Pausing reactor...')
            reactor.scram()

            while heatedCoolantLevel > 0 do
                sleep(5)
            end

            reactor.activate()
        end
    end
end

function reactorON ()
    if energyLevel < 70 and state == 1 then
        broadcast('Energy levels below 70%, activating reactor...')
        reactor.activate()
        state = 2
    end
end

function broadcast(msg)
    print(msg)
    rednet.broadcast(msg)
end

while true do
    updateInfo()

    if not rednet.isOpen('left') then
        rednet.open('left')
    end

    if fuelLevel == 0 then
        broadcast('Fuel is empty!')
        if reactorStatus then
            broadcast('Shutting down reactor!')
            reactor.scram()
        end
    elseif fuelLevel <= 5 then
        broadcast('Fuel levels critical!')
    elseif fuelLevel <= 25 then
        broadcast('Fuel is below 25%!')
    elseif fuelLevel <= 50 then
        broadcast('Fuel is below 50%!')
    end

    if energyLevel >= 70 and not reactorStatus then
        broadcast('Energy levels normal.')
        state = 1
    elseif energyLevel < 70 then
        state = 1
    end

    parallel.waitForAny(reactorOFF, reactorON)

end
