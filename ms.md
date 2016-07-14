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
their body-mass.

Since the work of @yodz92bsc, @ches08ipc have shown that the dynamics of
ecological communities are driven not only by pairwise interactions, but also by
the fact that these interactions are embedded in larger networks, and @berl04isf
show how disturbances affecting species biomass or density cascade up, not only
to the species that they interact with, but with species up to two degrees of
separation from the original perturbation. In this context, models of energy
transfer through trophic interactions are better justified when they account for
the entire food web structure, such as @will07hyi adaptation to food-webs of
@yodz92bsc model. This food-web bio-energetic model has been used, for example,
to show how food web stability can emerge from allometric scaling [@bros06ase]
or allometry-constrained degree distributions [@otto07add]. Yet, although these
and other studies used the same mathematical model, implementations differ from
study to study and none have been released. Motivated by the fact that this
model addresses mechanisms that are fundamental to our understanding of energy
flow throughout food webs, we present `befwm` (Bio-Energetic Food Webs Model), a
*Julia* package implementing @yodz92bsc bio-energetic model adapted for
food-webs [@will07hyi] with updated allometric coefficients [@bros06ase;
@brow04mte]. This package aims to offer an efficient common ground for modeling
food-web dynamics, to make investigations of this model easier, and to
facilitate reproducibility and transparency of modeling efforts.  

# The model

## Biomass dynamics

We implement the model as described by @bros06ase, which is itself explained
in greater detail in @will07hyi. This model describes the flows of biomass
across trophic levels, primarily defined by body size. It distinguishes
populations based on two highly influential variables for the biological rates,
body mass and metabolic type. Once this distinction made,
it models populations as simple stocks of biomass growing and shrinking
through consumer-resources interactions. The governing
equations below describe the changes in relative density of producers and
consumers respectively.

\begin{equation}\label{e:producer}
B'_i = r_i G_i B_i -\sum_{j \in \text{consumers}}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

\begin{equation}\label{e:consumer}
B'_i = -x_iB_i+\sum_{j \in \text{resources}} x_iy_iB_iF_{ij}-\sum_{j \in \text{consumers}}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

where $B_i$ is the biomass of population $i$, $r_i$ is the mass-specific
maximum growth rate, $G_i$ is the net growth rate, $x_i$ is $i$'s mass-specific
metabolic rate, $y_i$ is $i$'s maximum consumption rate relative to its
metabolic rate, $e_{ij}$ is $i$'s assimilation efficiency when consuming
population j and $F_{ij}$ is the multi-resources functional response of $i$
consuming $j$:

\begin{equation}\label{e:func_resp}
F_{ij}=\frac {\omega_{ij}B_{j}^{h}}{B_{0}^{h}+c_iB_iB_{0}^{h}+\sum_{k=resources}\omega_{ik}B_{k}^{h}}
\end{equation}

In equation \autoref{e:func_resp}, $\omega_{ij}$ is $i$'s relative consumption
rate when consuming $j$, or the relative preference of consumer $i$ for $j$
(refs. Chesson 1983; McCann and Hastings 1997). We have chosen to implement its
simplest formulation: $\omega_{ij} = 1/n_i$, where $n_i$ is the number of
resources of consumer $j$. $h$ is the Hill coefficient which is responsible for
the hyperbolic or sigmoïdal shape of the functional response [@real77kfr], $B_0$
is the half saturation density and $c$ quantifies the strength of the
intra-specific predator interference -- the degree to which increasing the
predator population's biomass negatively affect its feeding rates [@bedd75mip;
@dean75mti]. Depending on the parameters $h$ and $c$ the functional response can
take several forms such as type II ($h = 1$ and $c = 0$), type III ($h > 1$ and
$c = 0$), or predator interference ($h = 1$ and $c > 0$).

