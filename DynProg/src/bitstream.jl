

struct BitStream
	data::Array{Int8, 1}
	indices::Array{Int, 1}
	BitStream() = new(Array{Int8, 1}(undef, 16), [1, 1])
	BitStream(prealloc::Int) = new(Array{Int8, 1}(undef, prealloc), [1, 1])
end


function push!(strm::BitStream, data::Bool)
	strm.data[strm.indices[1]] |= (data ? 1 : 0) << (strm.indices[2] - 1)
	
	if strm.indices[2] == 8
		strm.indices[2] = 1
		strm.indices[1] += 1
		push!(strm.data, 0)
	end
end


function get(strm::BitStream, index::Int)::Bool
	return (strm.data[cld(index, 8)] & (1 << ((index - 1) % 8))) != 0
end


function set(strm::BitStream, index::Int, val::Bool)
	strm.data[cld(index, 8)] &= ~(1 << ((index - 1) % 8))
	strm.data[cld(index, 8)] |= (val ? 1 : 0) << ((index - 1) % 8)
end


function length(strm::BitStream)::Int
	return (strm.indices[1] - 1) * 8 + strm.indices[2]
end


function print(strm::BitStream)
	for i in 1 : length(strm)
		print(get(strm, i) ? '1' : 0)
	end
end


function println(strm::BitStream)
	print(strm)
	print('\n')
end
