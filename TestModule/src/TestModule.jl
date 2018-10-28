__precompile__()

module TestModule
	export special_add

	include("add.jl")

	function special_add(a, b)
		return add(a, b) + 1
	end
end