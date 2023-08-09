# Data analysis in R
 
We provide the scripts to reproduce the simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. Here we only give the example of the species tree of 16 fungal genomes i.e., the result presented in the main text of the paper. Minor changes to the python scripts is required to reproduce the examples of primate species tree, or the artificial species tree with extremely short internal branches. 

It is highly recommended to open these R scripts in Rstudio and follow the comment to run each sections on users demand.

## Dependencies 
The R scripts require the following packages
```
readr
ape
ggplot2
treeCentrality
```
To install, do
```
install.packages("readr")
install.packages("ape")
install.packages("ggplot2")
install.packages("remotes")
remotes::install_github("Leonardini/treeCentrality")
```

## basic_summary_statistics.R
Plot basic summary statistics including 
* n_d: number of surviving duplications.
* n_genes: number of genes i.e., tips of genes tree.
* n_species: number of species.

## summary_astral_gene.R
Plot summary statistics of ASTRAL-Pro output.
* rf: Robinson–Foulds distance.
* n_quartets: Number of species-driven quartets (per gene tree).
* cp: Proportion of species-driven quartets which are consistent with the species tree.

## summary_astral_random.R
Plot summary statistics of ASTRAL output.
* rf: Robinson–Foulds distance.
* n_quartets: Number of quartets (per random tree).
* cp: Proportion of quartets which are consistent with the species tree.

## colless_index.R
Compute and plot Colless index.
