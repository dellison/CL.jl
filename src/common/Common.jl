module Common

# Common: miscellaneous useful utilities?

export Counter, inc!, total
export Index, id, id!, ids, ids!

include("counters.jl")
include("index.jl")

end
