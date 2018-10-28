
function select_left!(a, p, r, v)
	i = p
	if p < r
		q = partition!(a, p, r - 1)
		if v <= a[q]
			i = select_left!(a, p, q, v)
		else
			i = select_left!(a, q + 1, r, v)
		end
	end
	return i
end


function select_right!(a, p, r, v)
	i = p
	if p < r
		q = partition!(a, p, r - 1)
		if v < a[q]
			i = select_right!(a, p, q, v)
		else
			i = select_right!(a, q + 1, r, v)
		end
	end
	return i
end


function select_element!(a, p, r, i)
	q = partition!(a, p, r - 1)
	if q == i
		return a[q]
	elseif q > i
		return select_element!(a, p, q, i)
	else
		return select_element!(a, q + 1, r, i)
	end
end


function select_element!(a, i)
	return select_element!(a, 1, length(a) + 1, i)
end


function select_element(a, i)
	return select_element!(copy(a), i)
end


function select_left!(a, v)
	select_left!(a, 1, length(a) + 1, v)
end


function select_right!(a, v)
	select_right!(a, 1, length(a) + 1, v)
end


function select_left(a, v)
	select_left!(copy(a), v)
end


function select_right(a, v)
	select_right!(copy(a), v)
end
