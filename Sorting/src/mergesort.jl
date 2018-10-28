

function merge!(data::Array, scratch::Array, left::Int, right::Int, stop::Int)
	leftstop = right - 1
	scratchindex = left
	start = left
	while left <= leftstop || right <= stop
		if left > leftstop
			scratch[scratchindex] = data[right]
			right += 1
		elseif right > stop
			scratch[scratchindex] = data[left]
			left += 1
		else
			if data[left] < data[right]
				scratch[scratchindex] = data[left]
				left += 1
			else
				scratch[scratchindex] = data[right]
				right += 1
			end
		end
		scratchindex += 1
	end

	for i in start : stop
		data[i] = scratch[i]
	end
end


function mergesort!(data::Array, scratch::Array, start::Int, stop::Int)
	if stop - start < 1
		return
	end

	mergesort!(data, scratch, start, fld(start + stop, 2))
	mergesort!(data, scratch, fld(start + stop, 2) + 1, stop)
	merge!(data, scratch, start, fld(start + stop, 2) + 1, stop)
end


function mergesort!(data::Array)
	scratch = copy(data)
	mergesort!(data, scratch, 1, length(data))
end


function multisort!(data::Array, num_threads::Int=8)
	indices::Array{Int64, 1} = Array{Int64, 1}(undef, num_threads + 1)
	indices[1] = 1
	indices[num_threads + 1] = length(data) + 1
	for i in 1 : num_threads - 1
		indices[i + 1] = floor(i * length(data) / num_threads)
	end
	
	Threads.@threads for i in 1 : num_threads
		quicksort!(data, indices[i], indices[i + 1] - 1)
	end

	scratch = Array{typeof(data[1]), 1}(undef, length(data))

	for i in 1 : num_threads - 1
		merge!(data, scratch, 1, indices[i + 1], indices[i + 2] - 1)
	end
end

