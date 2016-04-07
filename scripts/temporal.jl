using befwm
using Gadfly
using DataFrames


steps = 500
replicates = 50

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
    out = simulate(p, bm, start=0, stop=steps, steps=1500, use=:ode45)
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

function distrmax(x)
    return mean(x) .+ std(x)
end

function distrmin(x)
    return mean(x) .- std(x)
end

for_plot = aggregate(df, :time, [mean, std, distrmin, distrmax])

pl_bio = plot(for_plot, x=:time, y=:biomass_mean, ymin=:biomass_distrmin, ymax=:biomass_distrmax,
    Geom.path, Geom.ribbon);
pl_div = plot(for_plot, x=:time, y=:diversity_mean, ymin=:diversity_distrmin, ymax=:diversity_distrmax,
    Geom.path, Geom.ribbon);

draw(PDF("figures/temporal_dynamics.pdf", 14cm, 17cm), vstack(pl_div, pl_bio))
