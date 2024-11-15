--@ Define corner textures
local tex_corner8 = surface.GetTextureID("gui/corner8")
local tex_corner16 = surface.GetTextureID("gui/corner16")
local tex_corner32 = surface.GetTextureID("gui/corner32")
local tex_corner64 = surface.GetTextureID("gui/corner64")
local tex_corner512 = surface.GetTextureID("gui/corner512")

--@ Enhanced text drawing with responsive support
function gSimpleText(text, font, x, y, colour, xalign, yalign)
	--@ Default parameters initialization
	text	= tostring(text)
	font	= font		or "DermaDefault"
	x		= x			or 0
	y		= y			or 0
	xalign	= xalign	or TEXT_ALIGN_LEFT
	yalign	= yalign	or TEXT_ALIGN_TOP
	--@ Set font and get text dimensions
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	--@ Apply horizontal alignment
	if (xalign == TEXT_ALIGN_CENTER) then
		x = x - w / 2
	elseif (xalign == TEXT_ALIGN_RIGHT) then
		x = x - w
	end
	--@ Apply vertical alignment
	if (yalign == TEXT_ALIGN_CENTER) then
		y = y - h / 2
	elseif (yalign == TEXT_ALIGN_BOTTOM) then
		y = y - h
	end
	--@ Apply responsive positioning
	local posX = math.ceil(gRespX(x))
	local posY = math.ceil(gRespY(y))
	surface.SetTextPos(posX, posY)
	--@ Set text color with default fallback
	if (colour != nil) then
		surface.SetTextColor(colour.r, colour.g, colour.b, colour.a)
	else
		surface.SetTextColor(255, 255, 255, 255)
	end
	--@ Draw text and return dimensions
	surface.DrawText(text)
	return gRespX(w), gRespY(h)
end

--@ Enhanced outlined text drawing with responsive support
function gSimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
	--@ Calculate outline steps
	local steps = (outlinewidth * 2) / 3
	if (steps < 1) then steps = 1 end
	--@ Draw outline
	for _x = -outlinewidth, outlinewidth, steps do
		for _y = -outlinewidth, outlinewidth, steps do
			gSimpleText(text, font, x + _x, y + _y, outlinecolour, xalign, yalign)
		end
	end
	--@ Draw main text and return dimensions
	return gSimpleText(text, font, x, y, colour, xalign, yalign)
end
 
--@ Simple rounded box drawing with responsive support
function gRoundedBox(bordersize, x, y, w, h, color)
	return gRoundedBoxEx(bordersize, x, y, w, h, color, true, true, true, true)
end

--@ Advanced rounded box drawing with corner selection and responsive support
function gRoundedBoxEx(bordersize, x, y, w, h, color, tl, tr, bl, br)
    --@ Set draw color
    surface.SetDrawColor(color.r, color.g, color.b, color.a)
    
    --@ Convert positions to responsive
    local posX = gRespX(x)
    local posY = gRespY(y)
    local width = gRespX(w)
    local height = gRespY(h)
    local respBorder = gRespX(bordersize)
    
    --@ Handle non-rounded box case
    if (respBorder <= 0) then
        surface.DrawRect(posX, posY, width, height)
        return
    end
    
    --@ Limit border size to half of the smallest dimension
    respBorder = math.min(respBorder, math.floor(width / 2), math.floor(height / 2))
    
    --@ Draw main rectangle parts
    surface.DrawRect(posX + respBorder, posY, width - respBorder * 2, height)
    surface.DrawRect(posX, posY + respBorder, respBorder, height - respBorder * 2)
    surface.DrawRect(posX + width - respBorder, posY + respBorder, respBorder, height - respBorder * 2)
    
    --@ Select corner texture based on border size
    local tex = tex_corner8
    if (respBorder > 8) then tex = tex_corner16 end
    if (respBorder > 16) then tex = tex_corner32 end
    if (respBorder > 32) then tex = tex_corner64 end
    if (respBorder > 64) then tex = tex_corner512 end
    
    --@ Set corner texture
    surface.SetTexture(tex)
    
    --@ Draw corners based on parameters
    if (tl) then
        surface.DrawTexturedRectUV(posX, posY, respBorder, respBorder, 0, 0, 1, 1)
    else
        surface.DrawRect(posX, posY, respBorder, respBorder)
    end
    
    if (tr) then
        surface.DrawTexturedRectUV(posX + width - respBorder, posY, respBorder, respBorder, 1, 0, 0, 1)
    else
        surface.DrawRect(posX + width - respBorder, posY, respBorder, respBorder)
    end
    
    if (bl) then
        surface.DrawTexturedRectUV(posX, posY + height - respBorder, respBorder, respBorder, 0, 1, 1, 0)
    else
        surface.DrawRect(posX, posY + height - respBorder, respBorder, respBorder)
    end
    
    if (br) then
        surface.DrawTexturedRectUV(posX + width - respBorder, posY + height - respBorder, respBorder, respBorder, 1, 1, 0, 0)
    else
        surface.DrawRect(posX + width - respBorder, posY + height - respBorder, respBorder, respBorder)
    end
end
