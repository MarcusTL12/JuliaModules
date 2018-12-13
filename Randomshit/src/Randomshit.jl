
function l(x::Int, y::Int, n::Int)::Vector{Tuple{Int, Int}}
	mov::Vector{Tuple{Int, Int}} = [
		(x + 1, y + 2), (x - 1, y + 2), (x - 2, y + 1), (x - 2, y - 1),
		(x - 1, y - 2), (x + 1, y - 2), (x + 2, y - 1), (x + 2, y + 1)
	]

	return [i for i in mov if i[1] >= 1 && i[1] <= n && i[2] >= 1 && i[2] <= n]
end


function chess(n::Int, k::Int)::Array{Float64}
	p::Array{Float64, 3} = Array{Float64, 3}(undef, (n, n, k + 1))
	p[:, :, 1] .= 1

	for i in 2 : k + 1
		for x in 1 : n
			for y in 1 : n
				p[x, y, i] = (1 / 8) * sum([p[x_, y_, i - 1] for (x_, y_) in l(x, y, n)])
			end
		end
	end

	# return p[:, :, k + 1]
	return p[1, 1, :]
end
