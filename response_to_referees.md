# Response to referees

We thank the reviewers for their positive comments and their insightful feedback on the manuscript and the code. We found these comments helpful for improving both.
We re-submit an improved manuscript incorporating the reviewers' suggestions. Mainly, we have changed the package name and have extended our argumentation about why we think the field would benefit from this implementation of the bio-energetic model of Yodzis and Ines (1992).

## Associate Editor's comments to the Author:

>I have received two reviews for this manuscript; both broadly positive but
with constructive suggestions that will improve the manuscript. Reviewer 1
in particular questions how widely this will be used - some expansion of
section IV would be useful here.

>Much is made of the high performance nature of the code here, but no
benchmarks are provided and no comparisons with competing approaches are
provided.  Is this modelling work routinely limited by speed?  And is the
step change in speed here enough to help this?  Given that most ODE solvers
find their way into heavily optimised compiled code, it's not immediately
clear there will be a significant difference.  Some clarification here may
help justify the statements.

>Also I note that on ODE.jl the README says: *"Need something long-term reliable right now?
 See the Sundials.jl package, which provides wrappers for the excellent
Sundials ODE solver library."*

>(among other statements of instability).  Is this overstated?

In part, yes. The instability refers not to the behavior of the code, but
to the API itself, meaning that it may change in future releases. However,
because we have organized the code so that all calls to ODE.jl go through a
single function, and it will be easy for us to track API changes. In over a
year of working with ODE.jl, we have noted no change in API (and no difference
in performance when using this or Sundials.jl).*

## Reviewer 1

