__precompile__(true)


module Stego

using BitStreamLib

function lsb(img::Array{UInt8, 3}, data)
	data_bits::BitStream = BitStream(data)

	length_bits::BitStream = BitStream(length(data_bits))

	img .&= 0xfe

	img_ind::Int = 1

	for i in length_bits
		img[img_ind] |= i ? 0x01 : 0x00
	end
end


end
