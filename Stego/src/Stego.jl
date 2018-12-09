__precompile__(true)


module Stego

using BitStreamLib

function lsb(img::Array{UInt8, 3}, data)
	data_bits::BitStream = BitStream(data)

	length_bits::BitStream = BitStream(Int32(length(data_bits)))

	img .&= 0xfe

	img_ind::Int = 1

	for i in length_bits
		img[img_ind] |= i ? 0x01 : 0x00
		img_ind += 1
	end

	for i in data_bits
		img[img_ind] |= i ? 0x01 : 0x00
		img_ind += 1
	end
end


function lsb(img::Array{UInt8, 3})
	length_bits::BitStream = BitStream()
	img_ind::Int = 1
	for i in 1 : 32
		push!(length_bits, img[i] & 0x01 != 0x00)
		img_ind += 1
	end
	len::Int32 = getvalue(Int32, length_bits)
	data_bits::BitStream = BitStream()

	for i in 1 : len
		push!(data_bits, img[img_ind] & 0x01 != 0x00)
		img_ind += 1
	end
	return data(data_bits)
end


function simplesteg(img::Array{UInt8, 3}, data, bits::Int32)
	data_bits::BitStream = BitStream(data)

	length_bits::BitStream = BitStream(Int32(length(data_bits)))

	img[1:16] .&= 0b11111100

	img_ind::Int = 1
	sub_ind::Int32 = 1

	for i in length_bits
		img[img_ind] |= i ? 0x01 : 0x00
		img_ind += 1
	end
end


end
