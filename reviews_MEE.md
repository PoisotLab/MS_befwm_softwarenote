 # Associate Editor's comments to the Author:

 I have received two reviews for this manuscript; both broadly positive but
 with constructive suggestions that will improve the manuscript. Reviewer 1
 in particular questions how widely this will be used - some expansion of
 section IV would be useful here.

 Much is made of the high performance nature of the code here, but no
 benchmarks are provided and no comparisons with competing approaches are
 provided.  Is this modelling work routinely limited by speed?  And is the
 step change in speed here enough to help this?  Given that most ODE solvers
 find their way into heavily optimised compiled code, it's not immediately
 clear there will be a significant difference.  Some clarification here may
 help justify the statements.

 Also I note that on ODE.jl the README says:

  >Need something long-term reliable right now?
  See the Sundials.jl package, which provides wrappers for the excellent
 Sundials ODE solver library.

 (among other statements of instability).  Is this overstated?

*In part, yes. The instability refers not to the behavior of the code, but
to the API itself, meaning that it may change in future releases.  However,
because we have organized the code so that all calls to ODE.jl go through a
single function, and it will be easy for us to track API changes. In over a
year of working with ODE.jl, we have noted no change in API (and no difference
in performance when using this or Sundials.jl).*

 # Reviewers' Comments to Author:

 ## Reviewer: 1

 **Comments to the Corresponding Author.**
 This is a clearly written Application note, introducing a julia package for
 simulating biomass dynamics in community food webs. I don't know a lot
 about foodwebs and biomass dynamics (I assume I was chosen as a reviewer
 because I am familiar with julia), so I will just remark on the
 presentation and application here. The application appears to do what it
 promises with a reasonably intuitive interface. The documentation looks
 thorough and accessible and the code is clean and appears efficient. There
 isn’t a lot of code as the package draws extensively on existing
 functionality in other julia packages, but that is in accordance with good
 coding practice.

*"We thank the
reviewer for his positive comments; as is the case for most languages
with thriving package ecosystems, we indeed draw on the work of the
community to avoid re-implementation of existing features".*

 At present, though, I don’t think the authors make a compelling case that
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

*Faire une liste / tableau + *

*"In addition, some of the authors have used this model extensively for
teaching. Although this did not result in publications, we believe that
this type of packages is valuable as a teaching tool too."*

 It did strike me as strange that the paper has 5 authors from different
 institutions, but the julia code seems to be written exclusively by the
 last author. At least the local git (non-github) repository has 100% of
 commits from the last author, so e.g. the first author appears to never
 have contributed to the application code. I am sure there is a good
 explanation for this, it just appears odd at first glance, so perhaps a
 clear author contributions statement would be useful.

*"Authors ED and TP contributed most of the code, which is based on
a preliminary C version by DG, and was modified during discussions with
UB and DBS. The github version is a mirror of our in-house git server.
Due to the way we handle merging branches and pushing to the mirror,
changes were attributed to TP regardless of who committed them. We will
now move the package entirely to github to ensure proper attribution
tracking."*

Et on modifiera le papier.

 I have a number of **minor suggestions** for impovement, in no particular order:

 1. The package is called ’befmw’, perhaps following a common R
 convention of having short abbreviations for package names. The julia
 metadata maintainers prefer long readable package names, such as
 ”BioEnergeticFoodwebs.jl” (so do I). It would be useful to make sure that
 the package is tagged in METADATA before publication, so that any name
 change suggestions from the julia package maintainers can be reflected in
 the application note.

 2. The author response now highlights an online wiki documentation,
 but that isn’t mentioned in the MS as far as I can see – I think it should
 be highlighted clearly.

*"We apologize for the oversight and will ..."*

 3. The documentation mentions that many linux distros have a julia
 package, but that is not the recommended way to install julia on linux –
 installation should be via tarball from julialang.org.

*"The recommended way to install anything is indeed to use the sources
from the website -- though an overwhelming majority of users, ourselves
included, tend to use the packages from their distributions. Because we
test on the current, past, and future version of Julia, we are confident
that all versions that are 'out there' will be able to work with our
package.".*

 4. I don’t think the function name ’nichemodel’ is ideal, as that term
 is used for many different things in ecology.

*Well accepted in food web, etc etc*

 5. Line 71: ”is an important effort” - ”is important”.
 6. The sentence line 61-63 is unclear.
 7. Line 89: ”independant” - ”independent”
 8. Line 127 mentions ’vertebrates’ and Fig 1. mentions ’ectotherms’,
 but it is not clear from the preceding presentation of the model what the
 effect of incorporating these factors is.
 9. It is not clear why the code snippet in line 214 needs to include
 trophic rank.
 10. Fig. 2 caption: ”sahded” - ”shaded”

 Michael Krabbe Borregaard


 ## Reviewer: 2

 **Comments to the Corresponding Author.**
 This Application Note presents a new implementation of a popular
 bioenergetic model of food web dynamics, aiming to replace the
 idiosyncratic models implemented by numerous authors with an easy-to-use
 standard.

 I have downloaded Julia and the befwm package, and tried some of the
 functionality presented in the manuscript and on the authors' website.
 There were a few minor inconsistencies (the arguments do not always seem to
 match between the code in the manuscript and in the tutorial), though some
 of this may be my lack of familiarity with the language, and the natural
 process of working through the development of a package in a rapidly
 evolving language. Otherwise I found the functions intuitive and the
 structure of the objects well-suited to the goals.

*"We thank the reviewer for .."*

 While there is little new in this manuscript in terms of methods
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

*"We agree that the model can be useful in teaching; in fact, some of the
motivation to ..."*

 I have only a few relatively **minor comments:**


 1. the measure referred to as foodweb_diversity (P8 L159) is identical to the
 evenness component (J') of the Shannon H' index, is it not? The explanation
 is a bit convoluted for something that should be familiar to ecologists,
 and ideally the function would have been called foodweb_evenness or
 something, as the diversity index itself may also be of interest to users.

 2. in IV.i and figure 1, I suggest using outcome-neutral terminology in place
 of "conditions of coexistence[or competitive exclusion]", because
 coexistence [or not] is an outcome that may depend on the food web context.
 Perhaps phrase in terms of interspecific competition being greater than,
 equal to, or less than intraspecific competition?

 3. in the code for section IV.ii (p11-12) it appears that there is a missing
 loop - scaling and the counter 'i' are not defined anywhere.

 4. the 'species_persistence' function is not documented as far as I can see,
 and it's not working on the output of a simulation for me. I would suggest
 using the function instead of manually dividing by the initial richness in
 the code in IV.iii, as it will be less likely to lead to errors if adapted
 to other simulations (e.g. that vary starting richness).

 5. there are a handful of typos throughout the manuscript, and some of the
 references are formatted inconsistently.
