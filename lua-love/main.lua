function to_radian(x) 
    return (x * math.pi/30.0) - math.pi/2.0
end

function to_hour(x) 
    return (x * 5) % 60
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function love.conf(t)
    t.console(true)
end

function love.load()
    h = 9
    m = 0
    s = 30
end

function love.update(dt) 
    time = mysplit(os.date("%H %M %S"))
    h = time[1]
    m = time[2]
    s = time[3]
end

function love.draw()
    width, height = love.graphics.getDimensions()
    radius = math.min(width, height)/4
    center_x, center_y = width/2, height/2
    love.graphics.circle('line', center_x, center_y, radius)
    hands_sizes = {{value=to_hour(h), size=0.5}, {value=m, size=0.75}, {value=s, size=0.9}}
    for i=1, #hands_sizes do
        love.graphics.line(center_x, 
            center_y, 
            center_x + hands_sizes[i].size * radius * math.cos(to_radian(hands_sizes[i].value)), 
            center_y + hands_sizes[i].size * radius * math.sin(to_radian(hands_sizes[i].value)))
    end
end