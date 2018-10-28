function dfs(maze::Maze, cur_pos::Tuple{Int, Int})::Array{Tuple{Int, Int}, 1}
	if cur_pos == maze.exit
		set_mazecolor(maze, cur_pos, 0xffff0000)
		return [cur_pos]
	end
	set_mazecolor(maze, cur_pos, 0xffafafaf)
	dirs = get_dirs(maze, cur_pos)

	ret = [cur_pos]
	if dirs & 1 != 0
		chk_pos = (cur_pos[1] + 1, cur_pos[2])
		temp = dfs(maze, chk_pos)
		if length(temp) > 0
			set_mazecolor(maze, cur_pos, 0xffff9400)
			append!(ret, temp)
			return ret
		end
	end
	if dirs & 2 != 0
		chk_pos = (cur_pos[1], cur_pos[2] + 1)
		temp = dfs(maze, chk_pos)
		if length(temp) > 0
			set_mazecolor(maze, cur_pos, 0xffff9400)
			append!(ret, temp)
			return ret
		end
	end
	if dirs & 4 != 0
		chk_pos = (cur_pos[1] - 1, cur_pos[2])
		temp = dfs(maze, chk_pos)
		if length(temp) > 0
			set_mazecolor(maze, cur_pos, 0xffff9400)
			append!(ret, temp)
			return ret
		end
	end
	if dirs & 8 != 0
		chk_pos = (cur_pos[1], cur_pos[2] - 1)
		temp = dfs(maze, chk_pos)
		if length(temp) > 0
			set_mazecolor(maze, cur_pos, 0xffff9400)
			append!(ret, temp)
			return ret
		end
	end
	return []
end


function dfs(maze::Maze)::Array{Tuple{Int, Int}, 1}
	sx = maze.entr[1]
	sy = maze.entr[2]

	maze.data[sy, sx] = 0xff00ff00

	if sx == 1
		sx += 1
	elseif sx == maze.w
		sx -= 1
	elseif sy == 1
		sy += 1
	else
		sy -= 1
	end

	return dfs(maze, (sx, sy))
end