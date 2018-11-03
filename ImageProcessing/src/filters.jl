

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


function simple_gaussian!(img::ImgFlt)
	kernel = Float32[
		1 2 1;
		2 3 2;
		1 2 1
	]
	apply_kernel!(img, kernel)
	img ./= sum(kernel)
end


function simple_gaussian_larger!(img::ImgFlt)
	kernel = Float32[
		1 2 3 2 1;
		2 3 4 3 2;
		3 4 5 4 3;
		2 3 4 3 2;
		1 2 3 2 1
	]
	apply_kernel!(img, kernel)
	img ./= sum(kernel)
end

