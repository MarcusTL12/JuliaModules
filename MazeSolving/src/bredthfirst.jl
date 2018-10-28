

function bfs(maze::Maze)::Array{Tuple{Int, Int}, 1}
	que::Queue{Tuple{Int, Int}} = Queue{Tuple{Int, Int}}()
	if maze.entr[1] == 1
		start = (maze.entr[1] + 1, maze.entr[2])
		enqueue!(que, start)
		set_mazecolor(maze, start, 0xffafafaa)
	elseif maze.entr[2] == 1
		start = (maze.entr[1], maze.entr[2] + 1)
		enqueue!(que, start)
		set_mazecolor(maze, start, 0xffafafab)
	elseif maze.entr[1] == maze.w
		start = (maze.entr[1] - 1, maze.entr[2])
		enqueue!(que, start)
		set_mazecolor(maze, start, 0xffafafac)
	else
		start = (maze.entr[1], maze.entr[2] - 1)
		enqueue!(que, start)
		set_mazecolor(maze, start, 0xffafafad)
	end
	set_mazecolor(maze, maze.entr, 0xff00ff00)

	maxque = 1

	while length(que) > 0
		cur_pos = dequeue!(que)
		if cur_pos == maze.exit
			break
		end
		dirs = get_dirs(maze, cur_pos)
		if dirs & 1 != 0
			chk_pos = (cur_pos[1] + 1, cur_pos[2])
			set_mazecolor(maze, chk_pos, 0xffafafaa)
			enqueue!(que, chk_pos)
		end
		if dirs & 2 != 0
			chk_pos = (cur_pos[1], cur_pos[2] + 1)
			set_mazecolor(maze, chk_pos, 0xffafafab)
			enqueue!(que, chk_pos)
		end
		if dirs & 4 != 0
			chk_pos = (cur_pos[1] - 1, cur_pos[2])
			set_mazecolor(maze, chk_pos, 0xffafafac)
			enqueue!(que, chk_pos)
		end
		if dirs & 8 != 0
			chk_pos = (cur_pos[1], cur_pos[2] - 1)
			set_mazecolor(maze, chk_pos, 0xffafafad)
			enqueue!(que, chk_pos)
		end
		maxque = maxque < length(que) ? length(que) : maxque
	end

	# println(maxque)

	if get_mazecolor(maze, maze.exit) == 0xffffffff
		return []
	end

	ret = [maze.exit]

	cur_x, cur_y = maze.exit

	while (cur_x, cur_y) != maze.entr
		cur_col = get_mazecolor(maze, (cur_x, cur_y))
		set_mazecolor(maze, (cur_x, cur_y), 0xffff9400)
		if cur_col == 0xffafafaa
			cur_x -= 1
		elseif cur_col == 0xffafafab
			cur_y -= 1
		elseif cur_col == 0xffafafac
			cur_x += 1
		elseif cur_col == 0xffafafad
			cur_y += 1
		end
		push!(ret, (cur_x, cur_y))
	end

	set_mazecolor(maze, maze.exit, 0xff0000ff)

	reverse!(ret)

	return ret
end
