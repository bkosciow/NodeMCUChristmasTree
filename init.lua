print ("Booting..")
gpio.mode(0, gpio.INPUT, gpio.PULLUP)

if gpio.read(0) == 0 then
    print("..aborted")  
else    
   tmr.alarm(1, 3000, 0, function()
        print ("..launch..")           
        dofile("main.lua")        
    end)
    
end     
