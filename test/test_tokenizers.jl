using CL.Common: RegexTokenizer
using CL.Common: wordtag

@testset "Tokenizers" begin
    tokenize = RegexTokenizer(r"\w+")
    @test length(tokenize("  1  2	 3  4 5 six seven 88 999 10")) == 10

    wsjdep = joinpath(@__DIR__, "data", "wsj_0001.dp")

    splitsents = RegexTokenizer(r"\n\n", gaps=true)
    tokenize = RegexTokenizer(r"\n", gaps=true)
    readf(f) = tokenize.(splitsents(read(f, String)))
    sentences = readf(wsjdep)
    @test length(sentences) == 2
    @test map(length, sentences) == [18, 13]

    s = " a b"
    tok1 = RegexTokenizer(r"\s+", gaps=true)
    @test tok1(s) == ["a", "b"]
    tok2 = RegexTokenizer(r"\s+", gaps=true, discard_empty=false)
    @test tok2(s) == ["", "a", "b"]


    @test wordtag("the/DT") == ("the", "DT")
    @test wordtag("Chiat/Day/Mojo/NNP") == ("Chiat/Day/Mojo", "NNP")
    @test wordtag("either/or/CONJ") == ("either/or", "CONJ")
end
