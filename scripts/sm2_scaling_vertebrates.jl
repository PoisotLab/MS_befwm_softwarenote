using DataFrames

# Initialize all cores and set a seed
number_of_cores = 51
while nprocs() < number_of_cores
  addprocs(number_of_cores - nprocs())
end

@everywhere using BioEnergeticFoodWebs

@everywhere Z = logspace(-2, 4, 19)
@everywhere V = vec([true false])

@everywhere replicates = 1000
@everywhere conditions = vcat([[(z, v) for z in Z] for v in V]...)
@everywhere conditions = vcat([conditions for i in 1:replicates]...)

@everywhere function makesim(z, v)
  # Generate a niche model with 20 species and a connectance of 0.15 ± 0.01
  A = nichemodel(20, 0.15, tolerance=0.01)
  # Simulate
  if v
    #=
    All species with a trophic rank larger than one, i.e. all primary producers,
    are vertebrates.
    =#
    vertebrates = trophic_rank(A) .> 1.0
  else
    # If not, all are invertebrates
    vertebrates = falses(size(A, 1))
  end
  p = model_parameters(A, productivity=:system, Z=z, vertebrates=round(Bool, vertebrates))
  bm = rand(size(A, 1))
  out = simulate(p, bm, start=0, stop=2000)
  # Get results
  d = foodweb_diversity(out, last=1000)
  s = population_stability(out, last=1000, threshold=-0.01)
  b = total_biomass(out, last=1000)
  r = species_richness(out, last=1000, threshold=eps()) / 20.0
  # Return
  return (d, s, b, r)
end

df = DataFrame(
  [Float64, Bool, Float64, Float64, Float64, Float64],
  [:Z, :vertebrates, :diversity, :stability, :richness, :biomass],
  length(conditions))

output = pmap((x) -> makesim(x...), conditions)
for k in eachindex(output)
  df[:Z][k] = conditions[k][1]
  df[:vertebrates][k] = conditions[k][2]
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

writetable("./figures/sm2.dat", df, separator='\t', header=true)
