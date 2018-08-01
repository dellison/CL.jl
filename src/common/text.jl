
abstract type Tokenizer end

# based on nltk's regexptokenizer
struct RegexTokenizer <: Tokenizer
    rx::Regex
    gaps::Bool
    discard_empty::Bool
    normalize::Function

    function RegexTokenizer(rx::Regex; gaps=false, discard_empty=true,
                            normalize::Function=identity)
        new(rx, gaps, discard_empty, normalize)
    end
end

(t::RegexTokenizer)(text) = tokenize(t, text)

function tokenize(t::RegexTokenizer, str)
    if t.gaps # rx matches the gap, not the token, so split
        ts = [t.normalize(tk) for tk in split(str, t.rx)]
        t.discard_empty ? filter(!isempty, ts) : ts
    else
        [t.normalize(m.match) for m in eachmatch(t.rx, str)]
    end
end



function wordtag(token, sep="/")
    xs = split(token, sep)
    return String(join(xs[1:end-1], sep)), String(xs[end])
end
