__precompile__(true)

import SimpleImage


module ImageProcessing


loadImgABGR(filepath::String)::Array{UInt32, 2} = SimpleImage.load_png(filepath)

writeImgABGR(filepath::String, img::Array{UInt32, 2}) = SimpleImage.write_png(filepath, img)


getARGB(color::UInt32, abgr::Bool=false)::Tuple{UInt8, UInt8, UInt8, UInt8} = (color >> 24 & 0xff, color >> (abgr ? 0 : 16) & 0xff, color >> 8 & 0xff, color >> (abgr ? 16 : 0) & 0xff)

getColorInt(color::Tuple{UInt8, UInt8, UInt8, UInt8}, abgr::Bool=false)::UInt32 = UInt32(color[1]) << 24 | UInt32(color[2]) << (abgr ? 0 : 16) | UInt32(color[3]) << 8 | UInt32(color[4]) << (abgr ? 16 : 0)


convertbetweenABGR(color::UInt32)::UInt32 = getColorInt(getARGB(color, true))

convertbetweenABGR(color::Tuple{UInt8, UInt8, UInt8, UInt8})::Tuple{UInt8, UInt8, UInt8, UInt8} = getARGB(getColorInt(color, true))


function loadImgARGB(filepath::String)::Array{UInt32, 2}
	img = loadImgABGR(filepath)
	for i in 1 : len(img)
		img[i] = convertbetweenABGR(img[i])
	end
end


end

