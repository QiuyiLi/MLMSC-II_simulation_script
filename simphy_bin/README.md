# SimPhy simulation

We provide the scripts to reproduce the SimPhy simulation results of the paper **The effect of copy number hemiplasy on gene family evolution**. 

To install SimPhy, do 
```
git clone https://github.com/adamallo/SimPhy 
```
and follow the instructions, or download the binay file [here](https://github.com/adamallo/SimPhy/releases/download/v1.0.2/SimPhy_1.0.2.tar.gz).
The scripts expect the SimPhy binary to be in **./SimPhy/bin/simphy**

Note that the branch lengths of the species tree used for the mlmsc simulations have to be multiplied by 1e7 to obtain the species tree for the SimPhy simulations.

In its original form, SimPhy does not allow duplication rate (r_d) to be less than loss rate (r_l). Fortunately, the source code can be easily modified to accept r_d > r_l: go to **SimPhy/src/main.c**; comment the following lines (3680~3685)
```
if((get_sampling(sb_rate)<get_sampling(sd_rate))&&(get_sampling(bds_leaves)>0))
{
    fprintf(stderr,"\n\tERROR!!! The BDSA algorithm of the conditioned birth death simulation process of the species tree does not allow birth rates less than the death rate\n");
    
    is_error=1;
}
```
Then follow the instructions to recompile SimPhy, the recomplied SimPhy binary is expected to be in **./SimPhy/bin/simphy**

## script_simphy.py
This script takes as input the species tree, the number of gene trees, the duplication rate, the loss rate, the effective population size multiplier, and produces a SimPhy simulation. To execute
```
python3 script_simphy.py -t <species tree file> -n <number of gene trees> -d <duplication rate> -l <loss rate> -c <effective population size multiplier> 

```
Note that 

* -d D will corresponds to a duplication rate of De-3 per coalescent unit.
* -l L will corresponds to a loss rate of Le-3 per coalescent unit.
* -c C will multiply the effective population size  of all branches by C.

## sbatch_simphy.py
This script lists all sets of parameters used to generate the SimPhy gene trees in our simulations.

## script_astral_simphy.py

This script takes as input the species tree, the number of SimPhy gene trees to use in the inference, the duplication rate, the loss rate, the effective population size multiplier and the inference method, and produces the output of ASTRAL/ASTRAL-Pro. 
To execute
```
python3 script_astral_simphy.py -t <species tree file> -n <number of gene trees> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier> -i <inference method (ASTRAL/ASTRAL-Pro)>

```

Note that this script will look for the corresponding trees simulated via the script_simphy.py script in the directory ./output/ and will randomly select <number of gene trees>  gene trees to infer a species tree with ASTRAL or ASTRAL-Pro, and will do so for <number of resampling> times.

## sbatch_astral_simphy.py

This script lists all sets of parameters used to reconstruct species trees from the SimPhy simulations.
