--[[
    X - >, Y - V
    -> Input -> Previous map -> Step -> Repeat 

    Any live cell with fewer than two live neighbors dies, as if by underpopulation.
    Any live cell with two or three live neighbors lives on to the next generation.
    Any live cell with more than three live neighbors dies, as if by overpopulation.
    Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
]]--


local Conway = {}
Conway.__index = Conway

local function new(size)
    local self = {}
    self.size = size or Vector2.new(10, 10)

    self._map = {}
    self._tasks = {}
    self._input = {}


    setmetatable(self, Conway)

    return self
end

function Conway:AddCell(x, y)
    table.insert(self._input, Vector3.new(x, y, 1))
end

function Conway:KillCell(x, y)
    table.insert(self._input, Vector3.new(x, y, 0))
end

function Conway:GetMap()
    return self._map
end

function Conway:Step()
    local mapXSize, mapYSize = self.size.X, self.size.Y
    local mapBoxSize = mapXSize * mapYSize
    -- Process inputs
    for _, inputTask: Vector3 in self._input do
        local x, y, state = inputTask.X, inputTask.Y, inputTask.Z
        if (x > mapXSize) or (math.sign(x) == -1) or (y > mapYSize) or (math.sign(y) == -1) then
            warn(`Out Of Bounds {x}, {y}, state: {state}`)
            continue
        end
        self._map[x + (y * mapYSize)] = state == 1 or false
    end
    table.clear(self._input)
    -- clone map from previous step
    local map0 = {}
    for i, v in self._map do
        map0[i] = v
    end

    -- Add temporary cells around live cells in previous step
    local mapArea = {}
    for i, v in map0 do
        local v = i // mapXSize
        local u = i % mapXSize
        for x = u - 1, u + 1 do
            if (math.sign(x) == -1) or x > mapBoxSize then
                continue
            end
            for y = v - 1, v + 1 do
                local index = y * mapXSize + x
                if (math.sign(y) == -1) or y > mapBoxSize then
                    continue
                end

                mapArea[index] = map0[index] or false
            end
        end
    end

    table.clear(self._map)
    local map = self._map
    -- Calculate live cells
    for index, state in mapArea do
        local v = index // mapXSize
        local u = index % mapXSize

        local cellAdjacent = 0
        local cellState = state

        for x = u - 1, u + 1 do
            if (math.sign(x) == -1) or x > mapBoxSize then
                continue
            end
            for y = v - 1, v + 1 do
                if (math.sign(y) == -1) or y > mapBoxSize then
                    continue
                end
                local index1D = y * mapXSize + x

                if index1D == index then
                    continue
                end  
                cellAdjacent += mapArea[index1D] and 1 or 0
            end
        end
        
        if cellAdjacent < 2 then
            cellState = false
        elseif cellAdjacent == 3 then
            cellState = true
        elseif cellAdjacent > 3 then
            cellState = false
        end

        if cellState then
            map[index] = true
        end
    end
end

return setmetatable({
    new = new
}, {
    __index = Conway
})