> This is a clearly written Application note, introducing a julia package for
 simulating biomass dynamics in community food webs. I don't know a lot
 about foodwebs and biomass dynamics (I assume I was chosen as a reviewer
 because I am familiar with julia), so I will just remark on the
 presentation and application here. The application appears to do what it
 promises with a reasonably intuitive interface. The documentation looks
 thorough and accessible and the code is clean and appears efficient. There
 isn’t a lot of code as the package draws extensively on existing
 functionality in other julia packages, but that is in accordance with good
 coding practice.

 We thank the reviewer for his positive comments; as is the case for most
 languages with thriving package ecosystems, we indeed draw on the work of the
 community to avoid re-implementation of existing features.

 > At present, though, I don’t think the authors make a compelling case that
 this software will be taken up and used widely in the field. One of the
 motivations for publishing software papers is to make tools that may be
 used broadly and generally available to the wider ecological community, to
 enhance reproducibility and efficiency among ecologists. I think it would
 be nice if the authors could provide, e.g. a list of published papers since
 2008 that have used the underlying mathematical model and could have
 benefitted from having this package available, and perhaps include as an
 example a reanalysis of one of these papers that directly demonstrates how
 easy it is with this package. If that is not feasible, then at the very
 least look ahead and highlight how this package has broader general
 applicability.

 As shown in table \ref{listpapers}, the bio-energetic model has been widely
 used to this days in community ecology, and helped to produce some influential
 results. Each of the study presented in the table \ref{listpapers} used their
 own implementation, and none were released to this day, making it difficult to
 reproduce their results. The fact that the bio-energetic model can be applied
 to any type of community, and that it can be used in combination with other
 model (such as the nutrient-intake model, Brose et al., 2005a,b; Brose et al.,
 2008) make it a broadly used model in community ecology. In addition, some of
 the authors have used this model extensively for teaching. Although this did
 not result in publications, we believe that this type of packages is valuable
 as a teaching tool too.

 \begin{table}[H]
 \centering
 \caption{List of published papers since
 2007 that have used the underlying mathematical model, with specification of the parameters used for bothe the growth rate and the functional response.}
 \label{listpapers}
 \begin{tabular}{@{}lllllll@{}}
 \toprule
 Reference                  & Title                                                                                                                                                  & Food webs                                                                                                                                      & Model reference                                                                            & Growth rate function                                                                                                                                                                                           & Functional response                                                                                                                                                                                 & Implementation \\ \midrule
 Otto et al., 2007          & Allometric degree distributions facilitate food-web stability                                                                                          & modules from 5 natural food webs                                                                                                               & Yodzis & Ines, 1992                                                                        & \begin{tabular}[c]{@{}l@{}}productivity = :species\\ $G_i = 1 - \frac{B_i}{K}$ where $K = 1$\end{tabular}                                                                                                      & \begin{tabular}[c]{@{}l@{}}Type II (:h = 1 and :c = 0)\\ $\omega_{i,j} = 1$\end{tabular}                                                                                                            & Not released   \\
 Rall et al., 2007          & Food-web connectance and predator interference dampen the paradox of enrichment                                                                        & Cascade model (Cohen et al. 1990), Niche model (Williams and Martinez 2000) and Nested hierarchy model (Cattin et al. 2004)                    & Yodzis & Ines, 1992                                                                        & productivity = :species$G_i = 1 - \frac{B_i}{K}$ where $-2                                                                                                                                                     & Type II (:h = 1, :c =0), III (:h = 2, :c = 0) and predator interference,(:h = 1, :c = 1) or gradient (1<:h<2 and 0<:c<4) $\omega_{i,j} = 1/n_i$                                                     & Not released   \\
 Brose 2008                 & Complex food webs prevent competitive exclusion among producer species                                                                                 & Simulated food webs (niche model of Williams & Martinez, 2000)                                                                                 & Yodzis & Ines, 1992                                                                        & Producer–nutrient model (Brose et al., 2005a,b)                                                                                                                                                                & Hill exponent (:h) and predator interference (:c) randomly drawn from,truncated normal distributions.$\omega_{i,j} = 1/n_i$ where $n_i$ is j's,number of resources or $\omega_{i,j}$ randomly drawn & Not released   \\
 Williams, 2008             & Effects of network and dynamical model structure on species persistence in large model food webs                                                       & Cascade model (Cohen et al. 1990), Niche model (Williams and Martinez,2000) Generalized cascade model (Stouffer et al. 2005) and random model. & Brose et al. 2006; Williams et al. 2007; Williams and Martinez 2004; Yodzis and Innes 1992 & :productivity = :species, :system or :competitive                                                                                                                                                              & Type II (:h = 1, :c = 0), Weak type III (:h = 1.2, :c = 0) or Weak predator interference (:h = 1, :c = 0.5)$\omega_{i,j} = B_0/B_{0_{ij}}$                                                          & Not released   \\
 Stouffer & Bascompte, 2010 & Understanding food-web persistence from local to global scales                                                                                         & Simulated food webs (niche model of Williams & Martinez, 2000)                                                                                 & Yodzis & Ines 1992                                                                         & productivity = :species                                                                                                                                                                                        & Type II (:h = 1, :c = 0)                                                                                                                                                                            & Not released   \\
 Binzer et al., 2011        & The susceptibility of species to extinctions in  model communities                                                                                     & Simulated food webs (niche model of Williams & Martinez, 2000)                                                                                 & Yodzis & Ines, 1992                                                                        & \begin{tabular}[c]{@{}l@{}}productivity = :system\\ $G_i = 1 - \frac{B_i}{K_{sys}/n_p}$ where $K_{sys}$ is the system-wide carrying capacity and $n_p$ is the number of producers in the system.\end{tabular}  & \begin{tabular}[c]{@{}l@{}}Hill exponent (:h) and predator interference (:c) randomly drawn from truncated normal distributions.\\ $\omega_{i,j} = 0.5$\end{tabular}                                & Not released   \\
 Curtsdotter et al., 2011   & Robustness to secondary extinctions: Comparing trait-based sequential deletions in static and dynamic food webs                                        & Simulated food webs (niche model of Williams & Martinez, 2000)                                                                                 & Brose, 2008; Rall et al., 2008                                                             & \begin{tabular}[c]{@{}l@{}}productivity = :system\\ $G_i = 1 - \frac{B_i}{K_{sys}/n_p}$  where,$K_{sys}$ is the system-wide carrying capacity and $n_p$ is the number,of producers in the system.\end{tabular} & Hill exponent (:h) and predator interference (:c) randomly drawn from truncated normal distributions.$\omega_{i,j} = 0.5$                                                                           & Not released   \\
 Stouffer & Bascompte, 2011 & Compartmentalization increases food-web persistence                                                                                                    & Simulated food webs (niche model of Williams & Martinez, 2000) and natural food webs                                                           & Yodzis & Ines, 1992                                                                        & productivity =:species                                                                                                                                                                                         & Type II (:h = 1, :c = 0)                                                                                                                                                                            & Not released   \\
 Kéfi et al., 2016          & How Structured Is the Entangled Bank? TheSurprisingly Simple Organization of MultiplexEcological Networks Leads to IncreasedPersistence and Resilience & Natural food web + randomization                                                                                                               & Brose, 2008; Yodzis & Ines 1992                                                            & \begin{tabular}[c]{@{}l@{}}productivity = :competitive \\ (see Kéfi et al., 2016 for more details)\end{tabular}                                                                                                & \begin{tabular}[c]{@{}l@{}}$\omega_{i,j} = 1/n_i$ where $n_i$ is j's,number of resources\\ Type III (see Kéfi et al., 2016 for more details)\end{tabular}                                           & Not released   \\
 Iles & Novak, 2016         & Complexity Increases Predictability in AllometricallyConstrained Food Webs                                                                             & Simulated food webs (niche model of Williams & Martinez, 2000)                                                                                 & Williams & Martinez, 2004                                                                  & productivity = :system                                                                                                                                                                                         & \begin{tabular}[c]{@{}l@{}}Saturating Type III–like functional response :h = 3\\ $\omega_{i,j} = 1/n_i$ where $n_i$ is j's,number of resources\end{tabular}                                         & Not released  
 \end{tabular}
 \end{table}

 >  It did strike me as strange that the paper has 5 authors from different
 institutions, but the julia code seems to be written exclusively by the
 last author. At least the local git (non-github) repository has 100% of
 commits from the last author, so e.g. the first author appears to never
 have contributed to the application code. I am sure there is a good
 explanation for this, it just appears odd at first glance, so perhaps a
 clear author contributions statement would be useful.

