--@ Material drawing with responsive support
function gMaterials(name, posx, posy, sizex, sizey, color)
	--@ Set material and color
	surface.SetMaterial(name)
	surface.SetDrawColor(color or color_white)
	--@ Draw textured rectangle with responsive measurements
	surface.DrawTexturedRect(
		gRespX(posx) or 0,
		gRespY(posy) or 0,
		gRespX(sizex) or 0,
		gRespY(sizey) or 0		--@ Fixed: was posy instead of sizey
	)
end

--@ Material drawing with UV coordinates and responsive support
function gMaterialsUV(name, posx, posy, sizex, sizey, color, u0, v0, u1, v1)
	--@ Set material and color
	surface.SetMaterial(name)
	surface.SetDrawColor(color or color_white)
	--@ Draw textured rectangle with UV mapping and responsive measurements
	surface.DrawTexturedRectUV(
		gRespX(posx) or 0,
		gRespY(posy) or 0,
		gRespX(sizex) or 0,
		gRespY(sizey) or 0,
		u0 or 0,		--@ Left UV coordinate
		v0 or 0,		--@ Top UV coordinate
		u1 or 1,		--@ Right UV coordinate
		v1 or 1			--@ Bottom UV coordinate
	)
end