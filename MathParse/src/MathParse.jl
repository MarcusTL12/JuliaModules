__precompile__(true)


module MathParse

import Base.string
import Base.show

export string
export show

function replacewithfunc(s::String, m::Regex, f)
	while (i = match(m, s)) != nothing
		s = replace(s, m => f(i.captures), count=1)
	end
	return s
end


function mparse(s::String)
	s = replace(s, r"\s+" => "")
	s = replace(s, r"(\d)\(" => s"\g<1>*(")
	s = replace(s, r"\)(\d)" => s")*\g<1>")
	s = replace(s, r"\)\(" => s")*(")
	s = replacewithfunc(s, r"\(([^()]*)\)", (t) -> mparse(String(t[1])))
	@show s
	
	r = [(r"(\-?\d+\.?\d*)/(\-?\d+\.?\d*)", /),
		(r"(\-?\d+\.?\d*)\*(\-?\d+\.?\d*)", *),
		(r"(\-?\d+\.?\d*)\+(\-?\d+\.?\d*)", +),
		(r"(\-?\d+\.?\d*)\-(\-?\d+\.?\d*)", -)]

	apply(t, f) = string(f(parse(Float64, t[1]), parse(Float64, t[2])))

	for i in r
		s = replacewithfunc(s, i[1], (t) -> apply(t, i[2]))
	end

	return s
end

ops = [(+, '+'), (-, '-'), (*, '*'), (/, '/')]

mutable struct Mathobj
	op::Int
	left::Union{Mathobj, Float64}
	right::Union{Mathobj, Float64}
end


function treeifyRec(s::String)
	if length(s) == 0
		return Float64(0)
	end
	found = false
	op = 0
	split_ind = -1
	while op < 4 && !found
		op += 1
		par_count::Int = 0
		for i in length(s) : -1 : 1
			if s[i] == ')'
				par_count += 1
			elseif s[i] == '('
				par_count -= 1
			elseif par_count == 0 && s[i] == ops[op][2]
				found = true
				split_ind = i
				break
			end
		end
	end

	if op > 4 || split_ind == -1
		if s[1] == '('
			return treeifyRec(s[2 : end - 1])
		else
			return parse(Float64, s)
		end
	end

	return Mathobj(op, treeifyRec(s[1 : split_ind - 1]), treeifyRec(s[split_ind + 1 : end]))
end


function treeify(s::String)
	s = replace(s, r"\s+" => "")
	s = replace(s, r"(\d)\(" => s"\g<1>*(")
	s = replace(s, r"\)(\d)" => s")*\g<1>")
	s = replace(s, r"\)\(" => s")*(")
	treeifyRec(s)
end


eval(obj::Mathobj)::Float64 = ops[obj.op][1](eval(obj.left), eval(obj.right))



string(mo::Mathobj) = (ops[mo.op][2], string(mo.left), string(mo.right))


function show(io::IO, mo::Mathobj)
	print(io, string(mo))
end


mtparse(s::String)::Float64 = eval(treeify(s))


end
