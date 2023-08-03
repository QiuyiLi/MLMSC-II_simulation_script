# MLMSC-II_simulation_script
 
We provide the scripts to reproduce the simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. Here we only give the example of the species tree of 16 fungal genomes i.e., the result presented in the main text of the paper. Minor changes to the python scripts is required to reproduce the examples of primate species tree, or the artificial species tree with extremely short internal branches. 

## mlmsc_bin
This directory is for simulating gene trees using MLMSC-II, and performing species tree inference (by ASTRAL and ASTRAL-Pro) on the simulated gene tree.

Simulated gene trees are stored in **mlmsc_bin/output**:
* **gene_tree.newick**: a multi-labelled gene tree consisting of all homologous genes
* **random_tree.newick**: a single-labelled gene tree in which only one gene is randomly selected for each descendant species 
* **summary.txt**: summary statistics including the number of surviving duplications (n_d), number of genes (n_genes), and number of species (n_species)

Species tree inference results are stored in **mlmsc_bin/astral_summary_fungi**:
* **mlmsc_random.txt**: ASTRAL results
* **mlmsc_gene.txt**: ASTRAL-Pro results

For more information, please refer to **mlmsc_bin/README.md**.

## simphy_bin
This directory is for simulating gene trees using SimPhy, and performing species tree inference (by ASTRAL and ASTRAL-Pro) on the simulated gene tree.

Simulated gene trees are stored in **simphy_bin/output**:
* **gene_tree.newick**: a multi-labelled gene tree consisting of all homologous genes
* **random_tree.newick**: a single-labelled gene tree in which only one gene is randomly selected for each descendant species 
* **summary.txt**: summary statistics including the number of surviving duplications (n_d), number of genes (n_genes), and number of species (n_species)

Species tree inference results are stored in **simphy_bin/astral_summary_fungi**:
* **simphy_random.txt**: ASTRAL results
* **simphy_gene.txt**: ASTRAL-Pro results

For more information, please refer to **simphy_bin/README.md**.

## WFDL_bin
This directory is for simulating the fraction of higher order duplications using the WFDL model.

For more information, please refer to **WFDL_bin/README.md**.

## data_analysis
This directory stores all simulation results and R scripts for data analysis and plots.

The simulated gene trees are stored in the following directories:
* **data_analysis/mlmsc_tree**: gene trees simulated using MLMSC-II
* **data_analysis/symphy_tree**: gene trees simulated using SimPhy
  
Note that we only keep 1000 gene trees for each set of parameters for demonstration, but 100000 gene trees are used in the original simulation.

The bacis summary statistics of the simulated gene trees (e.g., n_dups, n_genes, n_species) are stored in the following directories:
* **data_analysis/mlmsc_summary**: bacis summary statistics of the gene trees simulated using MLMSC-II
* **data_analysis/symphy_summary**: bacis summary statistics of the gene trees simulated using SimPhy

The results of species tree inference are stored in the following directories:
* **data_analysis/astral_mlmsc**: results of species tree inference using gene trees simulated using MLMSC-II
* **data_analysis/astral_symphy**: results of species tree inference using gene trees simulated using SimPhy

For more information, please refer to **data_analysis/README.md**.
