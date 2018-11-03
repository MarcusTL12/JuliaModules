

function apply_kernel!(img::ImgArr, kernel::Array{Int, 2})
	c, w, h = size(img)
	kh, kw = size(kernel)
	x_off = fld(kw - 1, 2)
	y_off = fld(kh - 1, 2)
	cpyImg::ImgArr = ImgArr(undef, (3, w, h))
	for i in CartesianIndices((w, h))
		x, y = Tuple(i)
		acc = Int[0, 0, 0]
		kersum::Int = 0
		for j in CartesianIndices((max(1, x - x_off) : min(w, x + x_off), max(1, y - y_off) : min(h, y + y_off)))
			kx, ky = Tuple(j)
			curker = kernel[ky + y_off - y + 1, kx + x_off - x + 1]
			kersum += abs(Int(curker))
			acc .+= img[1:3, kx, ky] * curker
		end
		if kersum > 0
			map!(acc -> fld.(acc, kersum), acc, acc)
		end
		cpyImg[:, x, y] .= abs.(acc)
	end
	img[1:3, :, :] .= cpyImg
end


function apply_kernel!(img::ImgFlt, kernel::Array{Float32, 2})
	c, w, h = size(img)
	kh, kw = size(kernel)
	x_off = fld(kw - 1, 2)
	y_off = fld(kh - 1, 2)
	cpyImg::ImgFlt = ImgFlt(undef, (3, w, h))
	kerInd = (- x_off : x_off, - y_off : y_off)
	for x in 1 : w
		acc::Array{Float32, 1} = Float32[0, 0, 0]
		for y in 1 : h
			acc .= 0
			for kx in kerInd[1]
				for ky in kerInd[2]
					acc .+= img[:, clamp(kx + x, 1, w), clamp(ky + y, 1, h)] * kernel[ky + y_off + 1, kx + x_off + 1]
				end
			end
			cpyImg[:, x, y] .= acc
		end
	end
	img .= cpyImg
end


function apply_kernel!(img::ImgFlt, kernel::Array{Float32, 3})
	c, w, h = size(img)
	kh, kw, d = size(kernel)
	x_off = fld(kw - 1, 2)
	y_off = fld(kh - 1, 2)
	cpyImg::ImgFlt = ImgFlt(undef, (3, w, h))
	acc::Array{Float32, 1} = Float32[0, 0, 0]
	kerInd = (- x_off : x_off, - y_off : y_off)
	for x in 1 : w
		for y in 1 : h
			acc .= 0
			for kx in kerInd[1]
				for ky in kerInd[2]
					acc[1] += img[1, clamp(kx + x, 1, w), clamp(ky + y, 1, h)] * kernel[ky + y_off + 1, kx + x_off + 1, 1]
					acc[2] += img[2, clamp(kx + x, 1, w), clamp(ky + y, 1, h)] * kernel[ky + y_off + 1, kx + x_off + 1, 2]
					acc[3] += img[3, clamp(kx + x, 1, w), clamp(ky + y, 1, h)] * kernel[ky + y_off + 1, kx + x_off + 1, 3]
				end
			end
			cpyImg[:, x, y] .= acc
		end
	end
	img .= cpyImg
end
