

function apply_kernel!(img::ImgArr, kernel::Array{Int, 2})
	c, w, h = size(img)
	kh, kw = size(kernel)
	x_off = fld(kw - 1, 2)
	y_off = fld(kh - 1, 2)
	cpyImg::ImgArr = ImgArr(undef, size(img))
	for i in CartesianIndices((w, h))
		x, y = Tuple(i)
		acc = Int[0, 0, 0, 0]
		kersum::Int = 0
		for j in CartesianIndices((max(1, x - x_off) : min(w, x + x_off), max(1, y - y_off) : min(h, y + y_off)))
			kx, ky = Tuple(j)
			curker = kernel[ky + y_off - y + 1, kx + x_off - x + 1]
			kersum += curker
			acc .+= img[:, kx, ky] * curker
		end
		map!(acc -> fld.(acc, kersum), acc, acc)
		cpyImg[:, x, y] .= acc
	end
	img .= cpyImg
end