Authors ED and TP contributed most of the code, which is based on
a preliminary C version by DG, and was modified during discussions with
UB and DBS. The github version is a mirror of our in-house git server.
Due to the way we handle merging branches and pushing to the mirror,
changes were attributed to TP regardless of who committed them. We will
now move the package entirely to github to ensure proper attribution
tracking.

> I have a number of minor suggestions for impovement, in no particular order:

> 1. The package is called ’befmw’, perhaps following a common R
 convention of having short abbreviations for package names. The julia
 metadata maintainers prefer long readable package names, such as
 ”BioEnergeticFoodwebs.jl” (so do I). It would be useful to make sure that
 the package is tagged in METADATA before publication, so that any name
 change suggestions from the julia package maintainers can be reflected in
 the application note.

 We do agree with this suggestion -- during the revisions, we tagged the
 package into METADATA and changed its name to `BioEnergeticFoodwebs`.

 > 2. The author response now highlights an online wiki documentation,
 but that isn’t mentioned in the MS as far as I can see – I think it should
 be highlighted clearly.

TODO

> 3. The documentation mentions that many linux distros have a julia
 package, but that is not the recommended way to install julia on linux –
 installation should be via tarball from julialang.org.

We agree that the recommended way to install anything is indeed to use the
sources from the website -- though an overwhelming majority of users, ourselves
included, tend to use the packages from their distributions. Because we test on
the current, past, and future version of Julia, we are confident that all
versions that are 'out there' will be able to work with our package.

> 4. I don’t think the function name ’nichemodel’ is ideal, as that term
 is used for many different things in ecology.

 We agree that the term *niche* is widely used in ecology but we also argue that
 the particular term *niche model* is well accepted in food web ecology and, as
 it  can be seen in table \ref{listpapers}, is widely used to describe the model
 we implemented under the name `nichemodel`. We think that it is a clear
 reference to Williams and Martinez (2000) niche model.

