using befwm
using Gadfly
using DataFrames


steps = 500
replicates = 5

df = DataFrame([Int64, Int64, Float64, Float64], [:time, :replicate, :diversity, :biomass], (steps+1) * replicates)

for i in 1:replicates
    A = nichemodel(20, 0.25)
    while abs(befwm.connectance(A) - 0.25) > 0.01
        A = nichemodel(20, 0.25)
    end
    # Prepare the simulation parameters
    p = make_initial_parameters(A)
    p = make_parameters(p)
    bm = rand(size(A, 1))
    # Simulate!
    out = simulate(p, bm, start=0, stop=steps, steps=1000, use=:ode45)
    t = out[:t]
    d = mapslices(befwm.shannon, out[:B], 2)
    b = sum(out[:B], 2)
    for time in eachindex(t)
        index = (i-1)*(steps+1)+time
        df[:time][index] = t[time]
        df[:replicate][index] = i
        df[:diversity][index] = d[time]
        df[:biomass][index] = b[time]
    end
end

# Melt data frame
for_plot = by(df, :time,
                x -> DataFrame(
                    diversity = mean(x[:diversity]),
                    s_diversity = std(x[:diversity]),
                    biomass = mean(x[:biomass]),
                    s_biomass = std(x[:biomass]),
                    ))

for_plot[:min_diversity] = for_plot[:diversity] .- for_plot[:s_diversity]
for_plot[:max_diversity] = for_plot[:diversity] .+ for_plot[:s_diversity]
for_plot[:min_biomass] = for_plot[:biomass] .- for_plot[:s_biomass]
for_plot[:max_biomass] = for_plot[:biomass] .+ for_plot[:s_biomass]

pl_div = plot(for_plot, x=:time, y=:diversity, ymin=:min_diversity, ymax=:max_diversity,
    Geom.path, Geom.ribbon);
pl_bio = plot(for_plot, x=:time, y=:biomass, ymin=:min_biomass, ymax=:max_biomass,
    Geom.path, Geom.ribbon);

draw(PDF("temporal_dynamics", 12cm, 6cm), vstack(pl_div, pl_bio))
