__precompile__(true)


module Stego

using BitStreamLib

function lsb(img::Array{UInt8, 3}, data)
	data_bits::BitStream = BitStream(data)

	length_bits::BitStream = BitStream(length(data_bits))

	img .&= 0xfe

end


end
