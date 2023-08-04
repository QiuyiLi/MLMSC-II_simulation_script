# process original simphy output
# put in the same directory of simphy

import sys, getopt
import os
import numpy as np
from six import StringIO
from skbio import TreeNode
from collections import defaultdict
from optparse import OptionParser


t = ''
n = '20'
d = ''
l = ''
c = '1'

try:
      opts, args = getopt.getopt(sys.argv[1:],"h:t:n:d:l:c:")

except getopt.GetoptError:
      print ('Option not recognized')
      print ('process_simphy.py -t <inputfile> -n <number of gene trees (default 20)> -d <duplication rate> -l <loss rate> -c <effective population size> ')
      sys.exit(2)
 
    
for opt, arg in opts:
      if opt == '-h':
         print ('process_simphy.py -t <species tree file> -n <number of gene trees (default 20)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
         sys.exit()
      elif opt in ("-t"):
         t = arg
      elif opt in ("-n"):
         n = arg
      elif opt in ("-r"):
         r = arg
      elif opt in ("-d"):
         d = arg  
      elif opt in ("-l"):
         l = arg  
      elif opt in ("-c"):
         c = arg
      elif opt in ("-i"):
         i = arg

  
if (len(t)==0):
      print ('Please provide a species tree')
      print ('process_simphy.py -t <species tree file> -n <number of gene trees (default 20)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
     
if (len(d)==0):
      print ('Please provide a duplication rate')
      print ('process_simphy.py -t <species tree file> -n <number of gene trees (default 20)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
     
if (len(l)==0):
      print ('Please provide a loss rate')
      print ('process_simphy.py -t <species tree file> -n <number of gene trees (default 20)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
                
fullargs = 'N' + str(n) +  'D' + str(d) +  'L' + str(l) +  'C' + str(c) 

n = int(n)
d = float(d)
l = float(l)
c = float(c)

paras = 'D' + fullargs.split('D')[1]

part = 1
direction = 'tmp_' + fullargs + '/' + str(part) + '/'

isExist = os.path.exists(direction)

if not isExist:
   os.makedirs(direction)


f = open(str(t),'r')
speciesTreeString = f.read()
speciesTree = TreeNode.read(StringIO(speciesTreeString))

k = 0
out_dir = './output/'

files = os.listdir(out_dir)
if 'gene_tree_' + paras + '.newick' not in files:
	f = open(out_dir + 'gene_tree_' + paras + '.newick', 'w')
	f.write('')
	f.close()
if 'summary_' + paras + '.txt' not in files:
	f = open(out_dir + 'summary_' + paras + '.txt', 'w')
	f.write('n_d,n_genes,n_species\n')
	f.close()
if 'random_tree_' + paras + '.newick' not in files:
	f = open(out_dir + 'random_tree_' + paras + '.newick', 'w')
	f.write('')
	f.close()


files = os.listdir(direction)
for file in files:
	if file[0] == 'g':
		number_d = []
		f = open(direction+file)
		string = f.read()
		newString = ''
		i = 0
		while i < len(string):
			if 65<=ord(string[i])<=90:
				name = ''
				newString += string[i]
				for j in range(i, len(string)):
					if string[j] != ':':
						name += string[j]
						i += 1
					else:
						newString += string[i]
						i += 1
						number = int(name.split('_')[1])
						if number not in number_d:
							number_d.append(number)
						break
			else:
				newString += string[i]
				i += 1
		t = TreeNode.read(StringIO(newString))

		Vec = defaultdict(list)
		for node in speciesTree.tips():
			Vec[node.name] = []
		
		for node in t.tips():
			species_name = node.name
			node.name += str(len(Vec[species_name]) + 1)
			Vec[species_name].append(node.name)
		
		names = []
		# single_names = []
		n_genes = 0

		for key, val in Vec.items():
			if Vec[key]:
				names.append(np.random.choice(Vec[key]))
				n_genes += len(Vec[key])

		if len(names) >= 4:
			f = open(out_dir + 'summary_' + paras + '.txt', 'a')
			f.write(str(len(number_d)-1) + ',' + str(n_genes) + ',' + str(len(names)) + '\n')
			f.close()

			randomTree = t.shear(names)

			for node in randomTree.tips():
				# tipNumber += 1
				node.name = node.name[0]
			for node in t.tips():
				# full_tip_num += 1
				node.name = node.name[0]

			f = open(out_dir + '/gene_tree_' + paras + '.newick', 'a')
			string = str(t)
			for char in string:
				if char == "'":
					continue
				else:
					f.write(char)
			f.close()

			f = open(out_dir + '/random_tree_' + paras + '.newick', 'a')
			string = str(randomTree)
			for char in string:
				if char == "'":
					continue
				else:
					f.write(char)
			f.close()
			k += 1

		if k == n:
			break