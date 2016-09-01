# Introduction

Community and ecosystem ecologists have long sought to understand the diversity,
properties, and dynamics of multi-species assemblages. The characteristics of
communities emerge in unpredictable ways because species influence one another
through direct, and indirect, ecological interactions. Seeing that the
coexistence of populations is constrained at least by feeding interactions,
models of the relationship between resources and consumers have provided a
useful and frequent tool in studying the theory of community dynamics. Although
these modeling efforts started from simple, abstract models like those from the
Lotka-Volterra family [@baca11lvp], more tailored and parameterized models have
emerged whose goal was to include a broader range of ecological and biological
mechanisms, thus hopefully providing more realistic representations of empirical
systems. Among these, the "bio-energetic" model of @yodz92bsc is a general
representation of resource-consumer dynamics, yielding results comparable to
empirical systems, while needing minimal parameters. To achieve this purpose, it
uses allometric scaling of metabolic biomass production and feeding rates,
meaning that the flow of biomass from a resource to its consumer depends on
their body mass.

Since the work of @yodz92bsc, @ches08ipc have shown that the dynamics of
ecological communities are driven not only by pairwise interactions, but also by
the fact that these interactions are embedded in larger networks, and @berl04isf
show how disturbances affecting species biomass or density cascade up, not only
to the species that they interact with, but with species up to two degrees of
separation from the original perturbation. In this context, models of energy
transfer through trophic interactions are better justified when they account for
the entire food-web structure, such as @will07hyi adaptation to food webs of
@yodz92bsc model. This food-web bio-energetic model has been used, for example,
to show how food web stability can emerge from allometric scaling [@bros06ase]
or allometry-constrained degree distributions [@otto07add]. Yet, although these
and other studies used the same mathematical model, implementations differ from
study to study and none have been released. Motivated by the fact that this
model addresses mechanisms that are fundamental to our understanding of energy
flow throughout food webs, we present `befwm` (Bio-Energetic Food-Webs Model), a
*Julia* package implementing @yodz92bsc bio-energetic model adapted for
food webs [@will07hyi] with updated allometric coefficients [@bros06ase;
@brow04mte].

This package aims to offer an efficient common ground for modeling food-web
dynamics, to make investigations of this model easier, and to facilitate
reproducibility and transparency of modeling efforts. Taking a broader
perspective, we argue that providing the community with reference
implementations of common models is an important task. First, implementing
complex models can be a difficult task, in which programming mistakes will bias
the output of the simulations, and therefore the ecological interpretations we
draw from them. Simulation-based studies are more at risk than analytical-based
ones, since the computational aspect is an additional layer of complexity on the
mathematical one. Second, reference implementations facilitate the comparison of
studies. Currently, comparing studies mean not only comparing results, but also
comparing implementations -- because not all code is public, a difference in
results cannot be properly explained as an error in either studies, and this
eventually generates more uncertainty than it does answers. Finally, reference
implementation eases reproducibility a lot. Specifically, it becomes enough to
specify which version of the package was used, and to publish the script used to
run the simulations (as we, for example, do in this manuscript). We fervently
believe that more effort invested in providing the community with reference
implementation of models representing cornerstones of our ecological
understanding is an important effort.

# The model

## Biomass dynamics

We implement the model as described by @bros06ase, which is itself explained in
greater detail in @will07hyi. This model describes the flows of biomass across
trophic levels, primarily defined by body size. It distinguishes populations
based on two variables known to drive many biological rates: body mass (how
large an organism is, *i.e.* how much biomass it stocks) and metabolic type
(where the organism get its biomass from, and how it is metabolized). Once this
distinction made, it models populations as simple stocks of biomass growing and
shrinking through consumer-resources interactions. The governing equations below
describe the changes in relative density of producers and consumers
respectively.

\begin{equation}\label{e:producer}
B'_i = r_i G_i B_i -\sum_{j \in \text{consumers}}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

