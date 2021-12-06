using Statistics;
using Random;

function distance(from::Vector{T}, to::Vector{V}) where {T,V}
    sum((from .- to) .^2) |> sqrt
end

function KMEANS(
    matrix::Vector{Vector{T}},
    k::Int;
    max::Int,
)::Vector{Vector{Vector{T}}} where {T}
    len = matrix |> length
    μ = shuffle(MersenneTwister(888888), 1:len)[1:k] .|> x -> matrix[x]
    C::Vector{Vector{Vector{T}}} = 1:k .|> _ -> []
    for _ ∈ 1:max
        for x ∈ matrix
            distances = μ .|> ϵ -> distance(x, ϵ)
            min = argmin(distances)
            C[min] = C[min] ∪ [x]
        end
        δ = C .|> x -> mean(x)
        μ == δ && break
        μ = δ
    end
    C
end

KMEANS(
    [
        [0, 2],
        [0, 0],
        [1.5, 0],
        [5, 0],
        [5, 2]
    ],
    2,
    max = 20,
) .|> println
