# process original simphy output
# put in the same directory of simphy

import sys
import os
import numpy as np
from six import StringIO
from skbio import TreeNode
from collections import defaultdict
from optparse import OptionParser

def readCommand(argv):
	usageStr = ''
	parser = OptionParser(usageStr, add_help_option=False)

	parser.add_option(
		'-n', '--name', dest='name')

	options, otherjunk = parser.parse_args(argv)

	if len(otherjunk) != 0:
		raise Exception('Command line input not understood: ' + str(otherjunk))

	args = options.name
    
	return args

fullargs = readCommand(sys.argv[1:]) 
n = int(fullargs.split('N')[1].split('D')[0])
d = float(fullargs.split('D')[1].split('L')[0])
l = float(fullargs.split('L')[1].split('C')[0])
c = float(fullargs.split('C')[1])

args = fullargs
paras = 'D' + args.split('D')[1]

part = 1
direction = 'fungi_' + args + '/' + str(part) + '/'

f = open('./species_trees/fungi.newick','r')
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