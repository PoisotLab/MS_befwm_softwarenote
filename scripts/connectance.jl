include("common.jl")

replicates = 10
competition = linspace(0.9, 1.1, 11)
connectance = linspace(0.05, 0.25, 5)

n = replicates * length(competition) * length(connectance)

df = DataFrame([Float64, Float64, Float64, Float64, Float64, Float64], [:competition, :connectance, :diversity, :stability, :richness, :biomass], n)

i = 1

for replicate in 1:replicates
  for co in connectance
    for α in competition
      println("Sim. $i of $n")
      # Generate a niche model
      A = nichemodel(20, co)
      while abs(befwm.connectance(A) - co) > 0.01
        A = nichemodel(20, co)
      end
      # Simulate
      p = model_parameters(A, productivity=:competitive, α=α)
      bm = rand(size(A, 1))
      out = simulate(p, bm, start=0, stop=2000, use=:ode45)
      # Get results
      d = foodweb_diversity(out, last=1000)
      s = population_stability(out, last=1000, threshold=eps())
      b = total_biomass(out, last=1000)
      r = species_richness(out, last=1000, threshold=eps())
      # Add to data frame
      df[:competition][i] = p[:α]
      df[:connectance][i] = co
      df[:diversity][i] = d
      df[:stability][i] = s
      df[:biomass][i] = b
      df[:richness][i] = r
      # Update cursor
      i += 1
    end
  end
end

plot(df, x=:competition, y=:richness, colour=:connectance, Geom.point, Geom.smooth, Scale.color_discrete())

# Filter results
df = df[!isnan(df[:diversity]),:]
df = df[!isna(df[:diversity]),:]
df = df[df[:stability] .<= 0.0,:]
#df = df[df[:stability] .>= -5.0,:]

# Melt data frame
agr = aggregate(df, [:connectance, :competition], [mean, std, distrmin, distrmax])

agr[:stability_distrmax][agr[:stability_distrmax].>0.0] = 0.0

p1 = plot(agr, x=:competition, color=:connectance, y=:diversity_mean, ymin=:diversity_distrmin, ymax=:diversity_distrmax, Geom.point, Geom.errorbar, Scale.color_discrete(), Geom.line)
p2 = plot(agr, x=:competition, color=:connectance, y=:richness_mean, ymin=:richness_distrmin, ymax=:richness_distrmax, Geom.point, Geom.errorbar, Scale.color_discrete(), Geom.line)
p3 = plot(agr, x=:competition, color=:connectance, y=:biomass_mean, ymin=:biomass_distrmin, ymax=:biomass_distrmax, Geom.point, Geom.errorbar, Scale.color_discrete(), Geom.line)
p4 = plot(agr, x=:competition, color=:connectance, y=:stability_mean, ymin=:stability_distrmin, ymax=:stability_distrmax, Geom.point, Geom.errorbar, Scale.color_discrete(), Geom.line)
