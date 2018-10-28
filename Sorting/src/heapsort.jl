

function max_heapify!(a::Array, s::Int, i::Int)
	l = i * 2
	r = i * 2 + 1
	m = 0
	if l <= s && a[l] > a[i]
		m = l
	else
		m = i
	end

	if r <= s && a[r] > a[m]
		m = r
	end

	if m != i
		a[i], a[m] = a[m], a[i]
		max_heapify!(a, s, m)
	end
end


function make_heap!(a::Array)
	s = length(a)
	for i in fld(length(a), 2) : -1 : 1
		max_heapify!(a, s, i)
	end
end


function heapsort!(a::Array)
	make_heap!(a)
	s = length(a)
	for i in length(a) : -1 : 2
		a[1], a[s] = a[s], a[1]
		s -= 1
		max_heapify!(a, s, 1)
	end
end
