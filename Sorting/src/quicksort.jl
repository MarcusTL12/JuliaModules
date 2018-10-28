function partition!(data::Array, p::Int64, r::Int64)
	i::Int64 = rand(p:r)
	data[i], data[r] = data[r], data[i]
	x = data[r]
	i = p - 1
	for j in p : r - 1
		if data[j] <= x
			i += 1
			data[i], data[j] = data[j], data[i]
		end
	end
	data[i + 1], data[r] = data[r], data[i + 1]
	return i + 1
end


function quicksort!(data::Array, start::Int64, stop::Int64)
	if stop - start < 1
		return
	end

	p = partition!(data, start, stop)

	quicksort!(data, start, p - 1)
	quicksort!(data, p + 1, stop)
end


function quicksort!(data::Array)
	quicksort(data, 1, length(data))
end
