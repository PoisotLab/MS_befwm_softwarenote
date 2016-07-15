using DataFrames

addprocs(3)

@everywhere using befwm

@everywhere Z = logspace(-3, 3, 9)
@everywhere V = vec([true false])

@everywhere conditions = vcat([[[z, v] for z in Z] for v in V]...)

@everywhere function makesim(z, v)
  # Generate a niche model
  A = nichemodel(20, 0.15)
  while abs(befwm.connectance(A) - 0.15) > 0.01
    A = nichemodel(20, 0.15)
  end
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
  p = model_parameters(A, productivity=:competitive, α=0.95, vertebrates=vertebrates)
  bm = rand(size(A, 1))
  out = simulate(p, bm, start=0, stop=2000, use=:ode45)
  # Get results
  d = foodweb_diversity(out, last=1000)
  s = population_stability(out, last=1000, threshold=-0.001)
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
