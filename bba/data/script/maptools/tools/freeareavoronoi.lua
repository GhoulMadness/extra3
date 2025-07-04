-- Vergleichsmethoden für Punkte
function PointComparer(point1, point2)
    if point1.x == point2.x then
        return point1.y > point2.y
    else
        return point1.x < point2.x
	end
end

-- Vergleichsmethoden für CircleEvents
function EventComparer(event1, event2)
    return event1.x < event2.x
end

-- Klasse für CircleEvent
CircleEvent = {}
CircleEvent.__index = CircleEvent

function CircleEvent:new(x, point, arc)
    local event = setmetatable({}, CircleEvent)
    event.x = x
    event.point = point
    event.arc = arc
    event.isValid = true
    return event
end

-- Klasse für ParabolaArc
ParabolaArc = {}
ParabolaArc.__index = ParabolaArc

function ParabolaArc:new(point, arc1, arc2)
    local arc = setmetatable({}, ParabolaArc)
    arc.point = point
    arc.previousArc = arc1
    arc.nextArc = arc2
    arc.circleEvent = nil
    arc.edge1 = nil
    arc.edge2 = nil
    return arc
end

-- Klasse für VoronoiEdge
VoronoiEdge = {}
VoronoiEdge.__index = VoronoiEdge
VoronoiEdge.edges = {}

function VoronoiEdge:new(point)
    local edge = setmetatable({}, VoronoiEdge)
    edge.point1 = point
    edge.point2 = {x = 0, y = 0}
    edge.isFinished = false
    table.insert(VoronoiEdge.edges, edge)
    return edge
end

function VoronoiEdge:Finish(point)
    if not self.isFinished then
        self.point2 = point
        self.isFinished = true
    end
end

-- Fortune Algorithmus
Fortune = {}
Fortune.__index = Fortune

function Fortune:new()
    local instance = setmetatable({}, Fortune)
    instance.root = nil
    instance.points = {}
    instance.circleEvents = {}
    return instance
end

function Fortune:ProcessPoint(x)
    local point = table.remove(self.points, 1) -- Entfernt den ersten Punkt
    self:AddNewArc(point, x) -- Fügt einen neuen Arc hinzu
end

function Fortune:ProcessCircleEvent()
    local circleEvent = table.remove(self.circleEvents, 1) -- Entfernt das erste CircleEvent
    if circleEvent.isValid then
        local edge = VoronoiEdge:new(circleEvent.point) -- Neue Kante erzeugen
        local arc = circleEvent.arc
        if arc.previousArc ~= nil then
            arc.previousArc.nextArc = arc.nextArc
            arc.previousArc.edge2 = edge
        end
        if arc.nextArc ~= nil then
            arc.nextArc.previousArc = arc.previousArc
            arc.nextArc.edge1 = edge
        end
        if arc.edge1 ~= nil then
            arc.edge1:Finish(circleEvent.point)
        end
        if arc.edge2 ~= nil then
            arc.edge2:Finish(circleEvent.point)
        end
        if arc.previousArc ~= nil then
            self:CheckCircleEvent(arc.previousArc, circleEvent.x)
        end
        if arc.nextArc ~= nil then
            self:CheckCircleEvent(arc.nextArc, circleEvent.x)
        end
    end
end
--[[
arc = self.root
while arc ~= nil do
    -- Hier kann der Code stehen, um mit dem arc-Element zu arbeiten
    arc = arc.nextArc
end
--]]
-- Diese Methode fügt einen neuen Parabelbogen mit dem gegebenen Brennpunkt hinzu
function Fortune:AddNewArc(point, x)
    if self.root == nil then
        self.root = ParabolaArc:new(point, nil, nil)
        return
    end
    local arc
    for arc = self.root; arc ~= nil; arc = arc.nextArc do
        local intersection1 = {x = 0, y = 0}
        local intersection2 = {x = 0, y = 0}
        if self:GetIntersection(point, arc, intersection1) then
            if arc.nextArc ~= nil and not self:GetIntersection(point, arc.nextArc, intersection2) then
                arc.nextArc.previousArc = ParabolaArc:new(arc.point, arc, arc.nextArc)
                arc.nextArc = arc.nextArc.previousArc
            else
                arc.nextArc = ParabolaArc:new(arc.point, arc, nil)
            end
            arc.nextArc.edge2 = arc.edge2
            arc.nextArc.previousArc = ParabolaArc:new(point, arc, arc.nextArc)
            arc.nextArc = arc.nextArc.previousArc
            arc = arc.nextArc
            arc.previousArc.edge2 = arc.edge1  -- Neue Kanten hinzufügen
            arc.nextArc.edge1 = arc.edge2
            self:CheckCircleEvent(arc, point.x)
            self:CheckCircleEvent(arc.previousArc, point.x)
            self:CheckCircleEvent(arc.nextArc, point.x)
            return
        end
    end
    for arc = self.root; arc.nextArc ~= nil; arc = arc.nextArc do end
    arc.nextArc = ParabolaArc:new(point, arc, nil)
    local start = {}
    start.x = x
    start.y = (arc.nextArc.point.y + arc.point.y) / 2
    arc.edge2 = arc.nextArc.edge1 = VoronoiEdge:new(start)
