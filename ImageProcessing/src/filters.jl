

function grayscale!(img::ImgArr)
	c, w, h = size(img)
	for i in CartesianIndices((1 : w, 1 : h))
		x, y = Tuple(i)
		img[1:3, x, y] .= trunc(UInt8, sqrt(sum(Float64.(img[1:3, x, y]).^2) / 3))
	end
end


function grayscale!(img::ImgFlt)
	c, w, h = size(img)
	for i in CartesianIndices((1 : w, 1 : h))
		x, y = Tuple(i)
		img[:, x, y] .= sqrt(sum(img[:, x, y].^2) / 3)
	end
end


function simple_blur!(img::ImgFlt)
	kernel = Float32[
		1 2 1;
		2 3 2;
		1 2 1
	]
	apply_kernel!(img, kernel)
	img ./= sum(kernel)
end


function gaussian_kernel(r::Int, stdev::Number)::Array{Float32, 2}
	r2(x, y) = x^2 + y^2
	kernel::Array{Float32, 2} = Array{Float32, 2}(undef, (2 * r + 1, 2 * r + 1))
	for i in CartesianIndices(size(kernel))
		x, y = Tuple(i)
		kernel[x, y] = (1 / (sqrt(2 * pi) * stdev)) * exp(- r2(x - r, y - r) / (2 * stdev^2))
	end
	kernel ./= sum(kernel)
	return kernel
end


function gaussian!(img::ImgFlt, r::Int, stdev::Number)
	apply_kernel!(img, gaussian_kernel(r, stdev))
end

