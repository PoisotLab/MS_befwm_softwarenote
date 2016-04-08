include("common.jl")

steps = 7
replicates = 100

df = DataFrame([Float64, Float64, Float64], [:scaling, :diversity, :stability], steps * replicates)

z_values = collect(logspace(-3, 3, steps))
scaling = vec(hcat([z_values for i in 1:replicates]...))

for i in eachindex(scaling)
    A = nichemodel(20, 0.15)
    while abs(befwm.connectance(A) - 0.15) > 0.01
        A = nichemodel(20, 0.15)
    end
    # Prepare the simulation parameters
    p = make_initial_parameters(A)
    p[:Z] = scaling[i]
    p = make_parameters(p)
    bm = rand(size(A, 1))
    # Simulate!
    out = simulate(p, bm, start=0, stop=2000, steps=1000, use=:ode45)
    d = foodweb_diversity(out, last=1000)
    s = population_stability(out, last=1000)
    df[:scaling][i] = p[:Z]
    df[:diversity][i] = d
    df[:stability][i] = s
end

# Filter results
df = df[!isnan(df[:diversity]),:]
df = df[!isna(df[:diversity]),:]
df = df[df[:stability] .<= 0.0,:]
df = df[df[:stability] .>= -5.0,:]

# Melt data frame
for_plot = aggregate(df, :scaling, [mean, std, distrmin, distrmax])

for_plot[:stability_distrmax][for_plot[:stability_distrmax].>0.0] = 0.0

pl_div = plot(for_plot, x=:scaling, y=:diversity_mean, ymin=:diversity_distrmin, ymax=:diversity_distrmax,
    Geom.point, Geom.errorbar, Scale.x_log10, plab_theme);
pl_sta = plot(for_plot, x=:scaling, y=:stability_mean, ymin=:stability_distrmin, ymax=:stability_distrmax,
    Geom.point, Geom.errorbar, Scale.x_log10, plab_theme);

draw(PDF("figures/scaling.pdf", 14cm, 17cm), vstack(pl_div, pl_sta))
