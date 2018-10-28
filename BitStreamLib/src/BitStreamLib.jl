__precompile__()


module BitStreamLib

import Base.push!
import Base.length
import Base.print
import Base.println
import Base.get

export BitStream
export push!
export get
export set
export length
export print
export println


struct BitStream
	data::Array{UInt8, 1}
	indices::Array{Int, 1}
	BitStream() = new(zeros(UInt8, 16), [1, 1])
	BitStream(prealloc::Int) = new(zeros(UInt8, prealloc), [1, 1])
	BitStream(data::Array{UInt8, 1}, len::Int) = new(data, [fld(len, 8) + 1, (len) % 8 + 1])
end


function push!(strm::BitStream, data::Bool)
	strm.data[strm.indices[1]] |= UInt8(UInt8(data ? UInt8(1) : UInt8(0)) << (strm.indices[2] - 1))
	strm.indices[2] += 1

	if strm.indices[2] == 9
		strm.indices[2] = 1
		strm.indices[1] += 1
		if strm.indices[1] > length(strm.data)
			push!(strm.data, UInt8(0))
		end
	end
end


function get(strm::BitStream, index::Int)::Bool
	return (strm.data[cld(index, 8)] & (UInt8(1) << ((index - 1) % 8))) != 0
end


function set(strm::BitStream, index::Int, val::Bool)
	strm.data[cld(index, 8)] &= ~UInt8(UInt8(1) << ((index - 1) % 8))
	strm.data[cld(index, 8)] |= UInt8((val ? UInt8(1) : UInt8(0)) << ((index - 1) % 8))
end


function length(strm::BitStream)::Int
	return (strm.indices[1] - 1) * 8 + strm.indices[2] - 1
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

end