end
-- Diese Methode erzeugt wenn nötig ein neues CircleEvent für den gegebenen Parabelbogen
function Fortune:CheckCircleEvent(arc, _x)
    if arc.circleEvent ~= nil and arc.circleEvent.x ~= _x then
        arc.circleEvent.isValid = false
    end
    arc.circleEvent = nil
    if arc.previousArc == nil or arc.nextArc == nil then
        return
    end
    local x = 0
    local point = {x = 0, y = 0}
    if self:GetRightmostCirclePoint(arc.previousArc.point, arc.point, arc.nextArc.point, x, point) and x > _x then
        arc.circleEvent = CircleEvent:new(x, point, arc)  -- Neues CircleEvent erzeugen
        table.insert(self.circleEvents, arc.circleEvent)
        table.sort(self.circleEvents, function(a, b) return EventComparer(a, b) end)  -- Sortiert die Liste
    end
end
-- Bestimmt die x-Koordinate des Kreises durch die 3 Punkte und prüft, ob die 3 Punkte auf einer Geraden liegen
function Fortune:GetRightmostCirclePoint(point1, point2, point3, x, point)
    if (point2.x - point1.x) * (point3.y - point1.y) > (point3.x - point1.x) * (point2.y - point1.y) then
        return false
    end
    local x1 = point2.x - point1.x
    local y1 = point2.y - point1.y
    local a = 2 * (x1 * (point3.y - point2.y) - y1 * (point3.x - point2.x))
    if a == 0 then
        return false
    end
    local x2 = point3.x - point1.x
    local y2 = point3.y - point1.y
    local a1 = x1 * (point1.x + point2.x) + y1 * (point1.y + point2.y)
    local a2 = x2 * (point1.x + point3.x) + y2 * (point1.y + point3.y)
    point.x = (a1 * y2 - a2 * y1) / a
    point.y = (a1 - (x1 * point.x)) / (x1 + y1)
    x = point.x + math.sqrt((point1.x - point.x)^2 + (point1.y - point.y)^2)  -- x-Koordinate des Mittelpunkts plus Radius
    return true
end
-- Bestimmt den Schnittpunkt zwischen der Parabel mit dem gegebenen Brennpunkt und dem Parabelbogen
function Fortune:GetIntersection(point, arc, intersection)
    if arc.point.x == point.x then
        return false
    end
    local y1 = 0
    local y2 = 0

    if arc.previousArc ~= nil then
        y1 = self:GetParabolasIntersection(arc.previousArc.point, arc.point, point.x).y
    end
    if arc.nextArc ~= nil then
        y2 = self:GetParabolasIntersection(arc.point, arc.nextArc.point, point.x).y
    end
    if (arc.previousArc == nil or y1 <= point.y) and (arc.nextArc == nil or point.y <= y2) then
        intersection.y = point.y
        intersection.x = (arc.point.x^2 + (arc.point.y - intersection.y)^2 - point.x^2) / (2 * arc.point.x - 2 * point.x)
        return true
    end
    return false
end

-- Bestimmt den Schnittpunkt zwischen den Parabeln mit den gegebenen Brennpunkten
function Fortune:GetParabolasIntersection(point1, point2, x)
    local intersection = {x = 0, y = 0}
    local point = point1
    if point1.x == point2.x then
        intersection.y = (point1.y + point2.y) / 2
    elseif point2.x == x then
        intersection.y = point2.y
    elseif point1.x == x then
        intersection.y = point1.y
        point = point2
    else
        local x1 = 2 * (point1.x - x)
        local x2 = 2 * (point2.x - x)
        local a = 1 / x1 - 1 / x2
        local b = -2 * (point1.y / x1 - point2.y / x2)
        local c = (point1.y^2 + point1.x^2 - x^2) / x1 - (point2.y^2 + point2.x^2 - x^2) / x2
        intersection.y = (-b - math.sqrt(b^2 - 4 * a * c)) / (2 * a)
    end
    intersection.x = (point.x^2 + (point.y - intersection.y)^2 - x^2) / (2 * point.x - 2 * x)
    return intersection
