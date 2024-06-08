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
    -- clone map from previous step
    local map0 = {}
    for i, v in self._map do
        map0[i] = v
    end

    -- Add temporary cells around live cells in previous step
    local mapArea = {}
    for i, v in map0 do
        for x = i - 1, i + 1 do
            if (math.sign(x) == -1) or x > mapBoxSize then
                continue
            end
            for y = x - mapXSize, x + mapXSize, mapXSize do
                if (math.sign(y) == -1) or y > mapBoxSize then
                    continue
                end

                if x == i and y // mapXSize == i // mapXSize then
                    mapArea[i] = true
                    continue
                end

                local index = y * mapXSize + x
                mapArea[index] = map0[index] or 0
            end
        end
    end

    table.clear(self._map)
    local map = self._map
    -- Calculate live cells
    for index, v in mapArea do
        local cellAdjacent = 0
        local cellState = mapArea[index]

        for x = index - 1, index + 1 do
            if (math.sign(x) == -1) or x > mapBoxSize then
                continue
            end
            for y = x - mapXSize, x + mapXSize, mapXSize do
                if (math.sign(y) == -1) or y > mapBoxSize then
                    continue
                end
                if x == index and y // mapXSize == index // mapXSize then
                    continue
                end                
                local indexAdjacent = y * mapXSize + x
                cellAdjacent += mapArea[indexAdjacent] and 1 or 0
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