import Statistics;


function distance(from::Vector{T}) where {T}
    to::Vector{T} -> sum(zip(from) .|> p -> (-(p...))^2) |> sqrt
end

function KMEANS(
    matrix::Vector{Vector{T}},
    k::Int;
    max::Int,
)::Vector{Vector{T}} where {T}
    μ = rand(k) .|> x -> matrix[trunc(Int, (x * 100 + 1) % 12)]
    C = 1:k .|> []
    for _ ∈ 1:max
        for v ∈ matrix
            min = argmin(μ .|> distance(v))
            C[min] = C[min] ∪ v
        end
        δ = C .|> x -> mean(x)
        if δ == μ
            break
        else
            μ = δ
        end
    end
    C
end

KMEANS([], 3, max = 20) .|> println
