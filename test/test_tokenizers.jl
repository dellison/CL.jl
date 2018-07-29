using CL.Common: RegexTokenizer, tokenize
@testset "Tokenizers" begin
    t = RegexTokenizer(r"\w+")
    @test length(tokenize(t, "  1  2	 3  4 5 six seven 88 999 10")) == 10

    wsjdep = read(joinpath(@__DIR__, "data", "wsj_0001.dp"), String)
    sent_tokenizer = RegexTokenizer(r"\n", gaps=true)
    sentences = tokenize(sent_tokenizer, wsjdep)
    @test length(sentences) == 2

end
