__precompile__(true)


module MathParse


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


end
