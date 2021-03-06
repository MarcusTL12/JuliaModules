

function toRGBFloat(img::ImgArr)::ImgFlt
	c, w, h = size(img)
	ret = ImgFlt(undef, (3, w, h))
	ret .= (Float32.(img[1:3, :, :]) ./ 255)
	return ret
end


function toARGBBytes(img::ImgFlt)::ImgArr
	c, w, h = size(img)
	ret = ImgArr(undef, (4, w, h))
	ret[4, :, :] .= 0xff
	ret[1:3, :, :] .= UInt8.(round.(img .* 255))
	return ret
end


loadFloatImg(filepath::String)::ImgFlt = toRGBFloat(loadImg(filepath))

writeImg(filepath::String, img::ImgFlt) = writeImg(filepath, toARGBBytes(img))

