using DataFrames

addprocs(3)

@everywhere using befwm

@everywhere competition = linspace(0.92, 1.08, 3)
@everywhere k = logspace(-1, 1, 9)

@everywhere conditions = vcat([[[K, com] for com in competition] for K in k]...)

@everywhere function makesim(k, α)
  # Generate a niche model
  A = nichemodel(20, 0.15)
  while abs(befwm.connectance(A) - 0.15) > 0.01
    A = nichemodel(20, 0.15)
  end
  # Simulate
  p = model_parameters(A, productivity=:competitive, α=α, K=k)
  bm = rand(size(A, 1))
  out = simulate(p, bm, start=0, stop=2000, use=:ode45)
  # Get results
  d = foodweb_diversity(out, last=1000)
  s = population_stability(out, last=1000, threshold=eps())
  b = total_biomass(out, last=1000)
  r = species_richness(out, last=1000, threshold=eps()) / 20.0
  # Return
  return (d, s, b, r)
end

replicates = 40
df = DataFrame(
  [Float64, Float64, Float64, Float64, Float64, Float64],
  [:competition, :K, :diversity, :stability, :richness, :biomass],
  replicates * length(conditions))

cursor = 1
for replicate in 1:replicates
  println("Starting replicate $replicate")
  output = pmap((x) -> makesim(x...), conditions)
  for k in eachindex(output)
    df[:competition][cursor] = conditions[k][2]
    df[:K][cursor] = conditions[k][1]
    df[:diversity][cursor] = output[k][1]
    df[:stability][cursor] = output[k][2]
    df[:biomass][cursor] = output[k][3]
    df[:richness][cursor] = output[k][4]
    cursor += 1
  end
end

# Filter results
df = df[!isnan(df[:diversity]),:]
df = df[!isna(df[:diversity]),:]
df = df[df[:stability] .<= 0.0,:]
#df = df[df[:stability] .>= -5.0,:]

writetable("./figures/sm1.dat", df, separator='\t', header=true)
