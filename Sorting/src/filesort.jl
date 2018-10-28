

function file_to_array(from::IO, t::DataType)
	seekend(from)
	eof = position(from)
	seekstart(from)
	buffer = Array{t, 1}(undef, fld(eof, sizeof(t)))
	read!(from, buffer)
	return buffer
end


function is_file_sorted(from::IO, t::DataType)
	seekend(from)
	eof = position(from)
	seekstart(from)
	buffer = Array{t, 1}(undef, 1048576)
	sorted = true
	while eof - position(from) >= (1048576 * sizeof(t))
		read!(from, buffer)
		sorted &= is_sorted(buffer)
	end
	if eof - position(from) > 0
		buffer2 = Array{t, 1}(undef, fld(eof - position(from), sizeof(t)))
		read!(from, buffer2)
		sorted &= is_sorted(buffer2)
	end
	return sorted
end


function generate_random_file(to::IO, t::DataType, size::Int)
	seekstart(to)
	while size - position(to) >= 1048576
		write(to, rand(t, 1048576))
	end
	if size - position(to) > 0
		write(to, rand(t, size - position(to)))
	end
end


function generate_random_file(to::IO, t::DataType, size::Int, range)
	seekstart(to)
	while size - position(to) >= 1048576
		buffer::Array{t, 1} = rand(range, 1048576)
		write(to, buffer)
	end
	if size - position(to) > 0
		buffer2::Array{t, 1} = rand(range, size - position(to))
		write(to, buffer2)
	end
end


function merge_into_file(from::IO, to::IO, data::Array, t::DataType)
	seekend(from)
	eof::Int = position(from)
	seekstart(from)
	inbuffer::Array{t, 1} = Array{t, 1}(undef, 1048576)
	outbuffer::Array{t, 1} = Array{t, 1}(undef, 1048576)

	filebuffer_max = fld(eof, sizeof(t)) > 1048576 ? 1048576 : fld(eof, sizeof(t))

	ptrdata::Int32 = 1
	ptrfile::Int32 = 1048576
	optr::Int32 = 1

	moreindata = true
	moreinfile = true

	while moreindata || moreinfile
		if moreinfile && (ptrfile > filebuffer_max)
			if eof - position(from) >= 1048576 * sizeof(t)
				read!(from, inbuffer)
				ptrfile = 1
			elseif eof - position(from) > 0
				filebuffer_max = fld(eof - position(from), 4)
				temp_buffer = Array{t, 1}(undef, fld(eof - position(from), 4))
				read!(from, temp_buffer)
				for i in 1:filebuffer_max
					inbuffer[i] = temp_buffer[i]
				end
				ptrfile = 1
			else
				moreinfile = false
			end
		elseif ptrfile > filebuffer_max
			moreinfile = false
		end
		
		if ptrdata > length(data)
			moreindata = false
		end

		if moreindata && moreinfile
			if data[ptrdata] <= inbuffer[ptrfile]
				outbuffer[optr] = data[ptrdata]
				ptrdata += 1
				optr += 1
			else
				outbuffer[optr] = inbuffer[ptrfile]
				ptrfile += 1
				optr += 1
			end
		elseif moreinfile
			outbuffer[optr] = inbuffer[ptrfile]
			ptrfile += 1
			optr += 1
		end
		
		if optr >= 1048576
			write(to, outbuffer)
			optr = 1
		end
	end
	if optr != 1
		temp_buffer = Array{t, 1}(undef, optr - 1)
		for i in 1:(optr - 1)
			temp_buffer[i] = outbuffer[i]
		end
		write(to, temp_buffer)
	end
end


# function simple_filesort(from::IO, to::IO, t::DataType)

# end


# function filesort(from::IO, to::IO, t::DataType, batch_size=1048576)
# 	seekend(from)
# 	eof = position(from)
# 	seekstart(from)

# 	temp_path = ""

# 	buffer = Array{t, 1}(undef, batch_size)
# 	while eof - position(from) >= (batch_size * sizeof(t))
# 		read!(from, buffer)
# 		quicksort!(buffer)

# 	end
# end
