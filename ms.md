---
title: Modelling biomass dynamics in food webs with `befwm`
short: The befwm package
bibliography: default.json
csl: vancouver-author-date.csl
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

## Measures on output

# Implementation and availability

The `befwm` package is available for the `julia` programming language, and
has been tested with releases `0.3` (legacy), `0.4` (current as of writing),
and `0.5` (development) on Linux and Mac OS X. The package can be installed
from the `julia` REPL using

~~~ julia
Pkg.add("befwm")
~~~

The code is released under the MIT license. This software note describes
version `0.1.0`.

Documentation is available online at
`https://www.gitbook.com/book/poisotlab/befwm/details`, and can be downloaded
as a printable PDF. The documentation includes several use-cases, as well
as discussion of some design choices. All functions in the package have an
in-line documentation, available from the `julia` interface.

# Use cases

## Allometric scaling stabilizes food webs

## Connectance (something something)

# References
