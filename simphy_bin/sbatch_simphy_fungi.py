import os

# r_d = 1,2,3,4,5,6
multi_r = [1,2,3,4,5,6]

# k = r_l/r_d = 0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2
multi_k = [0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2] 

# coal_unit = 1, 9, 18
multi_c = [1, 9, 18]

names = ['N100000D0L0C1', 'N100000D0L0C9', 'N100000D0L0C18'] 
for r in multi_r:
	for k in multi_k:
		for c in multi_c:
			name = 'N100000D' + str(r) + 'L' + str(r*k) + 'C' + str(c)
			names.append(name)

for name in names:
	# this can be replaced by sbatch command to submit jobs on clusters
	os.system("python3 script_simphy_fungi.py -n " + name)
