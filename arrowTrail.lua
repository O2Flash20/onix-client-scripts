-- CONTROLS
MaxXVelocity = 3.87
MaxYVelocity = 3.4
GravityAcceleration = 0.025
AirDrag = 0.99
--

name = "Arrow Hit"
description = "Shows where your arrow will hit"

showTrail = true
client.settings.addBool("Show arrow trail", "showTrail")
renderBehind = false
client.settings.addBool("Render behind", "renderBehind")
color = { 0, 255, 255 }
client.settings.addColor("Color", "color")

toggle = 90
client.settings.addKeybind("Enable/Disable Hotkey", "toggle")

importLib("renderthreeD")

enabled = true

function render3d()
    if enabled then
        px, py, pz = player.pposition()
        rx, ry = player.rotation()

        if renderBehind then gfx.renderBehind(true) end
        gfx.color(color.r, color.g, color.b, color.a)

        a1 = ry + 90
        x1 = math.sin(math.rad(a1))
        y1 = math.cos(math.rad(a1))
        xzVel = x1 * MaxXVelocity
        yVel = y1 * MaxYVelocity

        xVel = xzVel * math.sin(math.rad(rx + 180))
        zVel = xzVel * math.cos(math.rad(rx))

        xPos = px
        yPos = py
        zPos = pz

        res = 6

        foundHit = false

        for i = 1, res * 100, 1 do
            xPos = xPos + xVel / res
            yPos = yPos + yVel / res
            zPos = zPos + zVel / res

            if foundHit == false then
                if i % res == 0 and showTrail then
                    cube(xPos, yPos, zPos, 0.1)
                end

                currentBlock = dimension.getBlock(math.floor(xPos), math.floor(yPos), math.floor(zPos)).name
                if currentBlock ~= "air" then
                    cube(math.floor(xPos) - 0.025, math.floor(yPos) - 0.025, math.floor(zPos) - 0.025, 1.05)
                    foundHit = true
                end
            end

            if i % res == 0 then
                xVel = xVel * AirDrag
                zVel = zVel * AirDrag
                yVel = yVel - GravityAcceleration
            end
        end
    end
end

event.listen("KeyboardInput", function(key, down)
    if down and key == toggle then
        if enabled then
            enabled = false
        else
            enabled = true
        end
    end
end)
