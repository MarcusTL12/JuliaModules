__precompile__()

module MazeSolving

using SimpleImage
using DataStructures

export Maze

mutable struct Maze
	data::Array{UInt32, 2}
	w::Int
	h::Int
	entr::Tuple{Int, Int}
	exit::Tuple{Int, Int}
	function Maze(filepath::String)
		mz = load_maze(filepath)
		h, w = size(mz)
		entr, exit = find_endpoints(mz)
		new(mz, w, h, entr, exit)
	end
end


function load_maze(filepath::String)::Array{UInt32, 2}
	return SimpleImage.load_png(filepath)
end


function save_maze(filepath::String, maze::Array{UInt32, 2})
	SimpleImage.write_png(filepath, maze)
end


function save_maze(filepath::String, maze::Maze)
	save_maze(filepath, maze.data)
end


function find_endpoints(maze::Array{UInt32, 2})::Tuple{Tuple{Int, Int}, Tuple{Int, Int}}
	h, w = size(maze)
	points = []

	for i in 1 : h
		if maze[i, 1] == 0xffffffff
			push!(points, (1, i))
			if length(points) > 1
				return (points[1], points[2])
			end
		end
	end
	for i in 1 : w
		if maze[1, i] == 0xffffffff
			push!(points, (i, 1))
			if length(points) > 1
				return (points[1], points[2])
			end
		end
	end
	for i in 1 : h
		if maze[i, w] == 0xffffffff
			push!(points, (w, i))
			if length(points) > 1
				return (points[1], points[2])
			end
		end
	end
	for i in 1 : w
		if maze[h, i] == 0xffffffff
			push!(points, (i, h))
			if length(points) > 1
				return (points[1], points[2])
			end
		end
	end

	return ((0, 0), (0, 0))
end

function mark_endpoints(maze::Array{UInt32, 2})::Tuple{Tuple{Int, Int}, Tuple{Int, Int}}
	entr, exit = find_endpoints(maze)
	maze[entr[2], entr[1]] = 0xff00ff00
	maze[exit[2], exit[1]] = 0xff0000ff
	return entr, exit
end


function get_dirs(maze::Maze, pos::Tuple{Int, Int})::UInt8
	newdirs::UInt8 = 0

	newdirs |= maze.data[pos[2], pos[1] + 1] == 0xffffffff ? 1 : 0
	newdirs |= maze.data[pos[2] + 1, pos[1]] == 0xffffffff ? 2 : 0
	newdirs |= maze.data[pos[2], pos[1] - 1] == 0xffffffff ? 4 : 0
	newdirs |= maze.data[pos[2] - 1, pos[1]] == 0xffffffff ? 8 : 0

	return newdirs
end


get_mazecolor(maze::Maze, pos::Tuple{Int, Int})::UInt32 = maze.data[pos[2], pos[1]]


function set_mazecolor(maze::Maze, pos::Tuple{Int, Int}, color::UInt32)
	maze.data[pos[2], pos[1]] = color
end


include("depthfirst.jl")

include("bredthfirst.jl")

include("mazemanip.jl")

include("nodify.jl")

end

#hei