\begin{equation}\label{e:consumer}
B'_i = -x_iB_i+\sum_{j \in \text{resources}} x_iy_iB_iF_{ij}-\sum_{j \in \text{consumers}}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

where $B_i$ is the biomass of population $i$, $r_i$ is the mass-specific maximum
growth rate, $G_i$ is the net growth rate, $x_i$ is $i$'s mass-specific
metabolic rate, $y_i$ is $i$'s maximum consumption rate relative to its
metabolic rate, $e_{ij}$ is $i$'s assimilation efficiency when consuming
population j and $F_{ij}$ is the multi-resources functional response of $i$
consuming $j$:

\begin{equation}\label{e:func_resp}
F_{ij}=\frac {\omega_{ij}B_{j}^{h}}{B_{0}^{h}+c_iB_iB_{0}^{h}+\sum_{k=resources}\omega_{ik}B_{k}^{h}}
\end{equation}

## Growth rate function

The formulation of the growth rate $G_i$ can be chosen among three possibilities
[@will08end] that all share the general equation of $G_i = 1 - s/k$, where $s$
is the sum of biomass of populations in competition for a ressource with
carrying capacity $k$. The first scenario, used by @bros06ase, sets $s = B_i$
and $k = K$: species only compete with themselves for independant resources. The
issue with this formulation [@kond03far] is that the biomass and productivity of
the system scales linearly with the number of primary producers. The second
formulation "shares" the resource across primary producers, with $s = B_i$ and
$k = K/n_P$, wherein $n_p$ is the number of primary producers. Finally, a more
general solution that encompasses both of the previous functions is $s =
\sum\alpha_{ij}B_j$, with $\alpha_{ii}$ (intraspecific competition) set to unity
and $\alpha_{ij}$ (inter-specific competition) taking values greater than or
equal to 0. Note that $\alpha_{ij} = 0$ is equivalent to $k = K$ and $s = B_i$.

## Numerical response

In equation \autoref{e:func_resp}, $\omega_{ij}$ is $i$'s relative consumption
rate when consuming $j$, or the relative preference of consumer $i$ for $j$
[@ches08ipc; @mcca98wti]. We have chosen to implement its simplest formulation:
$\omega_{ij} = 1/n_i$, where $n_i$ is the number of resources of consumer $j$.
$h$ is the Hill coefficient which is responsible for the hyperbolic or sigmoïdal
shape of the functional response [@real77kfr], $B_0$ is the half saturation
density and $c$ quantifies the strength of the intra-specific predator
interference -- the degree to which increasing the predator population's biomass
negatively affect its feeding rates [@bedd75mip; @dean75mti]. Depending on the
parameters $h$ and $c$ the functional response can take several forms such as
type II ($h = 1$ and $c = 0$), type III ($h > 1$ and $c = 0$), or predator
interference ($h = 1$ and $c > 0$).

## Metabolic types and scaling

As almost all organism metabolic characteristics vary predictably with body mass
[@brow04mte], these variations can be described by allometric relationships as
described in @bros06ase. Hence, the per unit biomass biological rates of
production, metabolism and maximum consumption follow negative power-law
relationships with the typical adult body mass [@pric12tmt; @sava04ebs].

\begin{equation}\label{e:production_rate}
R_P =  a_r M_P^{-0.25}
\end{equation}

\begin{equation}\label{e:metab_rate}
X_C =  a_x M_C^{-0.25}
\end{equation}

\begin{equation}\label{e:maxcons_rate}
Y_C =  a_y M_P^{-0.25}
\end{equation}

Where the subscripts P and C refer to producers and consumers populations
respectively, M is the typical adult body mass, and $a_r$, $a_x$ and $a_y$ are
the allometric constant. To resolve the dynamics of the system, it is necessary
to define a timescale. To do so, these biological rates are normalized by the
growth rate of the producers population (*cf.* \autoref{e:production_rate})
[@will07hyi; @bros06ase].

\begin{equation}\label{e:norm_production_rate}
r_i =  \frac {a_r M_P^{-0.25}} {a_r M_P^{-0.25}} = 1
\end{equation}

