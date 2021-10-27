#=
main:
- Julia version: 1.6.3
- Author: lqxc
- Date: 2021-10-19
=#

# D means the whole dataset, which should be Vector{Vector{T}}
# ! count(X) = filter(D, X ⊆ _).count()
# support(X => Y) = count(X ∪ Y) / |D|
# confidence(X => Y) = count(X ∪ Y) / count(X)

function rules(
    dicts::Vector{Dict{Set{T},Float64}},
    support::Dict{Set{T}, Float64},
    ς::Float64
   )::Dict{Pair{Set{T},Set{T}}, Tuple{Float64, Float64}} where {T}
    result = Dict{Pair{Set{T}, Set{T}},Tuple{Float64, Float64}}()
    for i ∈ 2:(dicts |> length)
        for x ∈ 1:i-1
            for set ∈ dicts[x] |> keys
                for n_set ∈ dicts[i] |> keys
                    if set ⊆ n_set
                        diff = setdiff(n_set, set)
                        # set ∪ diff = n_set
                        # confidence(set => diff) = count(n_set) / count(set)
                        # (n_set, set => diff, support[n_set] / support[set]) |> println
                        confidence = support[n_set] / support[set]
                        if confidence >= ς
                            result[set => diff] = confidence, confidence / support[diff]
                        end
                    end
                end
            end
        end
    end
    result
end

#=
# scan the data with each item set in item set set,
# and get each support
=#

function scan(
    data::Vector{Vector{T}},
    C::Set{Set{T}},
    ε::Float64,
)::Dict{Set{T},Float64} where {T}
    dict = Dict{Set{T},Float64}()
    data .|> row -> C .|> set -> if set ⊆ row # check each set is subset of each row in data which in C
        v = get!(dict, set, 0) + 1 # Int, yes, set default if is missing, and get value
        dict[set] = v
    end
    len = data |> length # Int, get data set size
    for (key, value) ∈ dict # Vector{T} => Float64, cal each sets support%
        support = value / len
        dict[key] = support
    end
    dict |> keys .|> key -> if dict[key] < ε # remove set which support less than ε
        delete!(dict, key)
    end
    dict
end

function apriori(
    data::Vector{Vector{T}};
    ε::Float64 = 0.5,
    ς::Float64 = ε,
)::Tuple{
    Vector{Dict{Set{T}, Float64}},
    Dict{Pair{Set{T},Set{T}}, Tuple{Float64, Float64}}
} where {T}
    n = 2
    C1::Set{Set{T}} = (∪(data...) .|> v -> Set([v])) |> Set
    support = Dict{Set{T}, Float64}()
    dict = scan(data, C1, ε)
    merge!(+, support, dict)
    L::Vector{Set{Set{T}}} = [[(dict |> keys)...] |> Set]
    D::Vector{Dict{Set{T},Float64}} = [dict]
    while L[n-1] |> length != 0
        C = Set{Set{T}}()
        # len = L[n-1] |> length
        for p ∈ L[n-1], q ∈ L[n-1]
            if p != q
                push!(C, p ∪ q)
            end
        end
        dict = scan(data, C, ε)
        merge!(+, support, dict)
        push!(D, dict)
        push!(L, [keys(dict)...] |> Set)
        n += 1
    end
    D, rules(D, support, ς)
end

# data = readlines("files/groceries.csv") .|> s -> split(s, ",")

# apriori(data; ε = 0.03, ς = 0.2) .|> 
# [
#    dicts -> dicts .|> dict -> dict |> keys .|> key -> println(key, " -> ", dict[key]),
#     dict -> dict |> keys .|> key -> println(key, " -> ", dict[key])
# ]
apriori([[:A, :C, :D], [:B, :C, :E], [:A, :B, :C, :E], [:B, :E]]; ε = 0.5) .|>
[
    dict -> dict .|> dict -> dict |> keys .|> key -> println(key, " -> ", dict[key]),
    dict -> dict |> keys .|> key -> println(key, " -> ", dict[key])
]

