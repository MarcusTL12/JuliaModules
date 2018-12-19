__precompile__(true)


module DirLang


function test()
	fields, lines = parse_dir("res/DirLang/Hello World")
	
	for i in lines
		run_line(fields, i)
	end
end


function parse_dir(path::String)
	types::Dict{String, Type} = Dict{String, Type}([
		"Int" 		=> Int,
		"Float" 	=> Float64,
		"String" 	=> String
	])
	t::String = readdir(joinpath(path, "__Type"))[1]
	if t == "Func"
		return parse_func(path)
	elseif haskey(types, t)
		v::String = readdir(joinpath(path, "__Val"))[1]
		t == "String" && return v
		return parse(types[t], v)
	end
end


function parse_func(path::String)
	codelines::Vector{Int},
	fields::Dict{String, Any} =
	let a::Vector{String} = readdir(path)
		sort!([parse(Int, i) for i in a
			if mapreduce(isnumeric, (x, y) -> x && y, i)]),
		
		Dict{String, Any}([i[2:end] => parse_dir(joinpath(path, i))
			for i in a if i[1] == '_' && i[2] != '_'])
	end
	
	lines::Vector{Tuple{String, Vector{String}}} = Vector{Tuple{String, Vector{String}}}(undef, 0)
	
	for i in codelines
		f = readdir(joinpath(path, string(i)))[1]
		argsind = let
			sort!([parse(Int, i) for i in readdir(joinpath(path, string(i), f, "__Args"))
				if mapreduce(isnumeric, (x, y) -> x && y, i)])
		end
		args = Vector{String}()
		for j in argsind
			push!(args, readdir(joinpath(path, string(i), f, "__Args", string(j)))[1])
		end
		push!(lines, (f, args))
	end
	
	return fields, lines
end


function run_line(fields::Dict{String, Any}, line::Tuple{String, Vector{String}})
	funcs = Dict([
		"print" => print
		"println" => println
	])
	args = [fields[i] for i in line[2]]
	funcs[line[1]](args...)
end


end