end

-- Diese Methode stellt die benachbarten Kanten der Parabelbögen fertig
function Fortune:FinishEdges(x1, y1, x2, y2)
    local x = x2 + (x2 - x1) + (y2 - y1)  -- Verschiebt die Sweep Line
    for arc = self.root; arc.nextArc ~= nil; arc = arc.nextArc do
        if arc.edge2 ~= nil then
            arc.edge2:Finish(self:GetParabolasIntersection(arc.point, arc.nextArc.point, 2 * x))
        end
    end
end


-- Funktion zur Berechnung der tatsächlichen Zellgröße
function Fortune:GetCellSize(cell)
    -- Berechne die Größe der Zelle als Abstand zwischen benachbarten Zellen
    -- Hier könnte man verschiedene Methoden verwenden, wie z.B. den minimalen Abstand zwischen den Nachbarn.

    local center = cell.center
    local minDistance = 1/0

    for _, otherCell in ipairs(cell.neighbors) do
        -- Berechne den Abstand zwischen dem Mittelpunkt der Zelle und ihrer Nachbarzelle
        local dist = ComputeDistance(center, otherCell.center)
        if dist < minDistance then
            minDistance = dist
        end
    end

    return minDistance -- Dies könnte auch eine andere Methode zur Berechnung der Zellgröße sein
end


-- Funktion zur Berechnung des Voronoi-Diagramms
function CreateVoronoiDiagram(points)
    local fortune = Fortune:new()
    -- Beispielpunkte hinzufügen und verarbeiten
    fortune.points = points

    table.sort(fortune.points, PointComparer) -- Punkte sortieren

    -- Hauptverarbeitungsschleife
    while table.getn(fortune.points) > 0 do
        if table.getn(fortune.circleEvents) > 0 and fortune.circleEvents[1].x <= fortune.points[1].x then
            fortune:ProcessCircleEvent() -- Verarbeite CircleEvent
        else
            fortune:ProcessPoint(0) -- Verarbeitung des nächsten Punktes
        end
    end

    return fortune -- Rückgabe der Voronoi-Zellen
end

-- Funktion zur Berechnung der euklidischen Distanz
function ComputeDistance(point1, point2)
    return math.sqrt((point1.x - point2.x)^2 + (point1.y - point2.y)^2)
end

-- Klasse für die MainForm
MainForm = {}
MainForm.__index = MainForm
function MainForm.new()
    local self = setmetatable({}, MainForm)
    self.points = {}  -- Liste der Punkte
    self.x1 = 0
    self.y1 = 0
    self.x2 = 800
    self.y2 = 800
    self:GenerateRandomPoints(10)  -- Erzeugt 10 zufällige Punkte
    table.sort(self.points, function(a, b) return a.x < b.x end)  -- Sortiert die Punkte anhand der x-Koordinate
    local fortune = Fortune.new()  -- Erzeugt ein Objekt der Klasse Fortune
    for , point in ipairs(self.points) do
        fortune:AddPoint(point)  -- Fügt die Punkte dem Fortune-Objekt hinzu
    end
    -- Diese Schleife verarbeitet die Punkte und CircleEvents
    while table.getn(fortune.points) > 0 do
        if table.getn(fortune.circleEvents) > 0 and fortune.circleEvents[1].x <= fortune.points[1].x then
            fortune:ProcessCircleEvent()  -- Verarbeite CircleEvent
        else
            fortune:ProcessPoint()  -- Verarbeite den Punkt
        end
    end
    -- Verarbeite verbleibende CircleEvents
    while table.getn(fortune.circleEvents) > 0 do
        fortune:ProcessCircleEvent()
    end
    fortune:FinishEdges(self.x1, self.y1, self.x2, self.y2)  -- Kanten fertigstellen
    return self
end
function MainForm:GenerateRandomPoints(numberOfPoints)
    for i = 1, numberOfPoints do
        local point = { x = math.random() * (self.x2 - self.x1) + self.x1,
                        y = math.random() * (self.y2 - self.y1) + self.y1 }
        table.insert(self.points, point)  -- Fügt den Punkt zur Liste hinzu
    end
end
-- Beispielaufruf des MainForm
mainForm = MainForm.new()
