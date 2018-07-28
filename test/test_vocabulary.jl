using CL.Vocab

@testset "Vocabulary" begin
    unk  = "<unk>"

    # empty vocabulary
    vocab = Vocabulary()
    @test length(vocab) == 0
    @test count(vocab, "anything") == 0
    @test total(vocab) == 0

    # small simple vocabulary
    vocab = Vocabulary(split("the cow jumped over the moon"))
    @test length(vocab) == 5
    @test count(vocab, "the") == 2
    @test count(vocab, "moon") == 1

    numbers = split("1 2 2 3 3 3 4 4 4 4 5 5 5 5 5")

    # another small simple vocabulary
    vocab = Vocabulary(numbers, specials=[])
    for i in 1:5
        @test i == count(vocab, "$i")
    end
    @test length(vocab) == 5
    @test ids(vocab, split("5 4 3 2 1")) == 1:5

    # vocabulary with a special unk symbol
    vocab = Vocabulary(numbers, specials=[unk])
    @test length(vocab) == 6
    @test count(vocab, unk) == 0

    # max size, no unk symbol
    vocab = Vocabulary(numbers, max_size = 3)
    @test length(vocab) == 3
    @test_throws Exception id(vocab, "1")
    @test_throws Exception id(vocab, "2")
    @test ids(vocab, split("3 4 5")) == [3, 2, 1]

    # max size with unk symbol
    vocab = Vocabulary(numbers, max_size=5, specials=[unk])
    @test length(vocab) == 5
    unk_id = id(vocab, unk)
    @test  unk_id == 1
    @test ids(vocab, split("1 2 3 4 5 unk 6"), 1) == [1, 5, 4, 3, 2, 1, 1]

    # min frequency
    vocab = Vocabulary(numbers, min_freq=2, specials=[unk])
    @test length(vocab) == 5
    @test id(vocab, "0", id(vocab, unk)) == 1
    @test ids(vocab, split("0 1 2 3 4 5"), 1) == [1, 1, 5, 4, 3, 2]
end
