--@ Panel manipulation utilities with responsive support
local meta = FindMetaTable("Panel")

--@ Set panel's X position with responsive scaling
function meta:gSetX(x)
   self:SetPos(gRespX(x), self:GetY())
end

--@ Set panel's Y position with responsive scaling
function meta:gSetY(y)
   self:SetPos(self:GetX(), gRespY(y))
end

--@ Set panel's position with responsive scaling
function meta:gSetPos(x, y)
   self:SetPos(gRespX(x), gRespY(y))
end

--@ Set panel's height with responsive scaling
function meta:gSetHeight(h)
   self:SetSize(self:GetWide(), gRespY(h))
end

--@ Set panel's width with responsive scaling
function meta:gSetWidth(w)
   self:SetSize(gRespX(w), self:GetTall())
end

--@ Set panel's size with responsive scaling
function meta:gSetSize(w, h)
   self:SetSize(gRespX(w), gRespY(h))
end

--@ Set panel's minimum width with responsive scaling
function meta:gSetMinWidth(w)
   self:SetMinWidth(gRespX(w))
end

--@ Set panel's minimum height with responsive scaling
function meta:gSetMinHeight(h)
   self:SetMinHeight(gRespY(h))
end

--@ Set panel's maximum width with responsive scaling
function meta:gSetMaxWidth(w)
   self:SetMaxWidth(gRespX(w))
end

--@ Set panel's maximum height with responsive scaling
function meta:gSetMaxHeight(h)
   self:SetMaxHeight(gRespY(h))
end

--@ Set panel's width and height to the same value with responsive scaling
function meta:gSetSquareSize(size)
   self:SetSize(gRespX(size), gRespY(size))
end

--@ Center the panel on X axis with responsive scaling
function meta:gCenterHorizontal(offset)
   offset = offset or 0
   local parent = self:GetParent()
   local x = (parent:GetWide() - self:GetWide()) / 2
   self:SetX(x + gRespX(offset))
end

--@ Center the panel on Y axis with responsive scaling
function meta:gCenterVertical(offset)
   offset = offset or 0
   local parent = self:GetParent()
   local y = (parent:GetTall() - self:GetTall()) / 2
   self:SetY(y + gRespY(offset))
end

--@ Center the panel on both axes with responsive scaling
function meta:gCenter(xOffset, yOffset)
   self:gCenterHorizontal(xOffset)
   self:gCenterVertical(yOffset)
end

--@ Set panel's dock margin with responsive scaling
function meta:gDockMargin(left, top, right, bottom)
   self:DockMargin(
   	gRespX(left), 
   	gRespY(top), 
   	gRespX(right), 
   	gRespY(bottom)
   )
end

--@ Set panel's dock padding with responsive scaling
function meta:gDockPadding(left, top, right, bottom)
   self:DockPadding(
   	gRespX(left), 
   	gRespY(top), 
   	gRespX(right), 
   	gRespY(bottom)
   )
end

--@ Set panel's margin with responsive scaling
function meta:gSetMargin(margin)
   self:gDockMargin(margin, margin, margin, margin)
end

--@ Set panel's padding with responsive scaling
function meta:gSetPadding(padding)
   self:gDockPadding(padding, padding, padding, padding)
end