import os

multi_r = [1,2,3,4,5,6]
multi_k = [0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2]
multi_c = [1, 9, 18]

names = ['simphy_D0L0C1_G20_gene', 'simphy_D0L0C9_G20_gene', 'simphy_D0L0C18_G20_gene', 'simphy_D0L0C1_G20_random', 'simphy_D0L0C9_G20_random', 'simphy_D0L0C18_G20_random'] 
# names = []
for r in multi_r:
	for k in multi_k:
		for c in multi_c:
			name1 = 'simphy_D' + str(r) + 'L' + str(r*k) + 'C' + str(c) + '_G20_gene'
			names.append(name1)
			name2 = 'simphy_D' + str(r) + 'L' + str(r*k) + 'C' + str(c) + '_G20_random'
			names.append(name2)

for name in names:
	# this can be replaced by sbatch command to submit jobs on clusters
	os.system("python3 script_astral_simphy_fungi.py -n " + name)