

function grayscale!(img::ImgArr)
	c, w, h = size(img)
	for i in CartesianIndices((1 : w, 1 : h))
		x, y = Tuple(i)
		img[1:3, x, y] .= trunc(UInt8, sqrt(sum(Float64.(img[1:3, x, y]).^2) / 3))
	end
end

