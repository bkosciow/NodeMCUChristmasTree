led = require("triled")

led.pin_red = 1
led.pin_green = 2
led.pin_blue = 0

led.clear()

star_blue = 0
star_red = 0
star_green = 0

range_min = 10
range_max = 1020

range_step = 80

leds = {100, 100, 100, 100, 100, 100}
leds_to = {100, 100, 100, 100, 100, 100}

for k,v in pairs(leds) do
    pwm.setup(k+2, 500, 50)
    pwm.start(k+2)
end


local tick_random = tmr.create()
tick_random:register(1000, tmr.ALARM_AUTO, function (t)     
    for k,v in pairs(leds) do   
        v = v + range_step * math.random(-1, 1)
        if v < range_min then v = range_min end
        if v > range_max then v = range_max end
        leds[k] = v
        pwm.setduty(k+2, v)
        print(k+2,v)
    end
end)


local tick_easy = tmr.create()
tick_easy:register(100, tmr.ALARM_AUTO, function (t)     
    for k,v in pairs(leds) do  
        if leds[k] == leds_to[k] then 
            v = math.random(range_min, range_max)
            leds_to[k] = v
        end

        step = leds_to[k] - leds[k]
        if step > 0 and step > range_step then step = range_step end    
        if step < 0 and step * -1 > range_step then step = range_step * -1 end

        
        leds[k] = leds[k] + step
        if leds[k] < range_min then leds[k] = range_min end
        if leds[k] > range_max then leds[k] = range_max end
      
        pwm.setduty(k+2, leds[k])
        print(k+2, step, leds[k], leds_to[k])
    end
end)


tf = {true, false}
local star = tmr.create()
star:register(1000, tmr.ALARM_AUTO, function (t)
    star_blue = tf[math.random(1, 2)]
    star_green = tf[math.random(1, 2)]
    star_red = tf[math.random(1, 2)]
    if not star_blue and not star_red and not star_green then
        star_blue = true
        star_red = true
        star_green = true
    end
    print(star_blue, star_green, star_red)
    led.blue(star_blue)
    led.red(star_red)
    led.green(star_green)
end)

--tick_random:start()
tick_easy:start()
star:start()

