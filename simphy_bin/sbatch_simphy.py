import os

species_tree='species_trees/fungi.newick'
multi_r = [1,2,3,4,5,6]
multi_k = [0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2]
multi_c = [1, 9, 18]

for r in multi_r:
	for k in multi_k:
		for c in multi_c:
			# this can be replaced by sbatch command to submit jobs on clusters
			os.system('python3 script_simphy.py -t '+ str(species_tree) +'-n 100000 -d ' + str(r) + '-l '  + str(r*k) + '-c' + str(c)


# this can be replaced by sbatch command to submit jobs on clusters
os.system('python3 script_simphy.py -t '+ str(species_tree) +'-n 100000 -d ' + 0 + '-l '  + 0+ '-c 1' 
os.system('python3 script_simphy.py -t '+ str(species_tree) +'-n 100000 -d ' + 0 + '-l '  + 0+ '-c 9' 
os.system('python3 script_simphy.py -t '+ str(species_tree) +'-n 100000 -d ' + 0 + '-l '  + 0+ '-c 18' 
