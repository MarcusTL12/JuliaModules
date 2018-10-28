

function reset!(maze::Maze)
	for i in 1 : maze.h
		for j in 1 : maze.w
			if get_mazecolor(maze, (j, i)) != 0
				set_mazecolor(maze, (j, i), 0xffffffff)
			end
		end
	end	
end


function clutter!(maze::Maze, p::Float64)
	for i in 2 : maze.h - 1
		for j in 2 : maze.w - 1
			if rand(Float64) < p
				if get_mazecolor(maze, (j, i)) == 0
					set_mazecolor(maze, (j, i), 0xffffffff)
				else
					set_mazecolor(maze, (j, i), 0xff000000)
				end
			end
		end
	end
end


function make_random!(maze::Maze, p::Float64)
	for i in 2 : maze.h - 1
		for j in 2 : maze.w - 1
			if rand(Float64) < p
				set_mazecolor(maze, (j, i), 0xff000000)
			else
				set_mazecolor(maze, (j, i), 0xffffffff)
			end
		end
	end
end
