module Vocab

using  ..CL.Common: Index, Counter
import ..CL.Common.id
import ..CL.Common.ids 
import ..CL.Common.argmax
import ..CL.Common.total

export Vocabulary,
    id, ids, argmax, total

struct Vocabulary{T}
    index::Index{T}
    counts::Counter{T}
    normalize::Function

    """    Vocabulary(tokens; max_size=0, min_freq=1, specials=[], normalize=identity)

Create a Vocabulary object, to represent words (or something else) numerically.
"""
    function Vocabulary{T}(tokens=[]; max_size = 0, min_freq = 1,
                        specials = [], normalize::Function = identity) where T
        normtokens = normalize.(tokens)
        counts = Counter{T}(normtokens)
        c(token) = count(counts, token)
        tokenset = Set(normtokens)
        max_size = max(0, max_size)
        min_freq = max(1, min_freq)
        if min_freq > 1
            check(x) = c(x) >= min_freq && !(x in specials)
            tokenset = filter(check, tokenset)
        end
        tokenset = filter(x -> !(x in specials), tokenset)
        # sort by frequency, then alphabetically (with "special" ones up front)
        # lt_((w1, n1), (w2, n2)) = n1 < n2 || (n2 == n1 && w1 > w2)
        function lt_(w1, w2)
            n1, n2 = c(w1), c(w2)
            return n1 < n2 || (n2 == n1 && w1 > w2)
        end
        sorted_tokens = sort(collect(tokenset), lt = lt_, rev = true)
        normtokens = [specials ; filter(x -> !(x in specials), sorted_tokens)]
        if max_size > 0
            normtokens = normtokens[1:max_size]
        end
        index = Index{T}(normtokens)
        counter = Counter(Dict{T,Int}(word => c(word) for word in normtokens))
        new(index, counter, normalize)
    end
end

Vocabulary(tokens=[]; kwargs...) = Vocabulary{eltype(tokens)}(tokens; kwargs...)

words(vocab::Vocabulary) = vocab.index.int2x

Base.in(vocab::Vocabulary, token) = in(keys(vocab.counts), vocab.normalize(token))
Base.length(vocab::Vocabulary) = length(vocab.index.x2int)

# implements subset of index api that keeps immutability
id(vocab::Vocabulary, token) = id(vocab.index, vocab.normalize(token))
id(vocab::Vocabulary, token, notfound) = id(vocab.index, vocab.normalize(token), notfound)
ids(vocab::Vocabulary, tokens)  = [id(vocab.index, vocab.normalize(token)) for token in tokens]
ids(vocab::Vocabulary, tokens, unk) = [id(vocab.index, vocab.normalize(token), unk) for token in tokens]

# implements subset of counter api that keeps immutability
argmax(vocab::Vocabulary) = argmax(vocab.counts)
Base.count(vocab::Vocabulary, token, default = 0) = count(vocab.counts, vocab.normalize(token), default)
total(vocab::Vocabulary) = total(vocab.counts)

function Base.show(io::IO, vocab::Vocabulary)
    T = eltype(vocab)
    print(io, "Vocabulary{$T}(size=$(length(vocab)),observed=$(total(vocab)))")
end

end #module
