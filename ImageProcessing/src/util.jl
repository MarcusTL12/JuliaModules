

function toRGBFloat(img::ImgArr)::Array{Float32, 3}
	c, w, h = size(img)
	ret = Array{Float32, 3}(undef, (3, w, h))
	ret .= (Float32.(img[1:3, :, :]) ./ 255)
	return ret
end


function toARGBBytes(img::Array{Float32, 3})::ImgArr
	c, w, h = size(img)
	ret = ImgArr(undef, (4, w, h))
	ret[4, :, :] .= 0xff
	ret[1:3, :, :] .= UInt8.(round.(img .* 255))
	return ret
end


loadFloatImg(filepath::String)::Array{Float32, 3} = toRGBFloat(loadImg(filepath))

writeImg(filepath::String, img::Array{Float32, 3}) = writeImg(filepath, toARGBBytes(img))

