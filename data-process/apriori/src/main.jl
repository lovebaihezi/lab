#=
main:
- Julia version: 1.6.3
- Author: lqxc
- Date: 2021-10-19
=#

function scan(
    data::Vector{Vector{T}},
    C::Vector{Vector{T}},
    ε::Float64,
)::Tuple{Vector{Vector{T}}, Dict{Vector{T},Float64}} where {T}
    dict = Dict{Vector{T},Float64}()
    len = data |> length
    for set ∈ data
        for c ∈ C
            if c ⊆ set
                value = get!(dict, c, 0)
                dict[c] = value + 1
            end
        end
    end
    for (key, value) ∈ dict
        if value / len < ε
            delete!(dict, key)
        else
            dict[key] = value / len
        end
    end
    [(dict |> keys)...], dict
end

function Apriori_gen(set::Vector{Vector{T}}, k::Int)::Vector{Vector{T}} where {T}
    result = Vector{Vector{T}}()
    len = set |> length
    for p ∈ 1:len, q ∈ p+1:len
        if set[p][1:k-2] |> Set == set[q][1:k-2] |> Set
            push!(result, (set[p] ∪ set[q]))
        end
    end
    result
end

function Apriori(
    data::Vector{Vector{T}},
    ε::Float64,
)::Tuple{Vector{Vector{Vector{T}}},Vector{Dict{Vector{T},Float64}}} where {T}
    k = 2
    C = union(data...) .|> each -> [each]
    list, dict = scan(data, C, ε)
    L::Vector{Vector{Vector{T}}} = [list]
    D::Vector{Dict{Vector{T},Float64}} = [dict]
    while L[k-1] |> length != 0
        C = Apriori_gen(L[k-1], k)
        list, dict = scan(list, C, ε)
        push!(L, list)
        push!(D, dict)
        k += 1
    end
    L, D
end

data = [[:A, :C, :D], [:B, :C, :E], [:A, :B, :C, :E], [:B, :E]]

items, dict = Apriori(data, 0.3)
items .|> println
dict .|> println
