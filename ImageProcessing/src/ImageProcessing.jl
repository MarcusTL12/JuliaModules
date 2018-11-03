__precompile__(true)


module ImageProcessing

import SimpleImage

ColTup = Tuple{UInt8, UInt8, UInt8, UInt8}
ImgInt = Array{UInt32, 2}
ImgArr = Array{UInt8, 3}


loadImgABGR(filepath::String)::ImgInt = SimpleImage.load_png(filepath)

writeImgABGR(filepath::String, img::ImgInt) = SimpleImage.write_png(filepath, img)


getARGB(color::UInt32, abgr::Bool=false)::ColTup = (color >> 24 & 0xff, color >> (abgr ? 0 : 16) & 0xff, color >> 8 & 0xff, color >> (abgr ? 16 : 0) & 0xff)

getColorInt(color::ColTup, abgr::Bool=false)::UInt32 = UInt32(color[1]) << 24 | UInt32(color[2]) << (abgr ? 0 : 16) | UInt32(color[3]) << 8 | UInt32(color[4]) << (abgr ? 16 : 0)


convertbetweenABGR(color::UInt32)::UInt32 = getColorInt(getARGB(color, true))

convertbetweenABGR(color::ColTup)::ColTup = getARGB(getColorInt(color, true))


function convertbetweenABGR(img::ImgInt)
	for i in 1 : length(img)
		img[i] = convertbetweenABGR(img[i])
	end
end


function loadImgARGB(filepath::String)::ImgInt
	img = loadImgABGR(filepath)
	convertbetweenABGR(img)
	return img
end


function writeImgARGB(filepath::String, img::ImgInt)
	convertbetweenABGR(img)
	writeImgABGR(filepath, img)
	convertbetweenABGR(img)
end


loadImg(filepath::String)::ImgArr = SimpleImage.load_png_bytes(filepath)

writeImg(filepath::String, img::ImgArr) = SimpleImage.write_png(filepath, img)


include("kernel.jl")


end