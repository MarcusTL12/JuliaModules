__precompile__(true)


module Stego


function test(s)
	println(s)
end


function lsb(img::Array{UInt8, 3})
	map!(col -> 0xff - col, img, img)
end


end
