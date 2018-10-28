__precompile__(true)

module Sorting

	function is_sorted(data::Array)
		sorted = true
		for i in 1 : length(data) - 1
			sorted &= data[i + 1] >= data[i]
		end
		
		return sorted
	end

	function is_sorted(data::Array, length::Int)
		sorted = true
		for i in 1 : length - 1
			sorted &= data[i + 1] >= data[i]
		end
		
		return sorted
	end


	function median!(a::Array)
		p, r = 1, length(a) + 1
		mid = fld(r + p, 2)
		if (r - p) % 2 == 0
			return (select_element!(a, mid) + select_element!(a, mid - 1)) / 2
		else
			return select_element!(a, mid)
		end
	end


	function median(a::Array)
		return median!(copy(a))
	end


	include("insertionsort.jl")
	include("bubblesort.jl")
	include("quicksort.jl")
	include("mergesort.jl")
	include("bisect.jl")
	include("select.jl")
	include("radix.jl")
	include("heapsort.jl")
	include("filesort.jl")
end

