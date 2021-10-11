using XLSX;
using CSV;
using DataFrames;
using Plots;
using Dates;
using StatsPlots;
using PyPlot;

file_path = "file/xian_guangdian.csv";
data = file_path |> CSV.File |> DataFrame
select!(data, ["网络类型", "计费对象"]);
data = groupby(data, "计费对象") |> combine