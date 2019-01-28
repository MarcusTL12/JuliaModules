__precompile__(true)


module Display


export @display
macro display(args...)
	blk = Expr(:block)
	push!(blk.args, :(io = IOBuffer()))
	for arg in args
		push!(blk.args, :(show(io, "text/plain", $(esc(arg)))))
	end
	push!(blk.args, :(println(String(take!(io)))))
	blk
end

end
