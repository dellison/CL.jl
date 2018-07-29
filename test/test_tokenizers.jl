using CL.Common: RegexTokenizer

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
end
