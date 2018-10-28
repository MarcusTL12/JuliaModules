function bisect_left(A, p, r, v)
	i = p
	if p < r
	   q = floor(Int, (p + r) / 2)
	   if v <= A[q]
		   i = bisect_left(A, p, q, v)
	   else
		   i = bisect_left(A, q + 1, r, v)
	   end
	end
	return i
end


function bisect_right(A, p, r, v)
	i = p
	if p < r
	   q = floor(Int, (p + r) / 2)
	   if v < A[q]
		   i = bisect_right(A, p, q, v)
	   else
		   i = bisect_right(A, q + 1, r, v)
	   end
	end
	return i
end


function bisect_right(A, v)
	return bisect_right(A, 1, length(A) + 1, v)
end


function bisect_left(A, v)
	return bisect_left(A, 1, length(A) + 1, v)
end