The formulation of the growth rate $G_i$ can be chosen among three possibilities
(ref William 2008). The first is the same as used by @bros06ase, a simple
logistic growth rate model where each producer have its own carrying capacity
($K_i = K = 1$ in @bros06ase model), then $G_i = 1 - \frac {B_i} {K}$. Choosing
this model yield the issue of having both the total biomass and primary
productivity of the system increasing with the number of producer in the system
(ref. Kondoh 2003). Choosing a system-wide carrying capacity allows to control
for this effect. Then, the carrying capacity of the basal species can be $K_i =
\frac {K} {n_p}$ where $n_p$ is the number of producers. Or a second
possibility is to have $G_i$ being a Lotka-Volterra competition system where the
producers compete for the system-wide carrying capacity. Then $G_i =
1-\frac{\sum_{j \in \text{producers}}\alpha_{ij}B_j}{K}$ where $\alpha_{ij}$
defines the competition rates between the basal species.   

As almost all organism metabolic characteristics vary predictably with
body-mass [@brow04mte], these variations can be described by allometric
relationships as described in @bros06ase. Hence, the per unit biomass
biological rates of production, metabolism and maximum consumption follow
negative power-law relationships with the typical adult body-mass [@pric12tmt;
@sava04ebs].

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
respectively, M is the typical adult body-mass and $a_r$, $a_x$ and $a_y$ are
the allometric constant. To resolve the dynamics of the system, it is necessary
to define a timescale. To do so, these biological rates are normalized by the
growth rate of the producers population (c.f. \autoref{e:production_rate}) (ref.
Brose 2008, @will07hyi and @bros06ase).  

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

Assuming that most natural food-webs have a constant size structure (ref Brose
et al., 2006a Comsumer-resource body-size relationships in natural food webs;
ref Hatton et al., 2015 The predator-prey power law: Biomass scaling across
terrestrial and aquatic biomes), the consumer-resource body-mass ratio ($Z$) is
also constant. The body-mass of consumers is then a function of their mean
trophic level ($T$), it increases with trophic level when $Z>1$ and decrease
when $Z<1$:

\begin{equation}\label{e:z_ratio}
M_C =  Z^T
\end{equation}

## Measures on output

The `befwm` package implements a variety of measures that can be applied on
the objects returned by simulations. All measures take an optional keyword
argument `last`, indicating over how many timesteps before the end of the
simulations the results should be averaged.

Shannon's entropy (`foodweb_diversity`) is used to measure diversity within the
food web. This measure is corrected for the total number of populations. This
returns values in $]0;1]$, where $1$ indicates that all populations have
the same biomass. It is measured as

\begin{equation} H = - \frac{\sum b \times \text{log}(b)}{\text{log}(n)}
\,, \end{equation}

where $n$ is the number of populations, and $b$ are the relative biomasses
($b_i = B_i / \sum B$).

Total biomass (`total_biomass`) is the sum of the biomasses across
all populations. It is measured based on the populations biomasses
(`population_biomass`).

Finally, we used the negative size-corrected coefficient of variation
to assess the temporal stability of biomass stocks across populations
(`population_stability`). This function accepts an additional `threshold`
argument, specifying the biomass below which populations are excluded from
the analysis. Since `befwm` uses robust numerical integrators, we suggest
that this value be set to either the machine's $\epsilon(0.0)$ (*i.e.*
the smallest value immediately above 0.0 that the machine can represent),
or to $0.0$. We found that using either of these values had no qualitative
bearing on the results. Values close to 0 indicate little variation over time,
and increasingly negative values indicate larger fluctuations (relative to
the mean standing biomass).

## Saving simulations and output format

The core function (`simulate`) returns objects with a fixed format, made
of three fields: `:p` has all the parameters used to start the simulation
(including the food web itself), `:t` has a list of all timesteps (including
intermediate integration points), and `:B` is is a matrix of biomasses for
each population (columns) over time (rows). All measures on output described
above operate on this object.

The output of simulations can be saved to disk in either the `JSON`
(javascript object notation) format, or in the native `jld` format. The `jld`
option should be preferred since it preserves the structure of all objects
(`JSON` should be used when the results will be analyzed outside of `Julia`,
for example in `R`). The function to save results is called `befwm.save`
(note that `befwm.` in front is mandatory, to avoid clashes with other
functions called `save` in base `Julia` or other packages).

Since running simulations is usually the more time-consuming thing, we
recommend that simulation results be saved, and analyzed later on.

# Implementation and availability

