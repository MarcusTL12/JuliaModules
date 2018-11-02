__precompile__(true)

module SimpleImage

function load_png(filepath::String)::Array{UInt32, 2}
	imgptr = ccall((:loadPng, "simplepng"), Ptr{UInt32}, (Cstring,), filepath)
	
	w, h = unsafe_wrap(Array{UInt32, 1}, imgptr, (2,))

	img = unsafe_wrap(Array{UInt32, 2}, imgptr + 8, (h, w))

	finalizer(free_img, img)

	return img
end

function free_img(img::Union{Array{UInt32}, Array{UInt8}})
	ccall((:freeImg, "simplepng"), Cvoid, (Ptr{UInt8},), pointer(img) - 8)
end

function write_png(filepath::String, img::Array{UInt32, 2})
	h, w = size(img)
	ccall((:writePng, "simplepng"), Cvoid, (Cstring, Ptr{Int32}, Int32, Int32), filepath, pointer(img), w, h)
end

function load_png_bytes(filepath::String)::Array{UInt8, 3}
	imgptr = ccall((:loadPng, "simplepng"), Ptr{UInt8}, (Cstring,), filepath)
	
	w, h = unsafe_wrap(Array{UInt32, 1}, imgptr, (2,))

	img = unsafe_wrap(Array{UInt8, 2}, imgptr + 8, (h, w, 4))

	finalizer(free_img, img)

	return img
end

function write_png(filepath::String, img::Array{UInt8, 3})
	h, w, c = size(img)
	ccall((:writePng, "simplepng"), Cvoid, (Cstring, Ptr{Int8}, Int32, Int32), filepath, pointer(img), w, h)
end

end