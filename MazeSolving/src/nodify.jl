

mutable struct Node
	coord::Tuple{Int, Int}
	parent::Int
	id::Int
	status::UInt8
end


function find_node(nodes::Array{Node, 1}, coord::Tuple{Int, Int})::Int
	for i in 1 : length(nodes)
		if nodes[i].coord == coord
			return i
		end
	end
	return 0
end


function nodify(maze::Maze)::Tuple{Array{Node, 1}, Array{Tuple{Int, Int, Int}, 1}}
	edges::Array{Tuple{Int, Int, Int}, 1} = []
	nodes::Array{Node, 1} = []
	dirs::UInt8 = 0
	if maze.entr[1] == 1
		dirs = 1
	elseif maze.entr[2] == 1
		dirs = 2
	elseif maze.entr[1] == maze.w
		dirs = 4
	else
		dirs = 8
	end
	push!(nodes, Node(maze.entr, 0, 1, 0))
	push!(nodes, Node(maze.exit, 0, 2, 0))
	set_mazecolor(maze, maze.entr, 0xff7fff00)
	set_mazecolor(maze, maze.exit, 0xff7fff00)
	nodify(maze, 1, dirs, nodes, edges)
	return nodes, edges
end


function nodify(maze::Maze, node::Int, dirs::UInt8, nodes::Array{Node, 1}, edges::Array{Tuple{Int, Int, Int}, 1})
	x, y = nodes[node].coord
	if dirs & 1 != 0
		l = 1
		x += 1
		while get_mazecolor(maze, (x + 1, y)) == 0xffffffff && get_mazecolor(maze, (x, y + 1)) == 0xff000000 && get_mazecolor(maze, (x, y - 1)) == 0xff000000
			x += 1
			l += 1
		end
		if (get_mazecolor(maze, (x + 1, y)) == 0xff000000 || get_mazecolor(maze, (x + 1, y)) == 0xffffffff) && get_mazecolor(maze, (x, y)) == 0xffffffff
			push!(nodes, Node((x, y), node, length(nodes) + 1, 0))
			push!(edges, (node, length(nodes), l))
			set_mazecolor(maze, (x, y), 0xff7fff00)
			nodify(maze, length(nodes), get_dirs(maze, (x, y)), nodes, edges)
		else
			push!(edges, (node, find_node(nodes, (x + 1, y)), l + 1))
		end
	end
	x, y = nodes[node].coord
	if dirs & 2 != 0
		l = 1
		y += 1
		while get_mazecolor(maze, (x, y + 1)) == 0xffffffff && get_mazecolor(maze, (x + 1, y)) == 0xff000000 && get_mazecolor(maze, (x - 1, y)) == 0xff000000
			y += 1
			l += 1
		end
		if (get_mazecolor(maze, (x, y + 1)) == 0xff000000 || get_mazecolor(maze, (x, y + 1)) == 0xffffffff) && get_mazecolor(maze, (x, y)) == 0xffffffff
			push!(nodes, Node((x, y), node, length(nodes) + 1, 0))
			push!(edges, (node, length(nodes), l))
			set_mazecolor(maze, (x, y), 0xff7fff00)
			nodify(maze, length(nodes), get_dirs(maze, (x, y)), nodes, edges)
		else
			push!(edges, (node, find_node(nodes, (x, y + 1)), l + 1))
		end
	end
	x, y = nodes[node].coord
	if dirs & 4 != 0
		l = 1
		x -= 1
		while get_mazecolor(maze, (x - 1, y)) == 0xffffffff && get_mazecolor(maze, (x, y + 1)) == 0xff000000 && get_mazecolor(maze, (x, y - 1)) == 0xff000000
			x -= 1
			l += 1
		end
		if (get_mazecolor(maze, (x - 1, y)) == 0xff000000 || get_mazecolor(maze, (x - 1, y)) == 0xffffffff) && get_mazecolor(maze, (x, y)) == 0xffffffff
			push!(nodes, Node((x, y), node, length(nodes) + 1, 0))
			push!(edges, (node, length(nodes), l))
			set_mazecolor(maze, (x, y), 0xff7fff00)
			nodify(maze, length(nodes), get_dirs(maze, (x, y)), nodes, edges)
		else
			push!(edges, (node, find_node(nodes, (x - 1, y)), l + 1))
		end
	end
	x, y = nodes[node].coord
	if dirs & 8 != 0
		l = 1
		y -= 1
		while get_mazecolor(maze, (x, y - 1)) == 0xffffffff && get_mazecolor(maze, (x + 1, y)) == 0xff000000 && get_mazecolor(maze, (x - 1, y)) == 0xff000000
			y -= 1
			l += 1
		end
		if (get_mazecolor(maze, (x, y - 1)) == 0xff000000 || get_mazecolor(maze, (x, y - 1)) == 0xffffffff) && get_mazecolor(maze, (x, y)) == 0xffffffff
			push!(nodes, Node((x, y), node, length(nodes) + 1, 0))
			push!(edges, (node, length(nodes), l))
			set_mazecolor(maze, (x, y), 0xff7fff00)
			nodify(maze, length(nodes), get_dirs(maze, (x, y)), nodes, edges)
		else
			push!(edges, (node, find_node(nodes, (x, y - 1)), l + 1))
		end
	end
end


function index_of_id(nodes::Array{Node, 1}, id::Int, s::Int=0, r::Int=0)::Int
	if s == 0
		s = 1
		r = length(r)
	end
	if s == r
		return s
	end
	index = fld(s + r, 2)
	if nodes[index].id == ind
		return index
	elseif nodes[index].id > id
		return index_of_id(nodes, id, s, index - 1)
	else
		return index_of_id(nodes, id, indes + 1, r)
	end
end


function remove_dead_ends(nodes::Array{Node, 1}, edges::Array{Tuple{Int, Int, Int}, 1})
	no_dead_ends = false

	while !no_dead_ends
		loners = []
		for i in 3 : length(nodes)
			neighbours::Int = 0
			for edge in edges
				if i in edge
					neighbours += 1
				end
			end
			if neighbours <= 1
				push!(loners, i)
			end
		end
		if length(loners) == 0
			no_dead_ends = true
		else
			for i in length(loners) : -1 : 1
				deleteat!(nodes, loners[i])
			end
			i = length(edges)
			while i >= 1
				if edges[i][1] in loners || edges[i][2] in loners
					deleteat!(edges, i)
					i -= 1
				end
				i -= 1
			end

			for i in 1 : length(edges)
				edges[i] = (index_of_id(nodes, edges[i][1]), index_of_id(nodes, edges[i][2]), edges[i][3])
			end
			
			for i in 1 : length(nodes)
				nodes[i].id = i
			end
		end
	end
end


function mark_nodes(maze::Maze, nodes::Array{Node, 1})
	for i in nodes
		set_mazecolor(maze, i.coord, 0xff7fff00)
	end
end