The `befwm` package is available for the `julia` programming language, and is
continuously tested on the current version of `Julia`, as well as the release
immediately before, as well as on the current development version. `Julia`
is an ideal platform for this type of models, since it is easy to write,
designed for numerical computations, extremely fast, easily parallelized,
and has good numerical integration libraries. The package can be installed
from the `Julia` REPL using

{==Note to reviewers: the code will be uploaded to the Julia packages
repository upon acceptance; meanwhile, please use the development version.==}

~~~ julia
Pkg.add("befwm")
~~~

for the last stable release, or

~~~ julia
Pkg.clone("http://poisotlab.biol.umontreal.ca/julia-packages/befwm.git")
~~~

for the current development release.

The code is released under the MIT license. This
software note describes version `0.1.0`. The source code
of the package can be viewed, downloaded, and worked on at
`http://poisotlab.biol.umontreal.ca/julia-packages/befwm`. The code is also
mirrored (read-only) at `https://github.com/PoisotLab/befwm.jl`. Potential
issues with the code or package can be reported at either places. The code
is version-controlled, undergoes continuous integration, and has a code
coverage of approx. 90% to this date.

# Use cases

Documentation is available online at [http://poisotlab.io/doc/befwm/]. The
documentation includes several use-cases, as well as discussion of some design
choices. All functions in the package have an in-line documentation, available
from the `julia` interface by typing `?` followed by the name of the function.

[https://www.gitbook.com/book/poisotlab/befwm/details]: https://www.gitbook.com/book/poisotlab/befwm/details

In this section, we will describe two use-cases (the code to execute them
is given in the manual, and is attached as Supp. Mat. to this paper).

## Illustration of the temporal dynamics

We will investigate the temporal dynamics of total biomass (sum of biomasses
of all populations), and of diversity (Shannon's index of biomasses) across
50 replicate simulations. Every simulation uses a different network (generated
with the niche model, 20 species, connectance of $0.25 \pm 0.01$).

!{temporal}

We run the simulations with the default parameters (given in
`?model_parameters`, and in the manual). Each simulation consists of the
following code:

~~~ julia
# We generate a random food web
A = nichemodel(20, 0.25)

# This loop will keep on trying food webs until
# one with a connectance close enough to 0.25
# is found
while abs(befwm.connectance(A) - 0.25) > 0.01
    A = nichemodel(20, 0.25)
end

# Prepare the simulation parameters
p = model_parameters(A)

# We start each simulation with random biomasses
# in ]0;1[
bm = rand(size(A, 1))

# And finally, we simulate over 500 timesteps
out = simulate(p, bm, start=0, stop=500,
        steps=1500, use=:ode45)
~~~

The results are presented in \autoref{temporal}. With this choice of
parameters, the community reaches stability within 100 timesteps.

## Effect of allometric scaling on stability and diversity

We now illustrate how the package can be used to explore responses of the
system to changes in parameters. In particular, we explore how diversity
and population stability are affected by an increase in connectance. The
results are presented in \autoref{scaling}.

!{scaling}

The allometric scaling is controlled by the parameter $Z$ (field `Z` in the
code), and can be changed in the following way:

~~~ julia
# Prepare the simulation parameters
p = model_parameters(A, Z=scaling[i])
~~~

All model parameters can be used this way, and explained in the documentation
of `?model_parameters`.

# Conclusions

We presented `befwm`, a reference implementation of the bio-energetic model
applied to food webs. The two examples given can serve as templates to develop
future studies. Taking a broader perspective, we argue that providing the
community with reference implementations of common models is an important
task. First, implementing complex models can be a difficult task, in which
programming mistakes will bias the output of the simulations, and therefore
the ecological interpretations we draw from them. Simulation-based studies
are more at risk than analytical-based ones, since the computational aspect is
an additional layer of complexity on the mathematical one. Second, reference
implementations facilitate the comparison of studies. Currently, comparing
studies mean not only comparing results, but also comparing implementations --
because not all code is public, a difference in results cannot be properly
explained as an error in either studies, and this eventually generates more
uncertainty than it does answers. Finally, reference implementation ease
reproducibility a lot. Specifically, it becomes enough to specify which version
of the package was used, and to publish the script used to run the simulations
(as we, for example, do in this manuscript). We fervently believe that more
effort invested in providing the community with reference implementation
of models representing cornerstones of our ecological understanding is an
important effort.

# References
