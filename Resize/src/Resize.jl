

module Resize

using Images, ImageFiltering, FileIO

export reduce_width

function path_weights(weights)
	ret = copy(weights)
	dim = size(weights)
	for i in 2 : dim[1]
		for j in 1 : dim[2]
			min = ret[i - 1, j]
			if j > 1 && ret[i - 1, j - 1] < min
				min = ret[i - 1, j - 1]
			end
			if j < dim[2] && ret[i - 1, j + 1] < min
				min = ret[i - 1, j + 1]
			end
			ret[i, j] += min
		end
	end
	return ret
end

function back_track(weights)
	dim = size(weights)

	buffer::Array{Int, 1} = ones(Int, dim[1])

	buffer[1] = 1
	for i in 2 : dim[2]
		if weights[dim[1], i] < weights[dim[1], buffer[1]]
			buffer[1] = i
		end
	end

	for i in dim[1] - 1 : -1 : 1
		k = dim[1] - i + 1
		j = buffer[k - 1]
		buffer[k] = j
		if j > 1 && weights[i, j - 1] < weights[i, buffer[k]]
			buffer[k] = j - 1
		end
		if j < dim[2] && weights[i, j + 1] < weights[i, buffer[k]]
			buffer[k] = j + 1
		end
	end

	ret::Array{Tuple{Int, Int}, 1} = Array{Tuple{Int, Int}, 1}(undef, dim[1])
	
	for i in 1 : dim[1]
		ret[i] = dim[1] - i + 1, buffer[i]
	end
	
	return ret
end

function gradiant(image)
	kernel = [1 0 -1; 2 0 -2;1 0 -1]
	sobel_x = imfilter(image, centered(kernel))
	grad = imfilter(sobel_x, centered(kernel'))
end

function absolute_gradiant(image)
	height, width = size(image)
	grad = gradiant(image)
	reshape([abs(pixel.r)+abs(pixel.g)+abs(pixel.b) for pixel in grad],height,width)
end

function reduce_width(image::Array{ColorTypes.RGBA{FixedPointNumbers.Normed{UInt8,8}},2}, reduction)
	# image = load(image_path)

	for i in 1:reduction
		h, w = size(image)

		#=
		Det finnes mange måter å gi hver piksel en vekt.
		Her brukes summen av absoluttverdiene avgradientene,
		men det kan endres om man vil.
		=#
		weights = absolute_gradiant(image)
		cumulative_weights = path_weights(weights)

		#=
		Her bruker vi stien vi finner med back_track til å lage en boolsk
		matrise der cellene vi ønsker å fjerne fra bildet har verdien false
		=#
		crop_matrix = ones(Bool,h,w)
		for (i,j) in back_track(cumulative_weights)
			crop_matrix[i,j] = false
		end

		#=
		Et boolsk oppslag i matrisen vår fjerner alle celler der den boolske
		matrisen er false. Fordi resultatet av et slikt oppslag er en 1-dimensjonell
		matrise så bruker vi reshape for å få originalformen tilbake, minus den ene
		pikselen vi har fjernet i bredden.
		=#
		image = reshape(image'[crop_matrix'],w-1,h)'
	end

	image
end

# function main()
# 	reduce_width("tower.jpg", 200)
# end

end
