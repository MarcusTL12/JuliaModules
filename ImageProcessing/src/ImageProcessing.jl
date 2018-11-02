__precompile__(true)


module ImageProcessing

import SimpleImage

ColTup = Tuple{UInt8, UInt8, UInt8, UInt8}
ImageA = Array{UInt32, 2}


loadImgABGR(filepath::String)::ImageA = SimpleImage.load_png(filepath)

writeImgABGR(filepath::String, img::ImageA) = SimpleImage.write_png(filepath, img)


getARGB(color::UInt32, abgr::Bool=false)::ColTup = (color >> 24 & 0xff, color >> (abgr ? 0 : 16) & 0xff, color >> 8 & 0xff, color >> (abgr ? 16 : 0) & 0xff)

getColorInt(color::ColTup, abgr::Bool=false)::UInt32 = UInt32(color[1]) << 24 | UInt32(color[2]) << (abgr ? 0 : 16) | UInt32(color[3]) << 8 | UInt32(color[4]) << (abgr ? 16 : 0)


convertbetweenABGR(color::UInt32)::UInt32 = getColorInt(getARGB(color, true))

convertbetweenABGR(color::ColTup)::ColTup = getARGB(getColorInt(color, true))


function convertbetweenABGR(img::ImageA)
	for i in 1 : length(img)
		img[i] = convertbetweenABGR(img[i])
	end
end


function loadImgARGB(filepath::String)::ImageA
	img = loadImgABGR(filepath)
	convertbetweenABGR(img)
	return img
end


function writeImgARGB(filepath::String, img::ImageA)
	convertbetweenABGR(img)
	writeImgABGR(filepath, img)
	convertbetweenABGR(img)
end

end