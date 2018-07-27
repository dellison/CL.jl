using CL: Indexing

@testset "Indexing" begin
    index = Index()
    @test id(index, "notpresent", nothing) == nothing
end