\begin{equation}\label{e:norm_metab_rate}
x_i =  \frac {a_x M_C^{-0.25}} {a_r M_P^{-0.25}} = \frac {a_x} {a_r} (\frac {M_C} {M_P})^{0.25}
\end{equation}

In equations \autoref{e:producer} and \autoref{e:consumer}, $y_{i}$ refer to the
maximum consumption rate of population $i$ relative to its metabolic rate. $y_i$
thus become a non-dimensional rate:

\begin{equation}\label{e:norm_maxcons_rate}
y_i = \frac {Y_C} {X_C} = \frac {\frac {a_y M_P^{-0.25}} {a_r M_P^{-0.25}}} { \frac{a_x M_C^{-0.25}} {a_r M_P^{-0.25}}} = \frac {a_y} {a_x}
\end{equation}

Assuming that most natural food webs have a constant size structure [@bros06cbr;
@hatt15ppl], the consumer-resource body-mass ratio ($Z$) is also constant. The
body mass of consumers is then a function of their mean trophic level ($T$), it
increases with trophic level when $Z\geq 1$ and decreases when $Z\leq 1$:

\begin{equation}\label{e:z_ratio}
M_C =  Z^{T-1}
\end{equation}

Where $M_C$ is the body mass of consumers, normalized by the body mass of the
basal species ($T = 1$) to make the results independent of the body mass of the
basal species.

## Setting the simulation parameters

All of these parameters can be modified before running the simulations (see
`?model_parameters`), and are saved alongside the simulation output for future
analyses. The default values and meanings of the different parameters are
explained in the documentation of the `model_parameters` function. The user can
specify which species are vertebrates by supplying a `vertebrate` array of
boolean values, and the body-mass of each species by supplying a `bodymass`
array of floating-point values.

## Saving simulations and output format

The core function `simulate` performs the main simulation loop. It takes two
arguments, `p` -- the dictionary generated through the `model_parameters`
function and containing the entire set of parameters -- and `biomass`, a vector
that contains the initial biomasses for every population. Three keywords
arguments can be used to define the initial (`start`) and final (`stop`) times
as well as the integration method (`use`, see `?simulate` or the on-line
documentation for more details on the numerical integration methods available).
This function returns an object with a fixed format, made of three fields: `:p`
has all the parameters used to start the simulation (including the food web
itself), `:t` has a list of all timesteps (including intermediate integration
points), and `:B` is is a matrix of biomasses for each population (columns) over
time (rows). All measures on output described below operate on this object.

The output of simulations can be saved to disk in either the `JSON` (javascript
object notation) format, or in the native `jld` format. The `jld` option should
be preferred since it preserves the structure of all objects (`JSON` should be
used when the results will be analyzed outside of `Julia`, for example in `R`).
The function to save results is called `befwm.save` (note that `befwm.` in front
is mandatory, to avoid clashes with other functions called `save` in base
`Julia` or other packages).

## Measures on output

The `befwm` package implements a variety of measures that can be applied on the
objects returned by simulations. All measures take an optional keyword argument
`last`, indicating over how many timesteps before the end of the simulations the
results should be averaged.

Total biomass (`total_biomass`) is the sum of the biomasses across all
populations. It is measured based on the populations biomasses
(`population_biomass`).

The number of remaining species (`species_richness`) is measured as the number
of species whose biomass is larger than an arbitrary threshold. Since `befwm`
uses robust adaptive numerical integrators (such as ODE45 and ODE78) the
threshold default value is $\epsilon$, *i.e.* the upper bound of the relative
error due to rounding in floating point arithmetic. In short, species are
considered extinct when their biomass is smaller than the rounding error. For
floating point values encoded over 64 bits (IEEE 754), this is around
$10^{-16}$. An additional output related to `species_richness` is
`species_persistence`, which is the number of persisting species divided by the
starting number of species. A value of `species_persistence` of 1 means that all
species persisted. A value of `species_persistence` of 0 indicates that all
species went extinct.

