# MLMSC-II_simulation_script
 
We provide here the scripts to reproduce the simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. 


To install ASTER/ASTRAL-Pro, do 
```git clone https://github.com/chaoszhang/ASTER.git
```
and follow the instructions. The scripts expect the ASTRAL/ASTRAL-Pro binary to be in **./ASTER/bin/astral-pro**


## mlmsc_bin
This directory contains all the scripts for simulating gene trees using MLMSC-II and SimPhy, and performing species tree inference (by ASTRAL and ASTRAL-Pro) on the simulated gene trees.

When simulating trees, gene trees are stored in **mlmsc_bin/output**:
* **gene_tree.newick**: a list of multi-labelled gene trees, each containing of all simulated homologous genes
* **random_tree.newick**: a list of single-labelled gene trees, each containing only one --randomly-chosen-- gene per species 
* **summary.txt**: summary statistics including the number of surviving duplications (n_d), number of genes (n_genes), and number of species (n_species)

When inferring specie trees, species tree inference results are stored in **mlmsc_bin/astral_summary_fungi**:
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
