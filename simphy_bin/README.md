# Simphy simulation

We provide the scripts to reproduce the simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. Here we only give the example of the species tree of 16 fungal genomes i.e., the result presented in the main text of the paper. Minor changes to the python scripts is required to reproduce the examples of primate species tree, or the artificial species tree with extremely short internal branches. 

## process_simphy_fungi.py
This script processes the origial output of Simphy and makes the output format consistent with the output of MLMSC-II. 

* gene_tree.newick: a multi-labelled gene tree consisting of all homologous genes.
* random_tree.newick: a single-labelled gene tree in which only one gene is randomly selected for each descendant species.
* summary.txt: summary statistics including the number of surviving duplications (n_d), number of genes (n_genes), and number of species (n_species).

The script has been integrated to **script_simphy_fungi.py**, and do not need to be executed on its own. 

## script_simphy_fungi.py
This script takes input the number of gene trees, duplication rate, loss rate, the effective population size and produces the output of Simphy. To execute
```
python3 script_simphy_fungi.py -n N100D2L2C9
```
or
```
python3 script_simphy_fungi.py --name N100D2L2C9
```
the arguments 
* N100: simulate 100 gene trees.
* D2: duplication rate = 2e-3 per coalescent unit.
* L2: loss rate = 2e-3 per coalescent unit.
* C9: the effective population size = 9e7.

## sbatch_simphy_fungi.py
This script is for submitting jobs on clusters and lists all sets of parameters used in our simuation.

## script_astral_simphy_fungi.py
This script takes input the duplication rate, loss rate, the effective population size and produces the output of ASTRAL/ASTRAL-Pro. To execute
```
python3 script_astral_simphy_fungi.py -n simphy_D2L2C9_G20_gene
```
or
```
python3 script_astral_simphy_fungi.py --name simphy_D2L2C9_G20_gene
```
the arguments 
* D2: duplication rate = 2e-3 per coalescent unit.
* L2: loss rate = 2e-3 per coalescent unit.
* C9: the effective population size = 9e7.
* G20: species tree inference using 20 gene trees.
* gene/random: use gene/random trees as input (ASTRAL-Pro/ASTRAL).

## sbatch_astral_simphy_fungi.py
This script is for submitting jobs on clusters and lists all sets of parameters used in our simuation. 


