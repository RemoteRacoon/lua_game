Queue = {}
Queue.__index = Queue

function Queue:create(n)
  local queue = {}
  setmetatable(queue, Queue)
  queue.size = n
  queue.list = {}
  return queue
end

function Queue:push(cmd)
  local currIn = #self.list + 1
  if currIn < self.size then
    table.insert(self.list, cmd)
  end
end

function Queue:pop()
  local value = self.list[1]
  table.remove(self.list, 1)
  return value
end