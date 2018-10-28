

using BitStreamLib

mutable struct Node
	value::UInt8
	leftptr::Union{Node, Nothing}
	rightptr::Union{Node, Nothing}
	Node() = new(0, nothing, nothing)
	Node(x, y, z) = new(x, y, z)
end


function min_heapify!(a::Array{Tuple{Int, Node}}, s::Int, i::Int)
	l = i * 2
	r = i * 2 + 1
	m = 0
	if l <= s && a[l][1] < a[i][1]
		m = l
	else
		m = i
	end

	if r <= s && a[r][1] < a[m][1]
		m = r
	end

	if m != i
		a[i], a[m] = a[m], a[i]
		min_heapify!(a, s, m)
	end
end


function build_queue(elements::Dict{UInt8, Int})::Array{Tuple{Int, Node}, 1}
	queue::Array{Tuple{Int, Node}, 1} = Array{Tuple{Int, Node}, 1}(undef, length(elements))
	s::Int = length(elements)

	el_vals = collect(values(elements))
	el_keys = collect(keys(elements))

	for i in 1 : s
		queue[i] = el_vals[i], Node(el_keys[i], nothing, nothing)
	end

	for i in cld(s, 2) : -1 : 1
		min_heapify!(queue, s, i)
	end

	return queue
end


function dequeue(queue::Array{Tuple{Int, Node}, 1}, s::Int)::Tuple{Int, Node}
	ret = queue[1]
	queue[1], queue[s] = queue[s], queue[1]
	min_heapify!(queue, s - 1, 1)
	return ret
end


function enqueue(queue::Array{Tuple{Int, Node}, 1}, s::Int, val::Tuple{Int, Node})
	if s == length(queue)
		push!(queue, val)
	else
		queue[s + 1] = val
	end
	i::Int = s + 1
	while i > 1 && queue[i][1] < queue[fld(i, 2)][1]
		p::Int = fld(i, 2)
		queue[i], queue[p] = queue[p], queue[i]
		i = p
	end
end


function make_huff_tree(data::Array{UInt8, 1})::Node
	count_list::Dict{UInt8, Int} = Dict()

	for i in data
		if !haskey(count_list, i)
			push!(count_list, i => 1)
		else
			count_list[i] += 1
		end
	end

	queue = build_queue(count_list)
	s = length(queue)

	while s > 1
		n1 = dequeue(queue, s)
		n2 = dequeue(queue, s - 1)
		n3 = (n1[1] + n2[1], Node(0, n1[2], n2[2]))
		enqueue(queue, s - 2, n3)
		s -= 1
	end
	return queue[1][2]
end


function make_huff_tree(data::String)::Node
	return make_huff_tree(translate(data))
end


function translate(data::String)::Array{UInt8, 1}
	int_data = Array{UInt8, 1}(undef, length(data))

	for i in 1 : length(data)
		int_data[i] = Int(data[i])
	end

	return int_data
end


function translate(data::Array{UInt8, 1})::String
	ret = ""

	for i in data
		ret *= Char(i)
	end

	return ret
end


function generate_mapping!(encode_table::Dict{UInt8, String}, cur_node::Node, cur_bin::Array{Bool, 1}, s::Int)
	if cur_node.leftptr == nothing
		bin = ""
		for i in 1 : s
			bin *= cur_bin[i] ? "1" : "0"
		end
		push!(encode_table, cur_node.value => bin)
		return
	end

	if s == length(cur_bin)
		push!(cur_bin, false)
	else
		cur_bin[s + 1] = false
	end
	generate_mapping!(encode_table, cur_node.leftptr, cur_bin, s + 1)

	cur_bin[s + 1] = true
	generate_mapping!(encode_table, cur_node.rightptr, cur_bin, s + 1)
end


function generate_mapping(huff_tree::Node)::Dict
	encode_table::Dict{UInt8, String} = Dict()

	generate_mapping!(encode_table, huff_tree, Array{Bool, 1}(undef, 4), 0)

	return encode_table
end


function get_decode_map(encode_table::Dict{UInt8, String})::Dict{String, UInt8}
	ret::Dict{String, UInt8} = Dict()

	for i in keys(encode_table)
		push!(ret, encode_table[i] => i)
	end

	return ret
end


function huff_encode(encode_table::Dict{UInt8, String}, data::String)::String
	ret = ""

	for i in data
		ret *= encode_table[UInt8(i)]
	end

	return ret
end


function huff_decode_str(decode_table::Dict{String, UInt8}, bin_data::String)::String
	ret = ""

	cur_bin = ""

	for i in bin_data
		cur_bin *= i
		if haskey(decode_table, cur_bin)
			ret *= Char(decode_table[cur_bin])
			cur_bin = ""
		end
	end

	return ret
end


function huff_encode(encode_table::Dict{UInt8, String}, data::Array{UInt8, 1})::BitStream
	ret = BitStream()
	for i in data
		temp_dat = encode_table[i]
		for j in temp_dat
			bit::Bool = j == '1'
			push!(ret, bit)
		end
	end
	return ret
end


function huff_encode(enc_tree::Node, data::Array{UInt8, 1})::BitStream
	return huff_encode(generate_mapping(enc_tree), data)
end


function huff_encode(enc_tree::Node, data::String)::BitStream
	return huff_encode(enc_tree, translate(data))
end


