__precompile__(true)

module SimpleImage

function load_png(filepath::String)::Array{UInt32, 2}
	temp = Int32[0, 0, 0]

	imgptr = ccall((:loadPngInt, "simplepng"), Ptr{UInt32}, (Cstring, Ptr{Int32}, Ptr{Int32}, Ptr{Int32}), filepath, pointer(temp), pointer(temp) + 4, pointer(temp) + 8)

	w, h, l = temp

	img = unsafe_wrap(Array{UInt32, 2}, imgptr, (h, w))

	finalizer(free_img, img)

	return img
end

function free_img(img::Array{UInt32, 2})
	ccall((:deleteImg, "simplepng"), Cvoid, (Ptr{UInt8},), pointer(img))
end

function write_png(filepath::String, img::Array{UInt32, 2})
	h, w = size(img)
	ccall((:writePngInt, "simplepng"), Cvoid, (Cstring, Ptr{Int32}, Int32, Int32), filepath, pointer(img), w, h)
end

end