function Fortune:AddNewArc(point, x)
    -- Die Wurzel des aktuellen Parabelbaums
    local currentArc = self.root
    local newArc = ParabolaArc:new(point, nil, nil)

    -- Wenn der Baum leer ist, setze die Wurzel auf den neuen Bogen
    if not currentArc then
        self.root = newArc
        return
    end

    -- Durchlaufen des Baums um den richtigen Platz zum Einfügen des neuen Bogens zu finden
    while true do
        -- Berechne den Schnittpunkt für den aktuellen Bogen
        local intersection = self:GetIntersection({x = x, y = 0}, currentArc)

        -- Wenn der Schnittpunkt nicht existiert, gehe weiter
        if not intersection then
            -- Überprüfen, ob der aktuelle Bogen zur linken oder rechten Seite des neuen Bogens gehört
            if currentArc.previousArc and currentArc.previousArc.point.x < point.x then
                -- Gehe nach rechts
                if currentArc.nextArc then
                    currentArc = currentArc.nextArc
                else
                    -- Setze die nächste Verbindung des aktuellen Bogens auf den neuen Bogen
                    currentArc.nextArc = newArc
                    newArc.previousArc = currentArc
                    break
                end
            else
                -- Gehe nach links
                if currentArc.previousArc then
                    currentArc = currentArc.previousArc
                else
                    -- Setze die vorherige Verbindung des aktuellen Bogens auf den neuen Bogen
                    currentArc.previousArc = newArc
                    newArc.nextArc = currentArc
                    self.root = newArc -- neuer Bogen wird zur Wurzel
                    break
                end
            end
        else
            -- Wenn ein Schnittpunkt existiert, müssen wir den aktuellen Bogen zerlegen und einen neuen erstellen
            local leftArc = ParabolaArc:new(currentArc.point, currentArc.previousArc, newArc)
            local rightArc = ParabolaArc:new(point, leftArc, currentArc.nextArc)

            leftArc.nextArc = currentArc
            newArc.previousArc = leftArc
            newArc.nextArc = rightArc

            if currentArc.previousArc then
                currentArc.previousArc.nextArc = leftArc
            else
                self.root = leftArc -- Neuer Bogen wird zur Wurzel, wenn es keinen vorherigen Bogen gibt
            end

            currentArc.previousArc = leftArc
            currentArc.point = point -- Aktualisiere den aktuellen Bogen mit den neuen Werten
            break
        end
    end
end

function Fortune:CheckCircleEvent(arc, x)
    -- Berechne den vorherigen und den nächsten Bogen
    local previousArc = arc.previousArc
    local nextArc = arc.nextArc

    -- Überprüfen, ob sowohl der vorherige als auch der nächste Bogen existieren
    if not previousArc or not nextArc then
        return -- Keine Möglichkeit für ein CircleEvent, da wir nicht genug Bögen haben
    end

    -- Berechne die Punkte
    local p1 = previousArc.point
    local p2 = arc.point
    local p3 = nextArc.point

    -- Berechne den Mittelpunkt des umschreibenden Kreises (circumcircle)
    local center = self:GetCircumcenter(p1, p2, p3)
    if not center then
        return -- Ungültige Punkte, kein Kreis kann gebildet werden
    end

    local circleX = center.x
    -- Überprüfen, ob das aktuelle x kleiner als der Mittelpunkt des Kreises ist
    if circleX < x then
        -- Berechne den Y-Wert des Kreismittelpunkts
        local radius = ComputeDistance(center, p2) -- Berechne den Radius
        local eventX = circleX - radius
        local circleEvent = CircleEvent:new(eventX, center, arc)

        -- Setze das Event als gültig
        arc.circleEvent = circleEvent
        table.insert(self.circleEvents, circleEvent)

        -- Zukünftig sollte hier eine Art Vertauschen oder Sortieren implementiert werden,
        -- um sicherzustellen, dass die CircleEvents korrekt basierend auf dem x-Wert sortiert sind.
    end
end

function Fortune:CheckCircleEvent(arc, _x)
    -- Setzt das bisherige CircleEvent auf nicht aktuell
    if arc.circleEvent ~= nil and arc.circleEvent.x ~= _x then
        arc.circleEvent.isValid = false
    end
    arc.circleEvent = nil

	assert(arc.previousArc ~= nil and arc.nextArc ~= nil, "fehlender previousArc oder nextArc")

    local x = 0
    local point = {x = 0, y = 0} -- Erstellen eines Punktes als Tabelle

    if self:GetRightmostCirclePoint(arc.previousArc.point, arc.point, arc.nextArc.point, x, point) and x > _x then
        arc.circleEvent = CircleEvent:new(x, point, arc) -- Erzeugt ein neues CircleEvent
        table.insert(self.circleEvents, arc.circleEvent) -- Fügt das CircleEvent zur Liste hinzu
        table.sort(self.circleEvents, function(a, b) return EventComparer(a, b) end) -- Sortiert die Liste
    end
end

-- Funktion zur Berechnung des Umkreis-Mittelpunkts (circumcenter)
function Fortune:GetCircumcenter(p1, p2, p3)
    -- Berechnungen für den Umkreis-Mittelpunkt
    local d = 2 * (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y))
    assert(d ~= 0, "Punkte sind kollinear, kein Umkreis")

    local ux = ((p1.x^2 + p1.y^2) * (p2.y - p3.y) + (p2.x^2 + p2.y^2) * (p3.y - p1.y) + (p3.x^2 + p3.y^2) * (p1.y - p2.y)) / d
    local uy = ((p1.x^2 + p1.y^2) * (p3.x - p2.x) + (p2.x^2 + p2.y^2) * (p1.x - p3.x) + (p3.x^2 + p3.y^2) * (p2.x - p1.x)) / d

    return {x = ux, y = uy} -- Umkreis-Mittelpunkt zurückgeben
