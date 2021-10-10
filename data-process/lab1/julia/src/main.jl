using XLSX;
using CSV;
using DataFrames;
using Plots;
using Dates;
using StatsPlots;
using PyPlot;

file_path = "file/xian_guangdian.csv";
data = CSV.File(file_path) |> DataFrame