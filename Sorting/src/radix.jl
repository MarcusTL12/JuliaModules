

Ints = Union{Array{Int8, 1}, Array{Int16, 1}, Array{Int32, 1}, Array{Int64, 1}, Array{Int128, 1}, Array{UInt8, 1}, Array{UInt16, 1}, Array{UInt32, 1}, Array{UInt64, 1}, Array{UInt128, 1}}


function count_sort!(data::Ints, output::Ints, c::Array{Int32, 1}, bits::Int32, offset::Int32)
	combs = 2^bits
	
	for i in 1:combs
		c[i] = 0
	end

	for i in data
		c[(i >> offset) & (combs - 1) + 1] += 1
	end

	for i in 2:combs
		c[i] += c[i - 1]
	end

	index = 0

	for i in length(data) : -1 : 1
		index = (data[i] >> offset) & (combs - 1) + 1
		output[c[index]] = data[i]
		c[index] -= 1
	end
end


function count_sort_sign!(data::Ints, output::Ints, c::Array{Int32, 1})
	c[1] = 0
	c[2] = 0
	
	bit = sizeof(data[1]) * 8

	for i in data
		c[~(i >> (bit - 1)) & 1 + 1] += 1
	end

	c[2] += c[1]
	
	index = 0

	for i in length(data) : -1 : 1
		index = ~(data[i] >> (bit - 1)) & 1 + 1
		output[c[index]] = data[i]
		c[index] -= 1
	end
end


function radix_sort!(data::Ints, log_bits::Int=3)
	if length(data) == 0
		return
	end
	T = typeof(data[1])
	mirror = zeros(T, length(data))
	bits::Int32 = 2^log_bits
	count = zeros(Int32, 2^bits)
	for i in 1:fld(sizeof(T) * 8, bits)
		count_sort!(data, mirror, count, bits, Int32(((i - 1) * 2) * bits))
		count_sort!(mirror, data, count, bits, Int32(((i - 1) * 2 + 1) * bits))
	end
	if !(T <: Unsigned)
		count_sort_sign!(data, mirror, count)
		for i in 1:length(data)
			data[i] = mirror[i]
		end
	end
end


function radix_sort!(data::Array{Float16, 1}, log_bits::Int)
	intdata::Array{Int16, 1} = unsafe_wrap(Array, convert(Ptr{Int16}, pointer(data)), length(data))

	for i in 1:length(intdata)
		if intdata[i] < 0
			intdata[i] = ~intdata[i] + Int16(-32768)
		end
	end

	radix_sort!(intdata, log_bits)

	for i in 1:length(intdata)
		if intdata[i] < 0
			intdata[i] = ~intdata[i] + Int16(-32768)
		end
	end
end


function radix_sort!(data::Array{Float32, 1}, log_bits::Int)
	intdata::Array{Int32, 1} = unsafe_wrap(Array, convert(Ptr{Int32}, pointer(data)), length(data))

	for i in 1:length(intdata)
		if intdata[i] < 0
			intdata[i] = ~intdata[i] + Int32(-2147483648)
		end
	end

	radix_sort!(intdata, log_bits)

	for i in 1:length(intdata)
		if intdata[i] < 0
			intdata[i] = ~intdata[i] + Int32(-2147483648)
		end
	end
end


function radix_sort!(data::Array{Float64, 1}, log_bits::Int)
	intdata::Array{Int64, 1} = unsafe_wrap(Array, convert(Ptr{Int64}, pointer(data)), length(data))

	for i in 1:length(intdata)
		if intdata[i] < 0
			intdata[i] = ~intdata[i] + Int64(-9223372036854775808)
		end
	end

	radix_sort!(intdata, log_bits)

	for i in 1:length(intdata)
		if intdata[i] < 0
			intdata[i] = ~intdata[i] + Int64(-9223372036854775808)
		end
	end
end

