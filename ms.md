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
  - id: figure1
    caption: This is a figure.
    short: Example figure.
    file: figure1.png
  - id: figure2
    caption: This is a second figure. It is taking the two columns in preprint mode.
    short: Example figure.
    file: figure1.png
    wide: true
date: Work in progress.
abstract: ...
---


# The model

## Biomass dynamics


We implement the model as described by @brose_ase, which is itself described in
greater detail in @williams_hyi -- this model is an adaptation of the
@yodzis_bsc classical bio-energetic model, describing the flows of biomass
across trophic levels, primarily defined by body size. It distinguishes
population based on two highly influential variables for the metabolism and
assimilation rates, body-size and metabolic type. Once this distinction made, it
model populations as simple stock of biomass growing and shrinking through
consumer-resources interactions (@williams_hyi). We used the version of the
model with updated allometric coefficients (@brose_ase, @brown2004) and extended
to multispecies systems (@williams_hyi). The governing equations below describe
the changes in relative density of producers (\autoref{e:consumer}) and consumers (Eq. 2)
respectively.

\begin{equation}\label{e:consumer}
B'_i = r_i(1-\frac{B_i}{K}) B_i -\sum_{j=consumers}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
\end{equation}

We implement the model as described by @brose_ase, which is itself described in
greater detail in @williams_hyi -- this model is an adaptation of the
@yodzis_bsc classical bio-energetic model, describing the flows of biomass
across trophic levels, primarily defined by body size. It distinguishes
population based on two highly influential variables for the metabolism and
assimilation rates, body-size and metabolic type. Once this distinction made, it
model populations as simple stock of biomass growing and shrinking through
consumer-resources interactions (@williams_hyi). We used the version of the
model with updated allometric coefficients (@brose_ase, @brown2004) and extended
to multispecies systems (@williams_hyi). The governing equations below describe
the changes in relative density of producers (Eq. 1) and consumers (Eq. 2)
respectively.

$$
B'_i = r_i(1-\frac{B_i}{K}) B_i -\sum_{j=consumers}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
$$

$$B'_i = -x_iB_i+\sum_{j=resources}^{}x_iy_iB_iF_{ij}-\sum_{j=consumers}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
$$

Where $B_i$ is the biomass of population $i$, $r_i$ is the mass-specific maximum
growth rate -- which is set to 1 to define the time-scale of the system, $K$ is
the carrying capacity, $x_i$ is $i$'s mass-specific metabolic rate, $y_i$ is
$i$'s maximum consumption rate relative to its metabolic rate, $e_{ij}$ is $i$'s
assimilation efficiency when consuming population j and $F_{ij}$ is the
functional response of $i$ consuming $j$, described below.   

As almost all organism metabolic characteristics vary predictably with
body-mass, these variations can be described by allometric relationships. Hence,
the biological rates of production (R), metabolism (X) and maximum consumption
(Y) follow negative power-law relationships with the typical adult body-mass
(Enquist et al., 1999, Brown, 2004) (Eq. 3 - 5).

$$
R_P = a_rM_P^{-0.25}
$$

$$
X_C = a_xM_C^{-0.25}
$$

$$
Y_C = a_yM_C^{-0.25}
$$

The subscripts P and C refer to producers and consumers populations
respectively, M is the typical adult body-mass and $a_r$, $a_x$ and $a_y$ are
the allometric constant. Then, the metabolic rates $x_i$ of all populations are
normalized by the time-scale (Eq. 6) and the maximum consumption rates $y_i$ are
normalized by the metabolic rates (Eq. 7) (@yodzis_bsc, @brose_ase).   

$$
x_i = \frac {X_C} {R_P} = \frac {a_x} {a_r} (\frac {M_C} {M_P})^{-0.25}
$$
$$
y_i = \frac {Y_C} {X_P} = \frac {a_y} {a_x}
$$

Consumers' mass $M_C$ is expressed relatively to the mass of the basal species
to make the results independent of the mass of basal species:

