import sys
import os
import numpy as np
import ete3
import random
from optparse import OptionParser


def readCommand(argv):
    usageStr = ''
    parser = OptionParser(usageStr, add_help_option=False)
    parser.add_option(
        '-n', '--name', dest='name')
    options, otherjunk = parser.parse_args(argv)
    if len(otherjunk) != 0:
        raise Exception('Command line input not understood: ' + str(otherjunk))
    name = options.name
    return name

# full_name = mlmsc_D1L1C9_G20_gene, mlmsc_D1L1C9_G50_random

full_name = readCommand(sys.argv[1:]) 
method, args, n_gtree, tree_type = full_name.split('_')

summary_name = method + '_' + args + '_' + n_gtree + '_' + tree_type
n_gtree = int(n_gtree[1:])

f = open('./species_trees/fungi.newick', 'r')
fungi_tree = f.read()
f.close()
# fungi_tree = '(((((((A:7.061760,B:7.061760):4.999680,C:12.061440):5.970600,D:18.032040):52.682400,E:70.714260):7.220700,F:77.934960):23.181480,((G:78.553260,H:78.553260):10.434960,I:88.988220):12.128400):78.883560,(((J:41.275620,K:41.275980):29.632860,(L:52.323120,M:52.323120):18.585720):31.149540,((N:75.615840,O:75.615840):14.006880,P:89.622720):12.435660):77.941620);'

astral_dir = './astral_pro/ASTRAL-MP/astral.1.1.3.jar'
output_dir = './astral_output/' + full_name + '.newick'
summary_dir = './astral_summary_fungi/' + summary_name + '.txt'
astral_log_dir = './astral_log/' + full_name + '.txt'

files = os.listdir('./astral_summary_fungi')
if summary_name + '.txt' not in files:
    f = open(summary_dir, 'w')
    # f.write('rf\n')
    f.write('rf,total_quartet,correct_quartet,correct_prop\n')
    f.close()

species_tree = ete3.Tree(fungi_tree)

all_trees_dir = './output/' + tree_type + '_tree_' + args + '.newick'

f = open(all_trees_dir, 'r')
all_trees = f.readlines()
f.close()

# amount = int(len(all_trees)/10)
amount = int(len(all_trees))
# i=(part-1)*amount
# while i <= part*amount:
#     pack = all_trees[i:i+n_gtree]
#     i = i + n_gtree
count = 0
while count <= 5000:
    count += 1
    string = ''
    pack = random.sample(all_trees, n_gtree)
    for e in pack:
        string += e
    astral_input_dir = './astral_input/' + full_name + '.newick'
    f = open(astral_input_dir, 'w')
    f.write(string)
    f.close()
    
    astral_command = 'java -Djava.library.path=./astral_pro/ASTRAL-MP/lib -jar ' + astral_dir + ' -i ' + astral_input_dir + ' -o ' + output_dir + ' 2> ' + astral_log_dir
    
    os.system(astral_command)

    f = open(output_dir, 'r')
    inferred_tree = f.read()
    f.close()
    inferred_tree_ete3 = ete3.Tree(inferred_tree)
    root_name = inferred_tree_ete3.get_leaf_names()[0]
    inferred_tree_ete3.set_outgroup(root_name)
    species_tree.set_outgroup(root_name)

    rf = species_tree.robinson_foulds(inferred_tree_ete3)[0]

    astral_command = 'java -Djava.library.path=./astral_pro/ASTRAL-MP/lib -jar ' + astral_dir + ' -q ./species_trees/fungi.newick' + ' -i ' + astral_input_dir + ' -o ' + output_dir + ' 2> ' + astral_log_dir
    os.system(astral_command)

    g = open(astral_log_dir, 'r')
    lines = g.readlines()
    for line in lines:
        if line[0:len('Number of quartet')] == 'Number of quartet':
            total_quartet = int(line.split(': ')[-1])
        elif line[0:len('Final quartet score')] == 'Final quartet score':
            correct_quartet = int(line.split(': ')[-1])
        elif line[0:len('Final normalized quartet')] == 'Final normalized quartet':
            correct_prop = float(line.split(': ')[-1])
    g.close()

    f = open(summary_dir,'a')
    # f.write(str(rf) + '\n')
    f.write(str(rf) + ',' + str(total_quartet/n_gtree) + ',' + str(correct_quartet/n_gtree) + ',' + str(correct_prop) + '\n')
    f.close()