>  5. Line 71: ”is an important effort” - ”is important”.

We thank the reviewer for this suggestion, we corrected the manuscript
accordingly.

> 6. The sentence line 61-63 is unclear.

*Simulation-based studies are more at risk than analytical-based ones, since
the computational aspect is an additional layer of complexity on the
mathematical one.*

Je vois pas comment on peut clarifier plus ...

> 7. Line 89: ”independant” - ”independent”

Corrected.

> 8. Line 127 mentions ’vertebrates’ and Fig 1. mentions ’ectotherms’,
 but it is not clear from the preceding presentation of the model what the
 effect of incorporating these factors is.

 We thank the reviewer for pointing out to this inconsistency (here,
 *vertebrate* refers to *ectotherm vertebrates* only), we have clarified  the
 effect of changing this parameter as well as corrected the term used both in
 the manuscript and the code.

> 9. It is not clear why the code snippet in line 214 needs to include
 trophic rank.

 `vert = round(Bool,trophic_rank(A).>1.0)`

This line of code create a vector determining whether the organism $i$ is an
ectotherm vertebrate (`vert[i] = 1`) or not (`vert[i] = 0`). The inclusion of
the trophik rank is not necessary for the computation of the biomass dynamics,
as this parameter is not used for producer (`trophic_rank = 1`), but it would be
ecologically incorrect to have primary producers being vertebrate, that is why
we have chosen to precise this argument.

 > 10. Fig. 2 caption: ”sahded” - ”shaded”

Corrected.

## Reviewer 2

>  This Application Note presents a new implementation of a popular
 bioenergetic model of food web dynamics, aiming to replace the
 idiosyncratic models implemented by numerous authors with an easy-to-use
 standard.

 > I have downloaded Julia and the befwm package, and tried some of the
 functionality presented in the manuscript and on the authors' website.
 There were a few minor inconsistencies (the arguments do not always seem to
 match between the code in the manuscript and in the tutorial), though some
 of this may be my lack of familiarity with the language, and the natural
 process of working through the development of a package in a rapidly
 evolving language. Otherwise I found the functions intuitive and the
 structure of the objects well-suited to the goals.

 > While there is little new in this manuscript in terms of methods
 development, I expect that the availability of a standard and reliable
 implementation of the Yodzis & Innes model and its descendants will be of
 interest to a good number of food web ecologists. The model itself is
 well-documented in the manuscript, and the functions are outlined well in
 the tutorials. This will be especially important given that Julia is likely
 to be new to the majority of end-users, though its performance and
 simplicity seem likely to grow its popularity over time, and some of the
 R-Julia interfaces may help people wanting to continue to work in the R
 environment (though I have not tried these yet). I could also see this
 turning into a useful teaching tool at multiple levels.

 > I have only a few relatively minor comments:

 > 1. the measure referred to as foodweb_diversity (P8 L159) is identical to the
 evenness component (J') of the Shannon H' index, is it not? The explanation
 is a bit convoluted for something that should be familiar to ecologists,
 and ideally the function would have been called foodweb_evenness or
 something, as the diversity index itself may also be of interest to users.

> 2. in IV.i and figure 1, I suggest using outcome-neutral terminology in place
 of "conditions of coexistence[or competitive exclusion]", because
 coexistence [or not] is an outcome that may depend on the food web context.
 Perhaps phrase in terms of interspecific competition being greater than,
 equal to, or less than intraspecific competition?

 > 3. in the code for section IV.ii (p11-12) it appears that there is a missing
 loop - scaling and the counter 'i' are not defined anywhere.

 > 4. the 'species_persistence' function is not documented as far as I can see,
 and it's not working on the output of a simulation for me. I would suggest
 using the function instead of manually dividing by the initial richness in
 the code in IV.iii, as it will be less likely to lead to errors if adapted
 to other simulations (e.g. that vary starting richness).

 > 5. there are a handful of typos throughout the manuscript, and some of the
 references are formatted inconsistently.
