json = require("json")
require("queue")
require('player')
local socket = require "socket"
local address, port = "localhost", 12345
udp = socket.udp()
udp:setpeername(address, port)
udp:settimeout(0)


function love.load()
	id = tostring(love.math.random(0, 10000))
	udp:send(json.encode({cmd="create", id=id}))
	data = udp:receive()
	udp:send(json.encode({cmd="force", id=id, x=love.math.random(-6, 6), y=love.math.random(-6, 6)}))
	data = udp:receive()
	q = Queue:create(2)
	P = Player:create()
end

function calculateMinDist(food)
	local minDist = 10000000
	local vector = Vector:create(0,0)
	local dist = 0
	for i = 1, #food do
		local foodCoord = Vector:create(food[i].x, food[i].y)
		local minVector = p.position - foodCoord
		local dist = minVector:mag()
		if minDist > dist then
			minDist = dist
			vector = minVector
		end
	end

	return vector
end


function processCmd(cmd)
	local result = {}
	if cmd == "info" then
		p.position = Vector:create(cmd.x, cmd.y)
	end
	if cmd == "env" then
		if p.position then
			local victimVec = calculateMinDist(cmd.food)
			victimVec:norm()
			victimVec:mul(3)
			result = {cmd="force", id=id, x=victimVec.x, y=victimVec.y}
		end	
	end

	return result
end


function love.update(dt)

	data = udp:receive()
	if data then
		data = json.decode(data)
		print(data.cmd)
		q:push(data)
	end
	if #q.list then
		while #q.list do
			local cmd = q:pop()
			print(cmd)
			local result = processCmd(cmd.cmd)
			udp:send(json.encode(result))
		end
	end
	udp:send(json.encode({cmd="info", id=id}))
	udp:send(json.encode({cmd="env",id=id}))
	love.timer.sleep(0.1)
end

function love.draw()

end


function love.keypressed(key)
	if key == "n" then
		udp:send(json.encode({cmd="create", id=id, color={0, 1, 0}}))
	end
	if key == "left" then
		udp:send(json.encode({cmd="force", id=id, x=-2, y=0}))
	end
	if key == "right" then
		udp:send(json.encode({cmd="force", id=id, x=2, y=0}))
	end
	if key == "up" then
		udp:send(json.encode({cmd="force", id=id, x=0, y=-2}))
	end
	if key == "down" then
		udp:send(json.encode({cmd="force", id=id, x=0, y=2}))
	end
	if key == "e" then
		udp:send(json.encode({cmd="env", id=id}))
	end
	if key == "i" then
		udp:send(json.encode({cmd="info", id=id}))
	end
end

function love.mousepressed(x, y, button)

end
