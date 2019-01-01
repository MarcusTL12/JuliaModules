
mutable struct LazyNode{T}
	data::Union{T, Nothing}
	realised::Bool
	f::Union{Function, Nothing}
	LazyNode{T}(f::Function) where T = new{T}(nothing, false, f)
	LazyNode(v::T) where T = new{T}(v, true, nothing)
end


export LazyArray
struct LazyArray{T, N}
	data::Array{LazyNode{T}, N}
	LazyArray{T, N}(dims::Int...) where T where N =
		new{T, N}(Array{LazyNode{T}, N}(undef, dims))
end

function LazyArray{T}(dims::Int...) where T
	LazyArray{T, length(dims)}(dims...)
end

function LazyArray(l::Array{T}) where T
	r = LazyArray{T}(size(l)...)
	r.data .= map(x -> LazyNode(x), l)
	r
end


export LazyVector
LazyVector{T} = LazyArray{T, 1}

LazyVector(l::Array{T}) where T = LazyArray(l)


import Base.get
export get

get(n::LazyNode) = n.realised ? n.data :
	(n.realised = true; n.data = n.f(); n.f = nothing; n.data)

get(l::LazyArray, indices::Int...) = get(l.data[indices...])


import Base.getindex
export getindex

getindex(l::LazyArray, indices::Int...) = get(l, indices...)

function getindex(l::LazyArray{T}, range::UnitRange) where T
	r = LazyVector{T}(length(range))
	for (i, j) in zip(1 : length(range), range)
		r.data[i] = LazyNode{T}(() -> (l[j]))
	end
	r
end


set(n::LazyNode{T}, v::T) where T = (n.data = v; n.realised = true; n.f = nothing)

set(n::LazyNode, f::Function) = (n.realised = false; n.f = f)

set(l::LazyArray, v, indices::Int...) = set(l.data[indices...], v)


import Base.setindex!
export setindex!

setindex!(l::LazyArray, v, indices::Int...) = set(l, v, indices...)


import Base.length
export length

length(l::LazyArray) = length(l.data)


import Base.size
export size
size(l::LazyArray) = size(l.data)


import Base.iterate
export iterate

iterate(iter::LazyArray, state::Int=1) = state > length(iter) ?
	nothing : (iter[state], state + 1)


import Base.string
export string

string(n::LazyNode) = n.realised ? string(n.data) : "pending"

function string(l::LazyArray)
	r = "["
	for i in 1 : length(l.data)
		r *= string(l.data[i]) * ((i < length(l.data)) ? ", " : "")
	end
	r * "]"
end


import Base.show
export show

show(io::IO, l::LazyArray) = print(io, string(l))


import Base.map
export map

function map(f::Function, l::LazyArray{T}) where T
	r = LazyArray{T}(size(l)...)
	for i in 1 : length(r)
		r.data[i] = LazyNode{T}(() -> f(l[i]))
	end
	r
end


import Base.map!
export map!

function map!(f::Function, l::LazyArray{T}) where T
	ghost = copy(l.data)
	for i in 1 : length(l)
		l.data[i] = LazyNode{T}(() -> f(get(ghost[i])))
	end
end
