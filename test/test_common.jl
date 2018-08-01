using CL.Common: Index, id, id!, ids!
@testset "Indexing" begin
    index = Index()
    @test length(index) == 0
    @test_throws Exception id(index, "notpresent")
    @test id(index, "notpresent", nothing) == nothing
    @test id!(index, "one") == 1
    @test id!(index, "two") == 2
    @test_throws Exception id(index, "three")
    @test id(index, "three", 0) == 0
    @test id!(index, "three") == 3
    @test ids!(index, ["one", "two", "three"]) == [1, 2, 3]

    index = Index(split("i am reading a wonderful book"))
    @test id(index, "i") == 1
    @test length(index) == 6
end

using CL.Common: Counter, inc!, total
@testset "Counters" begin
    c = Counter()
    @test length(c) == total(c) == 0

    inc!(c, "one")
    @test length(c) == total(c) == 1 
end