end


function Fortune:GetRightmostCirclePoint(point1, point2, point3)
    -- Berechne den Umkreis-Mittelpunkt für die triangle (point1, point2, point3)
    local circumcenter = self:GetCircumcenter(point1, point2, point3)
    assert(circumcenter, "Ungültige Punkte")

    -- Berechne den Radius des Kreises
    local radius = ComputeDistance(circumcenter, point1) -- Radius basierend auf einem der Punkte

    -- Holen Sie sich den rechten Punkt basierend auf dem x-Wert des Mittelpunktes plus den Radius
    local rightmostPoint = {
        x = circumcenter.x + radius,
        y = circumcenter.y -- y-Koordinate bleibt gleich
    }

    return rightmostPoint
end

function Fortune:GetIntersection(point, arc)
    -- Punkt, in dem die vertikale Linie geschnitten werden soll.
    local x = point.x

    -- Die Punkte des Bogens
    local focus = arc.point
    local previousArc = arc.previousArc
    local nextArc = arc.nextArc

    -- Überprüfen, ob sowohl der vorherige Bogen als auch der nächste Bogen existieren
	--assert(previousArc and nextArc, "Kein Schnittpunkt möglich")
	if not previousArc or not nextArc then
		return nil
	end

    --Berechnung des Schnittpunkts
    local leftFocus = previousArc.point
    local rightFocus = nextArc.point

    -- Berechne den Schnittpunkt zwischen der vertikalen Linie und dem Bogen.
    local y1 = self:GetYCoordinateOfParabola(leftFocus, focus, x)
    local y2 = self:GetYCoordinateOfParabola(rightFocus, focus, x)

    if y1 and y2 then
        return {x = x, y = (y1 + y2) / 2} -- Schnittpunkt zwischen den beiden Y-Koordinaten zurückgeben
    end

    assert(false, "kein gültiger Schnittpunkt vorhanden")
end

function Fortune:GetYCoordinateOfParabola(focus1, focus2, x)
    -- Berechnen der Y-Koordinate der Parabel, basierend auf den beiden Fokuspunkten
    local p1 = focus1
    local p2 = focus2

    -- Wenn die x-Koordinaten gleich sind, ist es eine vertikale Linie
    assert(p1.x ~= p2.x, "kein Schnittpunkt")

    -- Parabelformel zur Berechnung der y-Koordinate
    local directrix = (p1.y + p2.y) / 2
    local y0 = (p1.y + p2.y) / 2 -- Mittelpunkt

    -- Berechnung der Parabel anhand der x-Position
    local vertexX = (p1.x + p2.x) / 2
    local vertexY = y0 - ((p1.x - vertexX) ^ 2) / (2 * (p1.y - p2.y))

    return vertexY
end

-- Funktion zur Berechnung der Zellgröße unter Berücksichtigung der Blockierung
function FindFreeAreaUsingVoronoi(X, Y, b, l, blockingPoints)
    local width = b
    local length = l

    -- Erstelle das Voronoi-Diagramm basierend auf den blockierten Punkten
    local voronoiCells = CreateVoronoiDiagram(blockingPoints)

    local startX = X
    local startY = Y
    local maxDistance = -1
    local bestPosition = {x = startX, y = startY}

    -- Durchlaufe alle Zellen im Voronoi-Diagramm
    for _, cell in ipairs(voronoiCells) do
        -- Berechne die Zellgröße
        local cellSize = Fortune:GetCellSize(cell)

        -- Überprüfe, ob die Zelle ausreichend groß ist und nicht blockiert wird
        if cellSize >= width and cellSize >= length then
            local isBlocked = false
            for _, block in ipairs(blockingPoints) do
                if IsPointInsideCell(block, cell) then
                    isBlocked = true
                    break
                end
            end

            if not isBlocked then
                -- Berechne den Abstand von der aktuellen Position zum Mittelpunkt der Zelle
                local centerX, centerY = cell.center.x, cell.center.y
                local distance = ComputeDistance({x = X, y = Y}, {x = centerX, y = centerY})

                -- Wenn der Abstand größer ist als der bisherige maxDistance, aktualisiere die beste Position
                if distance > maxDistance then
                    maxDistance = distance
                    bestPosition = {x = centerX, y = centerY}
                end
            end
        end
    end

    -- Überprüfen, ob die beste Position blockiert ist
    if IsPositionUnblocked(bestPosition.x, bestPosition.y) then
        return bestPosition.x, bestPosition.y, width, length
    end
    assert(false, "Keine freie Fläche gefunden")
end

-- Hilfsfunktion zur Überprüfung, ob ein Punkt innerhalb einer Zelle liegt
function IsPointInsideCell(point, cell)
    -- Beispiel einer einfachen Überprüfung, ob der Punkt innerhalb des Zellbereichs liegt
    local dist = ComputeDistance(point, cell.center)
    return dist <= Fortune:GetCellSize(cell) -- Hier könnte eine detailliertere Methode verwendet werden
end

-- Beispielaufruf
blockingPoints = {}
for i = 1, 100 do
	table.insert(blockingPoints, {x = math.random(0, 200), y = math.random(0, 200)})
end

freeArea = FindFreeAreaUsingVoronoi(0, 0, 2, 3, blockingPoints)

if freeArea then
    LuaDebugger.Log("Free area found at: (" .. freeArea[1] .. ", " .. freeArea[2] .. ") with dimensions: " .. freeArea[3] .. " x " .. freeArea[4])
else
    LuaDebugger.Log("No free area found.")
end