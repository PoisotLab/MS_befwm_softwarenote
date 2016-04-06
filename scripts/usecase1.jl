# Load the library

using befwm
using Gadfly
using DataFrames

#=
Generate a random network
=#

A = nichemodel(15, 45)

# We will use the `:ode45` solver
const solver = :ode45

# The scaling gradient will go from -3 to 3 (log scale)
Z = collect(logspace(-2, 2, 15))

# Initialize a DataFrame
df = DataFrame([Float64, Float64, Float64, Float64], [:Z, :d, :min, :max], length(Z))

for i in eachindex(Z)
    p = make_initial_parameters(A)
    p[:Z] = Z[i]
    p = make_parameters(p)
    div = zeros(4)
    for s in eachindex(div)
        initial_biomass = rand(size(A, 1))
        output = simulate(p, initial_biomass, start=0, stop=1000, steps=2500, use=solver)
        div[s] = foodweb_diversity(output, last=200)
        println(div)
    end
    div = filter((x) -> !isnan(x), div)
    df[:Z][i] = Z[i]
    df[:d][i] = mean(div)
    df[:max][i] = mean(div) + std(div)
    df[:min][i] = mean(div) - std(div)
    println(head(df))
end

plot(df, x=:Z, y=:d, ymin=:min, ymax=:max, Geom.point, Geom.errorbar, Scale.x_log10)
