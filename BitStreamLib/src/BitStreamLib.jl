__precompile__(true)


module BitStreamLib

import Base.push!
import Base.length
import Base.get
import Base.getindex
import Base.setindex!
import Base.string
import Base.show
import Base.iterate

export BitStream
export push!
export get
export getindex
export set
export setindex!
export length
export string
export show
export iterate
export data
export getvalue


struct BitStream
	data::Array{UInt8, 1}
	indices::Array{Int, 1}
	BitStream() = new(zeros(UInt8, 16), [1, 1])
	BitStream(data::Array{UInt8, 1}, len::Int) = new(data, [fld(len, 8) + 1, (len) % 8 + 1])
	BitStream(data::Array{UInt8, 1}) = BitStream(data, length(data) * 8)
	BitStream(data::String) = BitStream(Array{UInt8, 1}(data))
	BitStream(data::Union{Signed, Unsigned, AbstractFloat}) = BitStream(Array{UInt8, 1}(reinterpret(UInt8, [data])))
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


getindex(strm::BitStream, index::Int)::Bool = get(strm, index)


getindex(strm::BitStream, range::UnitRange{Int64}) = [strm[i] for i in range]


function get(strm::BitStream, index::Int)::Bool
	return (strm.data[cld(index, 8)] & (UInt8(1) << ((index - 1) % 8))) != 0
end


setindex!(A::BitStream, val::Bool, i1::Int) = set(A, i1, val)

function setindex!(strm::BitStream, vals::Array{Bool,1}, range::UnitRange{Int64})
	i = 1
	for j in range
		strm[j] = vals[i]
		i += 1
	end
end


function set(strm::BitStream, index::Int, val::Bool)
	strm.data[cld(index, 8)] &= ~UInt8(UInt8(1) << ((index - 1) % 8))
	strm.data[cld(index, 8)] |= UInt8((val ? UInt8(1) : UInt8(0)) << ((index - 1) % 8))
end


function length(strm::BitStream)::Int
	return (strm.indices[1] - 1) * 8 + strm.indices[2] - 1
end


function data(strm::BitStream)::Array{UInt8, 1}
	return strm.data[1:cld(length(strm), 8)]
end


function getvalue(T::DataType, strm::BitStream)
	if T <: Union{Signed, Unsigned, AbstractFloat}
		return reinterpret(T, data(strm))[1]
	elseif T <: AbstractString
		return String(data(strm))
	end
end


function string(strm::BitStream)
	ret = ""
	for i in 1 : length(strm)
		ret *= string(strm[i] ? '1' : 0)
	end
	return ret
end


function show(io::IO, strm::BitStream)
	print(io, string(strm))
end


function iterate(iter::BitStream, state=1)
	if state > length(iter)
		return nothing
	end

	return (iter[state], state + 1)
end


end