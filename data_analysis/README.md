# Data analysis in R
 
We provide the scripts to reproduce the simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. Here we only give the example of the species tree of 16 fungal genomes i.e., the result presented in the main text of the paper. Minor changes to the python scripts is required to reproduce the examples of primate species tree, or the artificial species tree with extremely short internal branches. 

# basic_summary_statistics.R
Read summary.txt and plot basic summary statistics including 
* n_d: number of surviving duplications.
* n_genes: number of genes i.e., tips of genes tree.
* n_species: number of species.

# summary_astral_gene.R
Plot summary statistics of ASTRAL-Pro output.
* rf: Robinson–Foulds distance.
* n_quartets: Number of species-driven quartets (per gene tree).
* cp: Proportion of species-driven quartets which are consistent with the species tree.

# summary_astral_random.R
Plot summary statistics of ASTRAL output.
* rf: Robinson–Foulds distance.
* n_quartets: Number of quartets (per random tree).
* cp: Proportion of quartets which are consistent with the species tree.

# colless_index.R
Plot Colless index.