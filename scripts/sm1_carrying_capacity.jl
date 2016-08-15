using DataFrames

# Initialize all cores and set a seed
number_of_cores = 51
while nprocs() < number_of_cores
  addprocs(number_of_cores - nprocs())
end
@everywhere srand(42)

@everywhere using befwm

@everywhere competition = linspace(0.90, 1.10, 3)
@everywhere k = logspace(-1, 1, 19)

@everywhere replicates = 500
@everywhere conditions = vcat([[[K, com] for com in competition] for K in k]...)
@everywhere conditions = vcat([conditions for i in 1:replicates]...)

@everywhere function makesim(k, α)
  # Generate a niche model with 20 species and a connectance of 0.15 ± 0.01
  A = nichemodel(20, 0.15, tolerance=0.01)
  # Simulate
  p = model_parameters(A, productivity=:competitive, α=α, K=k)
  bm = rand(size(A, 1))
  out = simulate(p, bm, start=0, stop=2000, use=:ode45)
  # Get results
  d = foodweb_diversity(out, last=1000)
  s = population_stability(out, last=1000, threshold=eps())
  b = total_biomass(out, last=1000)
  r = species_richness(out, last=1000, threshold=eps()) / 20.0
  # Return20
  return (d, s, b, r)
end

df = DataFrame(
  [Float64, Float64, Float64, Float64, Float64, Float64],
  [:competition, :K, :diversity, :stability, :richness, :biomass],
  length(conditions))

output = pmap((x) -> makesim(x...), conditions)
for k in eachindex(output)
  df[:competition][k] = conditions[k][2]
  df[:K][k] = conditions[k][1]
  df[:diversity][k] = output[k][1]
  df[:stability][k] = output[k][2]
  df[:biomass][k] = output[k][3]
  df[:richness][k] = output[k][4]
end

# Filter results
df = df[!isnan(df[:diversity]),:]
df = df[!isna(df[:diversity]),:]
df = df[df[:stability] .<= 0.0,:]
#df = df[df[:stability] .>= -5.0,:]

writetable("./figures/sm1.dat", df, separator='\t', header=true)
