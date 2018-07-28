mutable struct Counter{T}
    counts::Dict{T,Int}
    total::Int
end

Counter() = Counter{Any}(Dict{Any,Int}(), 0)

function Counter{T}() where T
    Counter{T}(Dict{T,Int}(), 0)
end

function Counter(xs::AbstractArray)
    T = eltype(xs)
    counts = Dict{T,Int}()
    total = 0
    for x in xs
        counts[x] = get(counts, x, 0) + 1
        total += 1
    end
    Counter{T}(counts, total)
end

function Counter(d::Dict)
    T = eltype(keys(d))
    Counter{T}(d, sum(values(d)))
end

function Counter{T}(kv) where T
    try
        counts = Dict(kv)
        total = sum(values(counts))
        Counter{T}(counts, total)
    catch
        try
            return Counter{T}(collect(kv))
        catch
            throw(ArgumentError("Counter(kv): kv needs to be an iterator of (x, Int) tuples or pairs."))
        end
    end
end

function inc!(ctr::Counter, x, n::Int=1)
    ctr.counts[x] = get(ctr.counts, x, 0) + n
    ctr.total += n    
end

total(ctr::Counter) = ctr.total
# count(ctr::Counter, x, default::Int=0) = get(ctr.counts, x, default)
Base.count(ctr::Counter, x, default::Int=0) = get(ctr.counts, x, default)

function argmax(ctr::Counter)
    if length(ctr.counts) > 0
        ((x,count), state) = iterate(ctr.counts)
        @show x count state
        max_x, max_count = x, count
        while state !== nothing
            @show ctr.counts state
            println("---")
            ((x, count), state) = iterate(ctr.counts, state)
            @show x count state
            if count > max_count
                max_x, max_count = x, count
                println("lol")
            end
        end
        return max_x
    else
        error("Cannot call argmax on an empty Counter")
    end
end

Base.getindex(c::Counter, x) = get(c.counts, x, 0)
Base.length(c::Counter) = length(c.counts)
Base.sum(c::Counter) = c.total

Base.start(c::Counter) = start(c.counts)
Base.next(c::Counter, state) = next(c.counts, state)
Base.done(c::Counter, state) = done(c.counts, state)

Base.keys(c::Counter) = keys(c.counts)
Base.values(c::Counter) = values(c.counts)

Base.copy(c::Counter) = Counter(c.counts, c.total)

Base.show(io::IO, ctr::Counter) = print(io, "<Counter with $(total(ctr)) total, $(length(ctr)) unique>")

function ==(c1::Counter, c2::Counter)
    a, b = keys(c1), keys(c2)
    for x in union(a, b)
        if count(c1, x) != count(c2, x)
            return false
        end
    end
    if length(setdiff(a, b)) != 0 || length(setdiff(b, a)) != 0
        return false
    end
    return true
end