function huff_decode(decode_table::Dict{String, UInt8}, bin_data::BitStream)::Array{UInt8, 1}
	ret::Array{UInt8, 1} = Array{UInt8, 1}(undef, 0)
	
	cur_bin::String = ""

	for i in 1 : length(bin_data)
		cur_bin *= get(bin_data, i) ? '1' : '0'

		if haskey(decode_table, cur_bin)
			push!(ret, decode_table[cur_bin])
			cur_bin = ""
		end
	end

	return ret
end


function huff_decode(dec_tree::Node, bin_data::BitStream)::Array{UInt8, 1}
	return huff_decode(get_decode_map(generate_mapping(dec_tree)), bin_data)
end


function huff_decode_str(decode_table::Dict{String, UInt8}, bin_data::BitStream)::String
	return translate(huff_decode(decode_table, bin_data))
end


function read_file(file_name::String)::Array{UInt8, 1}
	strm = open(file_name)
	seekend(strm)
	eof = position(strm)
	seekstart(strm)

	ret::Array{UInt8, 1} = Array{UInt8, 1}(undef, eof)

	readbytes!(strm, ret)

	close(strm)

	return ret
end


function write_file(file_name::String, data::Array{UInt8, 1})
	io = open(file_name, "w")

	write(io, data)

	close(io)
end


function compress_tree(tree::Node, save::Array{UInt8, 1}, s::Int)
	if tree.leftptr == nothing
		save[s] = 0
		save[s + 1] = tree.value
	else
		save[s] = UInt8(fld(length(save), 2))
		push!(save, 0)
		push!(save, 0)
		compress_tree(tree.leftptr, save, length(save) - 1)
		save[s + 1] = UInt8(fld(length(save), 2))
		push!(save, 0)
		push!(save, 0)
		compress_tree(tree.rightptr, save, length(save) - 1)
	end
end


function compress_tree(tree::Node, save::Array{UInt16, 1}, s::Int)
	if tree.leftptr == nothing
		save[s] = 0
		save[s + 1] = tree.value
	else
		save[s] = UInt16(fld(length(save), 2))
		push!(save, 0)
		push!(save, 0)
		compress_tree(tree.leftptr, save, length(save) - 1)
		save[s + 1] = UInt16(fld(length(save), 2))
		push!(save, 0)
		push!(save, 0)
		compress_tree(tree.rightptr, save, length(save) - 1)
	end
end


function to_byte_array(data::Array{UInt16, 1})::Array{UInt8}
	ret::Array{UInt8, 1} = zeros(UInt8, length(data) * 2)

	for i in 1 : length(data)
		ret[(i - 1) * 2 + 1] = UInt8(data[i] & 255)
		ret[i * 2] = UInt8((data[i] & (255 << 8)) >> 8)
	end

	return ret
end


function compress_tree(tree::Node)::Union{Array{UInt8, 1}, Array{UInt16, 1}}
	if length(generate_mapping(tree)) > 128
		save2::Array{UInt16, 1} = UInt16[0, 0]
		compress_tree(tree, save2, 1)
		return save2
	else
		save::Array{UInt8, 1} = UInt8[0, 0]
		compress_tree(tree, save, 1)
		return save
	end
end


function decompress_tree(comp_tree::Union{Array{UInt8, 1}, Array{UInt16, 1}}, s::Int, cur_node::Node)
	if comp_tree[s] == 0
		cur_node.leftptr = nothing
		cur_node.rightptr = nothing
		cur_node.value = comp_tree[s + 1]
	else
		cur_node.leftptr = Node()
		decompress_tree(comp_tree, comp_tree[s] * 2 + 1, cur_node.leftptr)
		cur_node.rightptr = Node()
		decompress_tree(comp_tree, comp_tree[s + 1] * 2 + 1, cur_node.rightptr)
	end
end


function decompress_tree(comp_tree::Union{Array{UInt8, 1}, Array{UInt16, 1}})::Node
	root::Node = Node()
	decompress_tree(comp_tree, 1, root)
	return root
end


function write_to_file(filename::String, data::BitStream, tree::Array{UInt8, 1})
	io = open(filename, "w")
	
	write(io, Int64(length(data)))

	write(io, UInt16(length(tree)))

	write(io, tree)

	write(io, data.data)

	close(io)
end


function write_to_file(filename::String, data::BitStream, tree::Array{UInt16, 1})
	write_to_file(filename, data, to_byte_array(tree))
end


function write_to_file(filename::String, data::BitStream, tree::Node)
	write_to_file(filename, data, compress_tree(tree))
end


function compress_file(filein::String, fileout::String)
	data = read_file(filein)

	tree = make_huff_tree(data)

	comp_data = huff_encode(tree, data)

	write_to_file(fileout, comp_data, compress_tree(tree))
end


function decode_file(filename::String)::Array{UInt8, 1}
	io = open(filename, "r")

	bit_length::Int64 = read(io, Int64)

	tree_length::UInt16 = read(io, UInt16)

	comp_tree::Array{UInt8, 1} = Array{UInt8, 1}(undef, tree_length)

	readbytes!(io, comp_tree)

	comp_data::Array{UInt8, 1} = Array{UInt8, 1}(undef, cld(bit_length, 8))

	readbytes!(io, comp_data)

	close(io)

	comp_data_strm::BitStream = BitStream(comp_data, bit_length)

	println("hei1")

	tree::Node = decompress_tree(comp_tree)

	println("hei2")

	data = huff_decode(tree, comp_data_strm)

	return data
end


function decompress_file(filein::String, fileout::String)
	write_file(fileout, decode_file(filein))
end
