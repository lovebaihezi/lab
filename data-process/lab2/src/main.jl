using LinearAlgebra;

function cal(dict::Dict{T,Int}, k::Float64)::Tuple{Dict{T,Int},Dict{T,Float64}} where {T}
    quantity = foldl(+, dict |> keys, init = 0)
    brief = Dict(dict |> keys .|> key -> (key, dict[key] / quantity))
    brief |> keys .|> key -> begin
        if brief[key] < k
            delete!(brief, key)
        end
    end
    other = Dict{T,Int}()
    for key ∈ dict |> keys
        if !haskey(brief, key)
            other[key] = dict[key]
        end
    end
    other, brief
end

function apriori(mat::Matrix{T}, min::Float64 = 0.5)::Vector{Dict{T,Float64}} where {T}
    dict = Dict{T,Int}()
    for each ∈ mat
        get!(dict, each, 0) |> v -> dict[each] = v + 1
    end
    x = dict |> length
    v = Vector{Dict{T,Float64}}()
    while x != 0
        i, f = cal(dict, min)
        x = i |> length
        push!(v, f)
    end
    v
end

apriori([1 1 1 1; 2 2 2 2; 3 3 3 3], 0.4)
