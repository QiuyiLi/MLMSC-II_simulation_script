# MLMSC-II simulation

We provide the scripts to reproduce the MLMSC-II simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. 


## script_mlmsc.py
This script takes as input the species tree, the number of gene trees, the duplication rate, the loss rate, the effective population size multiplier, and produces a MLMSC-II simulation. To execute
```
python3 script_mlmsc.py -t <species tree file> -n <number of gene trees> -d <duplication rate> -l <loss rate> -c <effective population size multiplier> 

```
Note that 

* -d D will corresponds to a duplication rate of De-3 per coalescent unit.
* -l L will corresponds to a loss rate of Le-3 per coalescent unit.
* -c C will multiply the effective population size  of all branches by C.

## sbatch_mlmsc.py
This script lists all sets of parameters used to generate the MLMSC-II gene trees in our simulations.

## script_astral_mlmsc.py

This script takes as input the species tree, the number of MLMSC-II gene trees to use in the inference, the duplication rate, the loss rate, the effective population size multiplier and the inference method, and produces the output of ASTRAL/ASTRAL-Pro. 
To execute
```
python3 script_astral_mlmsc.py -t <species tree file> -n <number of gene trees> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier> -i <inference method (ASTRAL/ASTRAL-Pro)>

```

Note that this script will look for the corresponding trees simulated via the script_mlmsc.py script in the directory ./output/ and will randomly select <number of gene trees>  gene trees to infer a species tree with ASTRAL or ASTRAL-Pro, and will do so for <number of resampling> times.

## sbatch_astral_mlmsc.py

This script lists all sets of parameters used to reconstruct species trees from the MLMSC-II simulations.
