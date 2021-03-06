"""Index{T}

Bijective mapping between things (of type T) and integers.
"""
mutable struct Index{T}
    i::Int
    x2int::Dict{T,Int}
    int2x::Vector{T}
end
Index(args...) = Index{Any}(args...)
Index{T}() where T = Index(1, Dict{T,Int}(), T[])
Index(xs) = Index{eltype(xs)}(xs)
function Index{T}(xs) where T
    index = Index{T}()
    for x in xs
        get!(index.x2int, x) do
            index.i += 1
            push!(index.int2x, x)
            index.i - 1
        end
    end
    return index
end


"""    id(idx::Index, x, notfound)

Get the id of the item x (without updating), returning `notfound` if not present.
"""
id(idx::Index, x, notfound) = get(idx.x2int, x, notfound)

"""    id(idx::Index, x)

Get the id of the item x (without updating), throwing an error if not found.
"""
id(idx::Index, x) = idx.x2int[x]

"""    ids(idx::Index, xs, notfound)

Get the ids of xs (without updating), returning `notfound` if not present.
"""
ids(idx::Index, xs, notfound) = [get(idx.x2int, x, notfound) for x in xs]

"""    ids(idx::index, x)

get the ids of xs (without updating), throwing an error if not found.
"""
ids(idx::Index, xs) = [idx.x2int[x] for x in xs]

"""    id!(idx::index, x)

Get the id of x, updating the index if necessary.
"""
function id!(idx::Index{T}, x::T) where T
    get!(idx.x2int, x) do
        idx.i += 1
        push!(idx.int2x, x)
        return idx.i - 1
    end
end
id!(idx::Index, x) = id!(idx, convert(typeof(idx), x))

ids!(index::Index, xs) = [id!(index, x) for x in xs]

Base.length(index::Index) = length(index.int2x)
