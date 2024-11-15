--@ Responsive utilities configuration
local BASE_WIDTH = 1920		--@ Reference width
local BASE_HEIGHT = 1080	--@ Reference height
local scaleX, scaleY		--@ Scale factors

--@ Update screen scale factors
function UpdateScaleFactors()
	scaleX = ScrW() / BASE_WIDTH
	scaleY = ScrH() / BASE_HEIGHT
end

--@ Scale X value based on screen width
function gRespX(value)
	return math.Round(value * scaleX)
end

--@ Scale Y value based on screen height
function gRespY(value)
	return math.Round(value * scaleY)
end

--@ Calculate responsive font size
function gRespFont(size)
	return math.Round(size * math.min(scaleX, scaleY))
end

--@ Create responsive font with given parameters
function gCreateRespFont(name, fontFamily, baseSize, weight, antialias, shadow, outline)
	local fontData = {
		font = fontFamily,				--@ Font family from parameter
		size = gRespFont(baseSize),
		weight = weight or 500,
		antialias = antialias or true,
		shadow = shadow or false,
		outline = outline or false
	}
	surface.CreateFont(name, fontData)
end

--@ Initialize responsive system
local function Initialize()
	UpdateScaleFactors()		--@ Update scale factors
end

--@ Hook system initialization
hook.Add("Initialize", "InitializeResponsiveSystem", Initialize)

--@ Hook screen size changes
hook.Add("OnScreenSizeChanged", "UpdateResponsiveFactors", function()
	Initialize()
end)

--@ Initial setup
Initialize()