# sicksickerPack

## Project folder structure

```
.
├── .gitignore            # Names of files to be ignored by Git
├── .Rbuildignore         # Names of files to be ignored by R-CMD
├── DESCRIPTION           # Package description file
├── LICENSE               # License file
├── LICENSE.md            # License description file
├── man                   # Functions' documentation
|   ├── testtaht.R 
|   ├── testtaht.R 
|   ├── testtaht.R  
|   ├── testtaht.R 
|   ├── testtaht.R 
|   └── testtaht.R
├── NAMESPACE            
├── R                     # Functions' definitions
|   ├── calculate_costs.R
|   ├── calculate_discounting_weights.R 
|   ├── calculate_QALYs.R 
|   ├── create_Markov_trace.R 
|   ├── define_transition_matrix.R  
|   └── run_sickSicker_model.R
├── README.md  
├── sicksickerPack.Rproj 
└── tests                 # Functions' tests
    ├── testtaht.R        # testthat setup script    
    └── testthat          # testthat tests' scripts
        ├── test-calculate_costs.R
        ├── test-calculate_discounting_weights.R
        ├── test-calculate_QALYs.R
        ├── test-create_Markov_trace.R
        ├── test-define_transition_matrix.R
        └── test-run_sickSicker_model.R

```
