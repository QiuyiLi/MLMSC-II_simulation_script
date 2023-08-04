import sys,  getopt
import os
import numpy as np
import ete3
import random
from optparse import OptionParser



t = ''
n = '20'
r = '5000'
d = ''
l = ''
c = '1'
i = 'ASTRAL'

try:
      opts, args = getopt.getopt(sys.argv[1:],"h:t:n:r:d:l:c:i:")

except getopt.GetoptError:
      print ('Option not recognized')
      print ('script_astral_simphy.py -t <inputfile> -n <number of gene trees (default 1)> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> -i <inference method (default ASTRAL)> ')
      sys.exit(2)
 
    
for opt, arg in opts:
      if opt == '-h':
         print ('script_astral_simphy.py -t <species tree file> -n <number of gene trees (default 1)> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> -i <inference method (default ASTRAL)> ')
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
      print ('script_astral_simphy.py -t <species tree file> -n <number of gene trees (default 1)> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> -i <inference method (default ASTRAL)>')
      sys.exit(2)
     
if (len(d)==0):
      print ('Please provide a duplication rate')
      print ('script_astral_simphy.py -t <species tree file> -n <number of gene trees (default 1)> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> -i <inference method (default ASTRAL)>')
      sys.exit(2)
     
if (len(l)==0):
      print ('Please provide a loss rate')
      print ('script_astral_simphy.py -t <species tree file> -n <number of gene trees (default 20)> -r <number of resampling (default 5000)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> -i <inference method (default ASTRAL)> ')
      sys.exit(2)
     
if (i=="ASTRAL"):
    inference_method = "random"
elif (i=="ASTRAL-Pro"):
    inference_method = "gene"
else :
    print ('Error, options accepted for -i are ASTRAL/ASTRAL-Pro')
    sys.exit(2)              
        
print ('The species tree file is', t)
print ('The number of gene trees to use in the reconstruction  is', n)
print ('The number of resampling is', r)  
print ('The duplication rate is', d)
print ('The loss rate is', l)
print ('The effective population size multiplier is', c)
print ('The inference method is', i)


sim_method='simphy'
args_sim = 'D' + str(d) +  'L' + str(l) +  'C' + str(c) 
n_gtree=int(n) 


full_name = 'simphy_' + str(args_sim) + '_G' + str(n_gtree) + "_" + inference_method
summary_name = sim_method + '_' + args_sim + '_' + str(n_gtree) + '_' + inference_method

f = open(str(t), 'r')
tree = f.read()
f.close()

astral_bin = '../ASTER/bin/astral-pro'


isExist = os.path.exists('./astral_output/')
if not isExist:
   os.makedirs('./astral_output/')
   
isExist = os.path.exists('./astral_summary/')
if not isExist:
   os.makedirs('./astral_summary/')
   
isExist = os.path.exists('./astral_log/')
if not isExist:
   os.makedirs('./astral_log/')

isExist = os.path.exists('./astral_input/')
if not isExist:
   os.makedirs('./astral_input/')


output_file = './astral_output/' + full_name + '.newick'
summary_file = './astral_summary/' + full_name + '.txt'
astral_log_dir = './astral_log/' + full_name + '.txt'


files = os.listdir('./astral_summary')
if summary_name + '.txt' not in files:
    f = open(summary_file, 'w')
    # f.write('rf\n')
    f.write('rf,total_quartet,correct_quartet,correct_prop\n')
    f.close()

species_tree = ete3.Tree(tree)

all_trees_dir = './output/' + inference_method + '_tree_' + args_sim + '.newick'

f = open(all_trees_dir, 'r')
all_trees = f.readlines()
f.close()

# amount = int(len(all_trees)/10)
amount = int(len(all_trees))
# i=(part-1)*amount
# while i <= part*amount:
#     pack = all_trees[i:i+n_gtree]
#     i = i + n_gtree
count = 1
while count <= int(r):
    count += 1
    string = ''
    pack = random.sample(all_trees, n_gtree)
    for e in pack:
        string += e
    astral_input_file = './astral_input/' + full_name + '.newick'
    f = open(astral_input_file, 'w')
    f.write(string)
    f.close()
    
    astral_command = astral_bin + ' -i ' + astral_input_file + ' -o ' + output_file + ' 2> ' + astral_log_dir
    
    os.system(astral_command)

    f = open(output_file, 'r')
    inferred_tree = f.read()
    f.close()
    inferred_tree_ete3 = ete3.Tree(inferred_tree)
    root_name = inferred_tree_ete3.get_leaf_names()[0]
    inferred_tree_ete3.set_outgroup(root_name)
    species_tree.set_outgroup(root_name)

    rf = species_tree.robinson_foulds(inferred_tree_ete3)[0]

    astral_command = astral_bin + ' -C -u 2 -c ' + t  + ' -i ' + astral_input_file + ' -o ' + output_file + ' 2> ' + astral_log_dir
    os.system(astral_command)

    g = open(astral_log_dir, 'r')
    lines = g.readlines()
    for line in lines:
    	
        if line[0:len('#EqQuartets:')] == '#EqQuartets:':
            total_quartet = int(line.split(': ')[-1])
        elif line[0:len('Score')] == 'Score':
            correct_quartet = int(line.split(': ')[-1])


    correct_prop = float(correct_quartet/total_quartet)
    
    f = open(summary_file,'a')
    # f.write(str(rf) + '\n')
    f.write(str(rf) + ',' + str(total_quartet/n_gtree) + ',' + str(correct_quartet/n_gtree) + ',' + str(correct_prop) + '\n')
    f.close()

print("done.")

