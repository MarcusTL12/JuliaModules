using Memoize

function testlcs()
	s1::String = "Please write comments if you find anything incorrect"
	s2::String = "or you want to share more information about the topic discussed above"
	@time a = lcs(s1, s2)
	@show a
end

function lcs(s1::String, s2::String)
	@memoize function rec(n1::Int, n2::Int)
		(n1 <= 0 || n2 <= 0) && return 0
		return max(	rec(n1 - 1, n2),
					rec(n1, n2 - 1),
					rec(n1 - 1, n2 - 1) +
					(s1[n1] == s2[n2] ? 1 : 0))
	end
	return rec(length(s1), length(s2))
end

