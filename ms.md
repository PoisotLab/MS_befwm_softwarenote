---
title: Modelling biomass dynamics in food webs with `befwm`
short: The befwm package
bibliography: default.json
csl: plmt/plab.csl
author:
  - family: Poisot
    given: Timothée
    affiliation: 1, 2
    email: tim@poisotlab.io
    id: tp
    orcid: 0000-0002-0735-5184
  - family: Delmas
    given: Eva
    affiliation: 1, 2
    id: ed
    orcid: 0000-0002-6238-229X
affiliation:
  - id: 1
    text: Université de Montréal, Département de Sciences Biologiques
  - id: 2
    text: Québec Centre for Biodiversity Sciences
keyword:
  - k: metabolic theory of ecology
  - k: bio-energetic model
  - k: allometric scaling
  - k: food webs
figure:
  - id: temporal
    caption: With the default parameters, a food web with 20 populations and a connectance of 0.25 reaches a stable state within the first 100 timesteps. The solid line represents the average value across 50 independant runs, and the ribbon around it is the standard deviation.
    short: Example figure.
    file: temporal_dynamics.pdf
  - id: scaling
    caption: This is a figure.
    short: Example figure.
    file: scaling
date: \today
abstract: ...
---

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

where $B_i$ is the biomass of population $i$ and $F_{ij}$ is the multi-resources
functional response of $i$ consuming $j$ described in the following equation,
other parameters are described in \autoref{tab:parameters}:    

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

|Parameter|Description|Default value|
|:---:|:---|---:|
|$r_i$|mass-specific maximum growth rate of producer $i$|1|
|$K$|Carrying capacity of producers|1|
|$x_i$|$i$'s mass-specific metabolic rate, define in \autoref{e:metab_rate}|None|
|$y_i$|$i$'s maximum consumption rate relative to its metabolic rate|8 for invertebrates, 4 for ectotherm vertebrates|
|$e_{ij}$|$i$'s assimilation efficiency when consuming population j|0.85 for carnivores and 0.45 for herbivores|
|$ω_{ij}$|$i$'s relative consumption rate when consuming $j$ and correspond to $1/n$ where $n$ is $i$'s number of prey|None|
|$B_0$|half-saturation density|0.5 (can be set between 0 and K)|
|$h$|Hill coefficient|1 (define a type II Hill functional response, for a type III functional response, set h = 2)|
|$c$|quantifies the predator interference|0 (1 if there is case of predator interference, only possible in empirical cases if h = 1)|
|$a_x$|allometric constant of the metabolic rate $X_C = a_xM_C^{-0.25}$|0.314 for invertebrates and 0.88 for ectotherm vertebrates|
|$a_r$|allometric constant of the production rate $R_C = a_rM_P^{-0.25}$|1|

:Summary of the parameters used in the bio-energetic food-web model. The default implementation of the model correspond to all organisms in the networks being invertebrate, this -- as long as the values of all parameters -- can be changed using the `make_initial_parameters` function. For more details on the choice of parameters default values, see @brose_ase. \label{tab:parameters}

## Measures on output

The `befwm` package implements a variety of measures that can be applied on
the output of simulations.

Shannon's entropy

: Diversity within the community is measured through
  Shannon's entropy, corrected for the total number of populations. This
  returns values in $]0;1]$, where $1$ indicates that all populations have
  the same biomass.

Total biomass

: The total biomass within the community is simply defined as the sum of
  all biomasses at a given time.

Stability

: As in @brose_ase, we measure stability as being the negative of the
  coefficient of variation of biomasses of each population over a fixed
  number of timesteps. These are averaged, to give a measure representing
  the overall fluctuation of biomasses within the community. Values close
  to 0 are stable, and increasingly negative values are unstable.

# Implementation and availability

The `befwm` package is available for the `julia` programming language, and
has been tested with releases `0.3` (legacy), `0.4` (current as of writing),
and `0.5` (development) on Linux and Mac OS X. The package can be installed
from the `julia` REPL using

~~~ julia
Pkg.add("befwm")
~~~

The code is released under the MIT license. This software
note describes version `0.1.0`. The code is mirrored at
`https://github.com/PoisotLab/befwm.jl`, and we welcome potential
contributions. The code is version-controlled, undergoes continuous
integration, and has a code coverage of approx. 90% to this date.

# Use cases

Documentation is available online at
[https://www.gitbook.com/book/poisotlab/befwm/details], and can be downloaded
as a printable PDF. The documentation includes several use-cases, as well
as discussion of some design choices. All functions in the package have an
in-line documentation, available from the `julia` interface.

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
p = A |> make_initial_parameters |> make_parameters

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

# References
