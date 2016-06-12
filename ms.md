# Introduction

Research in ecology has long seek to understand the processes influencing the
diversity and stability of natural communities. These communities are formed by
populations whose dynamics of persistence and extinction depends on resource
availability. Seeing that the coexistence of populations is thus constrained by
feeding interactions, models have been created equating the relationship between
resources and consumers, from the simplest, most generalist models -- such as
the Lotka-Volterra model @lotka1926,@volterra1928 -- to more tailored and
parametrized ones. Among these, @yodzis_bsc generalist resource-consumer model
has the advantage of yielding results close to the empirical observations while
needing only few, easy to assess parameters. To achieve this purpose, it uses
allometric scaling of metabolic and assimilation rates, meaning that the flow of
biomass from a resource to its consumer thus depends on the body-mass ratio
between them.

{>>@tp This needs an additional paragraph to explain the need to change
perspective from one interaction to a whole community. Needs to cite Berlow,
at least, but also Holt, Payne, etc. Key message: there is a level of structure
in food webs that matters beyond pairwise interactions. See also Stouffer
on motifs to explain why larger scale is necessary. Finish by presenting
the bioenergetic model applied to food webs.<<}

Adaptations of this model have been use to show that allometric scaling enhances
predictions regarding stability (Brose et al., 2006, Otto et al., 2007),
interaction strength (Berlow et al., 2009, Boit et al., 2012, Iles et Novak, 2016)
and perturbation spread (Iles et Novak, 2016) within large, realistic food
webs. Yet, although these authors used the same model, they used personal
adaptation and implementation of it. Here we present `befwm`, a Julia package
implementing @brose_ase adaptation of @yodzis_bsc bio-energetic model for
food-webs (@williams_hyi) with updated allometric coefficients. This package
aims at offering an efficient common ground for modeling food-webs dynamics
using this particular model.

# The model

## Biomass dynamics

We implement the model as described by @brose_ase, which is itself explained in
greater detail in @williams_hyi. This model describes the flows of biomass
across trophic levels, primarily defined by body size. It distinguishes
population based on two highly influential variables for the metabolism and
assimilation rates, body-mass and metabolic type. Once this distinction made, it
model populations as simple stocks of biomass growing and shrinking through
consumer-resources interactions (@williams_hyi). The governing equations below
describe the changes in relative density of producers and consumers
respectively.

\begin{equation}\label{e:producer}
B'_i = r_i(1-\frac{B_i}{K}) B_i -\sum_{j \in \text{consumers}}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

\begin{equation}\label{e:consumer}
B'_i = -x_iB_i+\sum_{j \in \text{resources}} x_iy_iB_iF_{ij}-\sum_{j \in \text{consumers}}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

?{parameters}

where $B_i$ is the biomass of population $i$, $r_i$ is the mass-specific
maximum growth rate, $K$ is the carrying capacity, $x_i$ is $i$'s mass-specific
metabolic rate, $y_i$ is $i$'s maximum consumption rate relative to its
metabolic rate, $e_{ij}$ is $i$'s assimilation efficiency when consuming
population j and $F_{ij}$ is the multi-resources functional response of $i$
consuming $j$:

\begin{equation}\label{e:func_resp}
F_{ij}=\frac {\omega_{ij}B_{j}^{h}}{B_{0}^{h}+c_iB_iB_{0}^{h}+\sum_{k=resources}\omega_{ik}B_{k}^{h}}
\end{equation}

Depending on the parameters $h$ and $c$ the functional response can take several
forms (see \autoref{tab:parameters}).

As almost all organism metabolic characteristics vary predictably with body-mass
(@brown_tmt), these variations can be described by allometric relationships as
described in @williams_hyi and @brose_ase. Hence, the biological rates of
production, metabolism and maximum consumption follow negative power-law
relationships with the typical adult body-mass (@enquist_asp,@brown_tmt). After
normalizing and simplifying these relationships, it results that the
mass-specific metabolic rate $x_i$ is a function of both metabolic type and
body-mass (see \autoref{}), while the maximum consumption rate $y_i$ is
influenced only by the metabolic type and the assimilation efficiency $e_{ij}$
is function of $i$'s diet (herbivore or carnivore).

$$
x_i = \frac {a_x} {a_r} (\frac {M_C} {M_P})^{-0.25}
$$

The subscripts P and C refer to producers and consumers populations
respectively, M is the typical adult body-mass and $a_r$, $a_x$ and $a_y$ are
the allometric constant (see \autoref{tab::parameters}).


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

{== note to reviewers -- the code will be uploaded to the Julia packages repository upon acceptance ==}

~~~ julia
Pkg.add("befwm")
~~~

The code is released under the MIT license. This software note describes
version `0.1.0`. The source code of the package can be viewed, downloaded,
and worked on at `http://poisotlab.biol.umontreal.ca/XXX` {>>@tp todo <<}. The
code is also mirrored at `https://github.com/PoisotLab/befwm.jl`. Potential
issues with the code or package can be reported at either places. The code
is version-controlled, undergoes continuous integration, and has a code
coverage of approx. 90% to this date.

# Use cases

Documentation is available online at
[https://www.gitbook.com/book/poisotlab/befwm/details], and can be downloaded
as a printable PDF. The documentation includes several use-cases, as well
as discussion of some design choices. All functions in the package have an
in-line documentation, available from the `julia` interface by typing `?`
followed by the name of the function.

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
`?make_initial_parameters`, and in the manual). Each simulation consists of
the following code:

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
p = make_initial_parameters(A)
p = make_parameters(p)

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

The allometric scaling is controlled by the parameter $Z$ (field `:Z` in
the code), and can be changed in the following way:

~~~ julia
# Prepare the simulation parameters
p = make_initial_parameters(A)
# Change the scaling
p[:Z] = scaling[i]
# Finishes the simulation parameters
p = make_parameters(p)
~~~

Note that the value of `:Z` *has* to be changed before `make_parameters`
is called. This is because `make_parameters` will calculate the allometry
for the different populations based on $Z$, their trophic rank, etc. These
parameters are calculated only once, which allows an efficient implementation
of the model.

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
