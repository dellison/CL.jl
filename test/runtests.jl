using CL, Test

@testset "CL" begin
    for file in readdir(@__DIR__)
        if startswith(file, "test_") && endswith(file, ".jl")
            include(file)
        end
    end
end
