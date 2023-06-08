# sicksickerPack

This repository houses the case study R package `sicksickerPack` described in a working paper:

> Smith RA, Mohammed W. and Schneider PP. Packaging cost-effectiveness models in R: A tutorial. [GoogleDoc](https://docs.google.com/document/d/16SXEaW413aQy_xel04MwTUwYlAR4voq4/edit)

# **Packaging cost-effectiveness models in R: A tutorial**

[Robert Smith](https://www.linkedin.com/in/robert-smith-53b28438)<sup>1,2</sup>, Wael Mohammed<sup>1,2</sup> & Paul Schneider<sup>1,2</sup>

<sup>1</sup> [University of Sheffield](https://www.sheffield.ac.uk/scharr), University of Sheffield, Sheffield, UK   
<sup>2</sup> [Dark Peak Analytics](https://darkpeakanalytics.com/), Sheffield, UK

>#### **Background**
>
>The use of programming languages such as R in health economics and decision science is increasing, and brings numerous benefits including increas- ing model development efficiency, improving transparency, and reducing human error. However, there is limited guidance on how to best develop models using R. So far, no clear consensus has emerged.
>
>#### **Methods**
>
>We present the advantages of creating health economic models as R packages - structured collections of functions, data sets, tests, and documentation. Assuming an intermediate understanding of R, we provide a tutorial to demonstrate how to construct a basic R package for health economic evaluation. All source code used in or referenced by this paper is available under an open source licence.
>
>#### **Results**
>
>We use the Sick Sicker Model as a case study applying the steps from the tutorial to standardise model development, documentation and aid review. This can improve the distribution of code, thereby streamlining model development, and improve methods in health economic evaluation.
>
>#### **Conclusions**
>
>R Packages offer a valuable framework for enhancing the quality and transparency of health economic evaluation models. Embracing better, more standardised software development practices, while fostering a collaborative culture, has the potential to significantly improve the quality of health economic models, and, ultimately, support better decision making in healthcare.

## Installation

To test the functionality of this package, install the development version of the package using the devtools package.

``` r
devtools::install_github("dark-peak-analytics/sicksickerPack")
```

## Quick start

### Load the package.

``` r
library(sicksickerPack)
```

### Deterministic Model 

Run the deterministic sick-sicker model with the dummy parameters.

``` r
run_sickSicker_model(
  params_ = dummy_sickSickerModel_params
)
```

### Probabilistic Model 

Run the probabilistic sick-sicker model with the dummy PSA parameters.

``` r
run_psa(
  model_func_ = sicksickerPack::run_sickSicker_model,
  model_func_args_ = list(
    age_init_ = 25,
    age_max_  = 55,
    discount_rate_ = 0.035
  ),
  psa_params_names_ = dummy_sickSickerModel_psa_params$
    psa_params_names,
  psa_params_dists_ = dummy_sickSickerModel_psa_params$
    psa_params_dists,
  psa_params_dists_args_ = dummy_sickSickerModel_psa_params$
    psa_params_dists_args,
  n_sim_ = 100
)
```
## Project folder structure

The project follows a typical R package structure as below

```
.
├── .gitignore            # Names of files to be ignored by Git
├── .Rbuildignore         # Names of files to be ignored by R-CMD
├── data/                 # Package data files
├── data-raw/             # Package data-construction files
├── DESCRIPTION           # Package description file
├── inst/                 # Package post-installation deployed files
├── LICENSE               # License file
├── LICENSE.md            # License description file
├── man/                  # Functions' documentation
├── NAMESPACE            
├── R/                    # Functions' definitions
├── README.md  
├── sicksickerPack.Rproj 
└── tests                 # Functions' tests
    ├── testtaht.R        # testthat setup script    
    └── testthat/         # testthat tests' scripts
```


## Funding
Rob, Wael & Paul were joint funded by the Wellcome Trust Doctoral Training Centre in Public Health Economics and Decision Science [108903] and the University of Sheffield. They now all work for [Dark Peak Analytics](https://www.darkpeakanalytics.com). Please contact <rasmith3@sheffield.ac.uk> with any queries.
