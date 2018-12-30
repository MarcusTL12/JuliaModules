

module LazyHelp

using Lazy

export @take
macro take(amt, l)
	:(take($(esc(amt)), $(esc(l))))
end

export @takewhile
macro takewhile(cond, l)
	:(takewhile($(esc(cond)), $(esc(l))))
end

export @map
macro map(f, l)
	:(map($(esc(f)), $(esc(l))))
end

export @length
macro length(l)
	:(length($(esc(l))))
end

export @<|
macro <|(f, args...)
	:(($(esc(f)))(($(esc(args)))...))
end


function fib()
	function rec(n::Int)
		(n == 1 || n == 2) && return 1
		return memo[n - 1] + memo[n - 2]
	end
	memo = @map rec Lazy.range(1)
	memo
end


end
