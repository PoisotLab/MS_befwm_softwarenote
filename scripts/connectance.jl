include("common.jl")

steps = 7
replicates = 200

df = DataFrame([Float64, Float64, Float64], [:connectance, :diversity, :stability], steps * replicates)

co_values = collect(linspace(0.05, 0.4, steps))
connectance = vec(hcat([co_values for i in 1:replicates]...))

for i in eachindex(connectance)
    A = nichemodel(20, connectance[i])
    while abs(befwm.connectance(A) - connectance[i]) > 0.01
        A = nichemodel(20, connectance[i])
    end
    # Prepare the simulation parameters
    p = make_initial_parameters(A)
    p = make_parameters(p)
    bm = rand(size(A, 1))
    # Simulate!
    out = simulate(p, bm, start=0, stop=2000, steps=1000, use=:ode45)
    d = foodweb_diversity(out, last=1000)
    s = population_stability(out, last=1000)
    df[:connectance][i] = connectance[i]
    df[:diversity][i] = d
    df[:stability][i] = s
end

# Filter results
df = df[!isnan(df[:diversity]),:]
df = df[df[:stability] .<= 0.0,:]
df = df[df[:stability] .>= -5.0,:]

# Melt data frame
for_plot = aggregate(df, :connectance, [mean, std, distrmin, distrmax])

for_plot[:stability_distrmax][for_plot[:stability_distrmax].>0.0] = 0.0

pl_div = plot(for_plot, x=:connectance, y=:diversity_mean, ymin=:diversity_distrmin, ymax=:diversity_distrmax,
    Geom.path, Geom.ribbon);
pl_sta = plot(for_plot, x=:connectance, y=:stability_mean, ymin=:stability_distrmin, ymax=:stability_distrmax,
    Geom.path, Geom.ribbon);

draw(PDF("figures/connectance.pdf", 14cm, 17cm), vstack(pl_div, pl_sta))
