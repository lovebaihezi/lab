#!/bin/julia
using XLSX;
using CSV;
using DataFrames;
using Plots;
using Dates;
using Statistics;
using StatsPlots

function free()
    quality =
        "lab1/julia/file/xian_guangdian.csv" |>
        CSV.File |>
        DataFrame |>
        data ->
            begin
                combine(nrow, groupby(select(data, :客户等级), :客户等级)) |>
                data -> rename(data, :nrow => "用户数量") |> println
                combine(nrow, groupby(select(data, [:客户等级, :网络类型]), [:客户等级, :网络类型]))
            end |>
            data ->
                rename(data, :nrow => :quantity, :网络类型 => :net_kind, :客户等级 => :user_level)
    data = combine(groupby(quality, :net_kind), [:user_level, :quantity])
    dict = Dict(
        "5星ABD客户" => "star_5ABD",
        "离线" => "out_link",
        "3星AB客户" => "star_3AB",
        "1星D客户" => "star_1D",
        "1星A客户" => "star_1A",
        "VIP商业个人客户" => "vip",
        "3星AD客户" => "start_3AD",
    )
    1:(data|>nrow) .|>
    i -> begin
        data[i, :net_kind] =
            Dict("农网用户" => "village", "城网用户" => "city", " " => "unknown")[data[
                i,
                :net_kind,
            ]]
        data[i, :user_level] = dict[data[i, :user_level]]
    end
    gp = groupby(data, :net_kind)
    gp |>
    keys .|>
    kind -> @df combine(gp[kind], [:user_level, :quantity]) plot(
        :user_level,
        :quantity,
        label = "$kind",
    ) |> fig -> savefig(fig, "lab1/julia/images/first_$kind")
end

function draw_plot()
    file_path = "lab1/julia/file/xian_beijing_salary.xlsx"
    salarys = DataFrame(XLSX.readdata(file_path, "Sheet1!C3:D14"), :auto) .|> identity
    salary = [salarys.x1, salarys.x2]

    println("mean:$(salary .|> Statistics.mean)")
    println("var:$(salary .|> Statistics.var)")
    println("std:$(salary .|> Statistics.std)")
    println("cov:$(salary |> Statistics.cov)")
    println("cor:$(salary .|> Statistics.cor)")

    violin(["Xi'an"], salarys.x1, label = "Xi'an");
    violin!(["Beijing"], salarys.x2, label = "Beijing")|> fig -> savefig(fig, "lab1/julia/images/violin")
    boxplot(["Xi'an"], salarys.x1, label = "Xi'an");
    boxplot!(["Beijing"], salarys.x2, label = "Beijing") |> fig -> savefig(fig, "lab1/julia/images/box")

end

function map_filter()
    file_path = "lab1/julia/file/3movie_metadata.csv"
    movie_metadata = file_path |> CSV.File |> DataFrame
end

function join_compine()
    ["lab1/julia/file/4ReaderInformation.csv", "lab1/julia/file/4ReaderRentRecode.csv"] .|>
    CSV.File .|>
    DataFrame |>
    dates -> begin
        println(dates...)
        innerjoin(dates..., on = :num) |>
        file -> begin
            file |> println
            CSV.write("lab1/julia/file/join.csv", file)
        end
    end
end

function self_pca() end
