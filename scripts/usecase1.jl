using befwm
using Gadfly
using DataFrames
using ProgressMeter



# We will use the `:ode45` solver
const solver = :ode45

# The scaling gradient will go from -3 to 3 (log scale)
Z = collect(logspace(-1, 1, 5))
CO = collect(linspace(0.05, 0.25, 10))

# Initialize a DataFrame
replicates = 20
df = DataFrame([Float64, Float64, Float64, Float64], [:Z, :Co, :stability, :diversity], length(Z)*replicates)

# Generates a random network based on the niche model
function nm(n, co)
    A = nichemodel(n, co)
    while round(befwm.connectance(A), 2) != co
        A = nichemodel(n, co)
    end
    return A
end

df_index = 1
progbar = Progress(length(Z)*replicates, 1, "Simulating ", 50)
for i in eachindex(Z)
    for s in 1:replicates
        A = nm(20, 0.15)
        p = make_initial_parameters(A)
        p[:Z] = Z[i]
        p = make_parameters(p)
        initial_biomass = rand(size(A, 1))
        output = simulate(p, initial_biomass, start=0, stop=2000, steps=2000, use=solver)
        df[:Z][df_index] = Z[i]
        df[:stability][df_index] = population_stability(output, last=1000, threshold=-0.01)
        df[:diversity][df_index] = foodweb_diversity(output, last=1000)
        df_index += 1
        next!(progbar)
    end
end

df = df[df[:stability].<0.0,:]

pub_theme = Theme(
    panel_stroke = colorant"black",
    grid_color = colorant"black",
    highlight_width=0mm,
)

pl_stab = plot(df, x=:Z, y=:stability, Scale.x_log10, Geom.point, pub_theme)
pl_even = plot(df, x=:Z, y=:diversity, Scale.x_log10, Geom.point, pub_theme)

draw(PDF("effect_scaling.pdf", 19cm, 9cm), hstack(pl_stab, pl_even))
