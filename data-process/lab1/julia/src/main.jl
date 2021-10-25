#!/bin/julia
using XLSX;
using CSV;
using DataFrames;
using Plots;
using Dates;
using Statistics;
using StatsPlots
import PyPlot;
using LinearAlgebra

function free()
    quality =
        "file/xian_guangdian.csv" |>
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
    ) |> fig -> savefig(fig, "images/first_$kind")
end

function draw_plot()
    file_path = "file/xian_beijing_salary.xlsx"
    salarys = DataFrame(XLSX.readdata(file_path, "Sheet1!C3:D14"), :auto) .|> identity
    salary = [salarys.x1, salarys.x2]

    println("mean:$(salary .|> Statistics.mean)")
    println("var:$(salary .|> Statistics.var)")
    println("std:$(salary .|> Statistics.std)")
    println("cov:$(salary |> Statistics.cov)")
    println("cor:$(salary .|> Statistics.cor)")

    violin(["Xi'an"], salarys.x1, label = "Xi'an")
    violin!(["Beijing"], salarys.x2, label = "Beijing") |>
    fig -> savefig(fig, "images/violin")
    boxplot(["Xi'an"], salarys.x1, label = "Xi'an")
    boxplot!(["Beijing"], salarys.x2, label = "Beijing") |>
    fig -> savefig(fig, "images/box")

end

function map_transform()
    file_path = "file/3movie_metadata.csv"
    movie_metadata = file_path |> CSV.File |> DataFrame
    dropmissing!(movie_metadata, :director_name)
    dict = Dict(
        :color => "Color",
        :num_critic_for_reviews => 0,
        :duration => 0,
        :director_facebook_likes => 0,
        :actor_3_facebook_likes => 0,
        :actor_2_name => "",
        :actor_1_facebook_likes => 0,
        :gross => 0,
        :genres => "",
        :actor_1_name => "",
        :movie_title => "",
        :num_voted_users => 0,
        :cast_total_facebook_likes => 0,
        :actor_3_name => "",
        :facenumber_in_poster => 0,
        :plot_keywords => "",
        :movie_imdb_link => "",
        :num_user_for_reviews => 0,
        :language => "",
        :country => "",
        :content_rating => 0,
        :budget => 0,
        :title_year => 0,
        :actor_2_facebook_likes => 0,
        :imdb_score => 0,
        :aspect_ratio => 0,
        :movie_facebook_likes => 0,
    )
    dict |>
    keys .|>
    key -> select!(
        movie_metadata,
        :,
        key => (col -> col .|> each -> if ismissing(each)
            dict[key]
        else
            each
        end) => key,
    )
end

function join_compine()
    ["file/4ReaderInformation.csv", "file/4ReaderRentRecode.csv"] .|>
    CSV.File .|>
    DataFrame |>
    dates -> begin
        println(dates...)
        innerjoin(dates..., on = :num) |>
        file -> begin
            file |> println
            CSV.write("file/join.csv", file)
        end
    end
end

function self_pca()
    mat = "file/5iris.csv" |> CSV.File |> DataFrame
    gp = groupby(mat, :Species)
    names = [:Sepal_length, :Sepal_width, :Petal_length, :Petal_width, :Species]
    @df gp[1] plot(
        :Sepal_length,
        :Sepal_width,
        :Petal_length,
        zcolor = :Petal_width,
        m = (10, 0.2, :blues, Plots.stroke(0)),
        fontfamily = "Yahei",
        xlabel = "Sepal_length",
        ylabel = "Sepal_width",
        zlabel = "Petal_length",
        title = "山鸢尾",
        label = "山鸢尾",
        w = 0,
    )
    @df gp[2] plot(
        :Sepal_length,
        :Sepal_width,
        :Petal_length,
        zcolor = :Petal_width,
        m = (10, 0.2, :blues, Plots.stroke(0)),
        fontfamily = "Yahei",
        xlabel = "Sepal_length",
        ylabel = "Sepal_width",
        zlabel = "Petal_length",
        title = "变色鸢尾",
        label = "变色鸢尾",
        w = 0,
    )
    @df gp[3] plot(
        :Sepal_length,
        :Sepal_width,
        :Petal_length,
        zcolor = :Petal_width,
        m = (10, 0.2, :blues, Plots.stroke(0)),
        fontfamily = "Yahei",
        xlabel = "Sepal_length",
        ylabel = "Sepal_width",
        zlabel = "Petal_length",
        title = "维吉尼亚鸢尾",
        label = "维吉尼亚鸢尾",
        w = 0,
    )
    data = copy(mat)
    data = select!(data, Not([:Species]))
    transform!(
        data,
        :,
        :Sepal_length => (x -> x .- mean(x)) => :Sepal_length,
        :Sepal_width => (x -> x .- mean(x)) =>:Sepal_width,
        :Petal_length => (x -> x .- mean(x)) =>:Petal_length,
        :Petal_width => (x -> x .- mean(x)) =>:Petal_width,
    )
    data = data |> Matrix
    (values, vectors) = data |> Statistics.cov |> eigen
    # sortperm 会将元素从小到大排序
    p = last(sortperm(values), 2) |> x -> vectors[:, x]
    data * p
end

free();
draw_plot();
map_transform();
join_compine();
self_pca();
