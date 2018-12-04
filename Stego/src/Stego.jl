__precompile__(true)


module Stego

using BitStreamLib

str_dat(s::String)::Array{UInt8, 1} = unsafe_wrap(Array{UInt8, 1}, pointer(s), length(s))

lsb(img::Array{UInt8, 3}, data::String) = lsb(img, str_dat(data))

function lsb(img::Array{UInt8, 3}, data::Vector{UInt8})
	data_bits::BitStream = BitStream(data)

	img .&= 0xfe

end


end
