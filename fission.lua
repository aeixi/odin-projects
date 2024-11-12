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
end

function reactorOFF ()
    setBurnRate()

    while energyLevel < 100 and state == 2 do
        if energyLevel == 100 then
            print('Energy full! Disabling reactor...')
            rednet.broadcast('Energy full! Disabling reactor...')
            reactor.scram()
            state = 0
        elseif heatedCoolantLevel > 25 then
            print('Coolant backup! Pausing reactor...')
            rednet.broadcast('Coolant backup! Pausing reactor...')
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
        print('Energy levels below 70%, activating reactor...')
        rednet.broadcast('Energy levels below 70%, activating reactor...')
        reactor.activate()
        state = 2
    end
end

while true do
    updateInfo()

    if not rednet.isOpen('left') then
        rednet.open('left')
    end

    if energyLevel >= 70 and not reactorStatus then
        print('Energy levels normal.')
        rednet.broadcast('Energy levels normal.')
        state = 1
    end

    parallel.waitForAny(reactorOFF, reactorON)
end