Shannon's entropy (`foodweb_diversity`) is used to measure diversity within the
food web. This measure is corrected for the total number of populations. This
returns values in $]0;1]$, where $1$ indicates that all populations have the
same biomass. It is measured as

\begin{equation}
H = - \frac{\sum b \times \text{log}(b)}{\text{log}(n)}\,,
\end{equation}

where $n$ is the number of populations, and $b$ are the relative biomasses ($b_i =
B_i / \sum B$).

Finally, we used the negative size-corrected coefficient of variation to assess
the temporal stability of biomass stocks across populations
(`population_stability`). This function accepts an additional `threshold`
argument, specifying the biomass below which populations are excluded from the
analysis. For the same reason as for the `species_richness` threshold, we
suggest that this value be set to either the machine's $\epsilon(0.0)$ (*i.e.*
the smallest value immediately above 0.0 that the machine can represent), or to
$0.0$. We found that using either of these values had no qualitative bearing on
the results. Values close to 0 indicate little variation over time, and
increasingly negative values indicate larger fluctuations (relative to the mean
standing biomass).

# Implementation and availability

The `befwm` package is available for the `julia` programming language, and is
continuously tested on the current version of `Julia`, as well as the release
immediately before, as well as on the current development version. `Julia` is an
ideal platform for this type of models, since it is easy to write, designed for
numerical computations, extremely fast, easily parallelized, and has good
numerical integration libraries. The package can be installed from the `Julia`
REPL using `Pkg.add("befwm")`. A user manual and function reference is available
online as a wiki at
[http://poisotlab.biol.umontreal.ca/julia-packages/befwm/wikis/home], which also
gives instructions about installing Julia, the package, and how to get started.

[http://poisotlab.biol.umontreal.ca/julia-packages/befwm/wikis/home]: http://poisotlab.biol.umontreal.ca/julia-packages/befwm/wikis/home

{==Note to reviewers: the code will be uploaded to the Julia packages repository
upon acceptance; meanwhile, the development version can be downloaded from the
URL given below using `Pkg.clone`, and has been attached to this submission.==}

The code is released under the MIT license. This software note describes version
`0.1.0`. The source code of the package can be viewed, downloaded, and worked on
at [http://poisotlab.biol.umontreal.ca/julia-packages/befwm]. The code is also
mirrored (read-only for stable versions) at
[https://github.com/PoisotLab/befwm.jl]. Potential issues with the code or
package can be reported at either places throug the *Issues* system. The code is
version-controlled, undergoes continuous integration, and has a code coverage of
approx. 90% to this date.

[http://poisotlab.biol.umontreal.ca/julia-packages/befwm]: http://poisotlab.biol.umontreal.ca/julia-packages/befwm
[https://github.com/PoisotLab/befwm.jl]: https://github.com/PoisotLab/befwm.jl

# Use cases

All functions in the package have an in-line documentation, available from the
`julia` interface by typing `?` followed by the name of the function. In this
section, we will describe three of the aforementionned use-cases. The code to
execute them is attached as Supp. Mat. to this paper. As all code in the
supplementary material uses `Julia`'s parallel computing abilities, it will
differ slightly from the examples given in the paper. For all figures, each
point is the average of at least 500 replicates. We conducted the simulations in
parallel on 50 Intel Xeon cores at 2.00 Ghz. All random networks were generated
using the implementation of the niche model of food webs [@will00sry] provided
in `befwm`.

## Effect of increasing carrying capacity

Starting from networks generated with the niche model, with 20 species,
connectance of $0.15 \pm 0.01$, we investigate the effect of increasing the
carrying capacity of the resource (on a log scale from 0.1 to 10). We use three
values of the $\alpha_{ij}$ parameter, ranging from favoring coexistence (0.92),
neutrally stable (1.0), to weak competitive exclusion (1.08).

!{carrying}

We run the simulations with the default parameters (given in
`?model_parameters`, and in the manual). Each simulation consists of the
following code:

~~~ julia
# We generate a random food web
A = nichemodel(20, 0.15)

# This loop will keep on trying food webs
# until one with a connectance close enough
# to 0.15 is found
while abs(befwm.connectance(A)-0.15)>0.01
    A = nichemodel(20, 0.15)
end

# Prepare the simulation parameters
for α in linspace(0.92, 1.08, 3)
  for K in logspace(-1, 1, 9)
    p = model_parameters(A, α=α,
        K=K,
        productivity=:competitive)
    # We start each simulation with
    # random biomasses in ]0;1[
    bm = rand(size(A, 1))
    # And finally, we simulate.
    out = simulate(p, bm, start=0,
          stop=2000, use=:ode45)
    # And measure the output
    diversity = foodweb_diversity(out,
                    last=1000,
                    threshold=eps())
  end
end
~~~

The results are presented in \autoref{carrying}.

## Effect of consumer-resource body-mass ratio on stability

In \autoref{vertebrate}, we illustrate how the effect of body-mass ratio differs
between food webs with invertebrates and vertebrate consumers.

!{vertebrate}

The body-mass ratio is controlled by the parameter $Z$ (field `Z` in the
code), and can be changed in the following way:

~~~ julia
# Prepare the simulation parameters
p = model_parameters(A, Z=scaling[i])
~~~

Which species is a vertebrate is controlled by the parameter `vertebrate` of
`model_parameters`, which is an array of boolean (true/false) values. In order
to have all consumers be vertebrates, we use

~~~ julia
vert = round(Bool,trophic_rank(A).>1.0)
~~~

so that for each network, we prepare the simulations with

~~~ julia
# Prepare the simulation parameters
p = model_parameters(A,
      Z=scaling[i],
      vertebrates=vert)
~~~

## Connectance effect on coexistence

We investigate the effect of connectance on species coexistence under different
scenarios of inter-specific competition rates between producers
(\autoref{connectance}). These simulations therefore measure how the persistence
of the entire food web is affected by competition at the most basal trophic
level. The persistence, which we use as the measure of coexistence, is the
number of remaining species (*i.e.* with a biomass larger than `eps()`), divided
by the initial number of species (20) -- note that there is also a
`species_persistence` function built-in.

!{connectance}

~~~ julia
for co in vec([0.05 0.15 0.25])
  # We generate a random food web
  A = nichemodel(20, co)
  while abs(befwm.connectance(A)-co)>0.01
      A = nichemodel(20, co)
  end
  # Prepare the simulation parameters
  for α in linspace(0.8, 1.2 , 7)
    p = model_parameters(A, α=α,
    productivity=:competitive)
    bm = rand(size(A, 1))
    # And finally, we simulate.
    out = simulate(p, bm, start=0,
          stop=2000, use=:ode45)
    # And measure the output
    persistence = species_richness(out,
                  last=1000,
                  threshold=eps()) / 20
  end
end
~~~

 Values of $\alpha$ larger than 0 should result in competitive exclusion in the
 absence of trophic interactions [@will08end]. Indeed, this is the case when $Co =
 0.05$ (only a single consumer remains). Increasing connectance results in more
 species persisting.

# Conclusion

We presented `befwm`, a reference implementation of the bio-energetic model
applied to food webs. We provided examples that can serve as templates to
perform novel simulation studies or use this model as an effective teaching
tool. Because the output can be exported in a language-neutral format (JSON),
the results obtained with this model can be analayzed in other languages that
are currently popular with ecologists, such as `R`, `python`, or `MatLab`.
Because we provide a general implementation that covers some of the modications
made to this model over the years, there is a decreased need for individual
scientists to start their own implementation, which is a both a time consuming
and potentially risky endeavor.

**Acknowledgements** TP acknowledges financial support from NSERC, and an
equipment grant from FRQNT. We thank the developers and maintainers of
`ODE.jl`.

# References