$$
M_C =Z^T
$$
where $Z$ is the predator-prey body mass ratio and $T$ the trophic level of
consumer C (@brose_ase).

The multi-resources functional response describes the portion of the resource
population $j$ consumed by the consumer population $i$ as a function of the
biomass of all of its resources $k$ (Eq. 8):

$$
F_{ij}=\frac {\omega_{ij}B_{j}^{h}}{B_{0}^{h}+c_iB_iB_{0}^{h}+\sum_{k=resources}\omega_{ik}B_{k}^{h}}
$$

In this equation $\omega_{ij}$ is $i$'s relative consumption rate when consuming $j$
($\omega_{ij}=1/n$, where $n$ is the number of resource of the consumer species
$i$), $B_0$ is the half-saturation density, $h$ is Hill coefficient ($h=1$
yield a type II functional response and $h=2$ a type III) and $c$ quantifies
predator interference ($c=1$ in case of predator interference and $0$
otherwise).


$$B'_i = -x_iB_i+\sum_{j=resources}^{}x_iy_iB_iF_{ij}-\sum_{j=consumers}\frac{x_jy_jB_jF_{ji}}{e_{ji}}
$$

Where $B_i$ is the biomass of population $i$, $r_i$ is the mass-specific maximum
growth rate -- which is set to 1 to define the time-scale of the system, $K$ is
the carrying capacity, $x_i$ is $i$'s mass-specific metabolic rate, $y_i$ is
$i$'s maximum consumption rate relative to its metabolic rate, $e_{ij}$ is $i$'s
assimilation efficiency when consuming population j and $F_{ij}$ is the
functional response of $i$ consuming $j$, described below.   

As almost all organism metabolic characteristics vary predictably with
body-mass, these variations can be described by allometric relationships. Hence,
the biological rates of production (R), metabolism (X) and maximum consumption
(Y) follow negative power-law relationships with the typical adult body-mass
(Enquist et al., 1999, Brown, 2004) (Eq. 3 - 5).

$$
R_P = a_rM_P^{-0.25}
$$

$$
X_C = a_xM_C^{-0.25}
$$

$$
Y_C = a_yM_C^{-0.25}
$$

The subscripts P and C refer to producers and consumers populations
respectively, M is the typical adult body-mass and $a_r$, $a_x$ and $a_y$ are
the allometric constant. Then, the metabolic rates $x_i$ of all populations are
normalized by the time-scale (Eq. 6) and the maximum consumption rates $y_i$ are
normalized by the metabolic rates (Eq. 7) (@yodzis_bsc, @brose_ase).   

$$
x_i = \frac {X_C} {R_P} = \frac {a_x} {a_r} (\frac {M_C} {M_P})^{-0.25}
$$
$$
y_i = \frac {Y_C} {X_P} = \frac {a_y} {a_x}
$$

Consumers' mass $M_C$ is expressed relatively to the mass of the basal species
to make the results independent of the mass of basal species:

$$
M_C =Z^T
$$
where $Z$ is the predator-prey body mass ratio and $T$ the trophic level of
consumer C (@brose_ase).

The multi-resources functional response describes the portion of the resource
population $j$ consumed by the consumer population $i$ as a function of the
biomass of all of its resources $k$ (Eq. 8):

$$
F_{ij}=\frac {\omega_{ij}B_{j}^{h}}{B_{0}^{h}+c_iB_iB_{0}^{h}+\sum_{k=resources}\omega_{ik}B_{k}^{h}}
$$

In this equation $\omega_{ij}$ is $i$'s relative consumption rate when consuming $j$
($\omega_{ij}=1/n$, where $n$ is the number of resource of the consumer species
$i$), $B_0$ is the half-saturation density, $h$ is Hill coefficient ($h=1$
yield a type II functional response and $h=2$ a type III) and $c$ quantifies
predator interference ($c=1$ in case of predator interference and $0$
otherwise).

## Measures on output

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

As there is an extensive documentation, we will here describe two "use-cases"
explaining how `befwm` can be used.

## Allometric scaling stabilizes food webs

## Connectance (something something)

# References
