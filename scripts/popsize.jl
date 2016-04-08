include("common.jl")

steps = 300
replicates = 50

df = DataFrame([Int64, Int64, Float64, Float64], [:time, :replicate, :biomass, :popsize], (steps+1) * replicates)

for i in 1:replicates
    A = nichemodel(20, 0.25)
    while abs(befwm.connectance(A) - 0.25) > 0.01
        A = nichemodel(20, 0.25)
    end
    trophic_ranks = trophic_rank(A)
    # Prepare the simulation parameters
    p = make_initial_parameters(A)
    p[:Z] = 10.0
    p = make_parameters(p)
    bm = rand(size(A, 1))
    body_mass = p[:Z].^trophic_ranks
    # Simulate!
    out = simulate(p, bm, start=0, stop=steps, steps=1500, use=:ode45)
    t = out[:t]
    b = mapslices(befwm.shannon, out[:B], 2)
    n = mapslices(befwm.shannon, out[:B]./body_mass', 2)
    for time in eachindex(t)
        index = (i-1)*(steps+1)+time
        df[:time][index] = t[time]
        df[:replicate][index] = i
        df[:biomass][index] = b[time]
        df[:popsize][index] = n[time]
    end
end

# Melt data frame

for_plot = aggregate(df, :time, [mean, std, distrmin, distrmax])

pl_bio = plot(for_plot, x=:time, y=:biomass_mean, ymin=:biomass_distrmin, ymax=:biomass_distrmax,
    Geom.path, Geom.ribbon);
pl_div = plot(for_plot, x=:time, y=:popsize_mean, ymin=:popsize_distrmin, ymax=:popsize_distrmax,
    Geom.path, Geom.ribbon);

draw(PDF("figures/popsize.pdf", 14cm, 17cm), vstack(pl_div, pl_bio))
