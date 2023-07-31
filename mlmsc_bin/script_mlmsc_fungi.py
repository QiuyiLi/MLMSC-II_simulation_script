import sys
import os
import numpy as np

def readCommand(argv):
    from optparse import OptionParser
    usageStr = ''
    parser = OptionParser(usageStr, add_help_option=False)

    parser.add_option(
        '-n', '--name', dest='name')

    options, otherjunk = parser.parse_args(argv)

    if len(otherjunk) != 0:
        raise Exception('Command line input not understood: ' + str(otherjunk))

    args = options.name
    
    return args

args = readCommand(sys.argv[1:]) 

n = int(args.split('N')[1].split('D')[0])
d = float(args.split('D')[1].split('L')[0])
l = float(args.split('L')[1].split('C')[0])
c = float(args.split('C')[1].split('P')[0])

mlmsc_command = 'python3 MLMSC/MLMSC.py -i species_trees/fungi.newick -n ' + str(n) + ' -d ' + str(d*0.001) + ' -l ' + str(l*0.001) + ' -c ' + str(1/c) + ' -u 1'

for i in range(1):
    seed = str(np.random.random())[2:10]
    seed = str(int(seed))
    os.system(mlmsc_command + ' -s ' + seed)

    files = os.listdir('./output/')
    for file_name in files:
        name_l = file_name.split('D')[0]
        name_r = file_name.split('.')[-1]
        r_d = float(file_name.split('D')[1].split('L')[0])
        r_l = float(file_name.split('L')[1].split('C')[0])
        r_c = float(file_name.split('C')[1][:-len(name_r)-1])
        
        if abs(r_d-d*0.001)<10**(-6) and abs(r_l-l*0.001)<10**(-6) and abs(r_c-c)<10**(-6):
            new_name = name_l + 'D' + args.split('D')[1] + '.' + name_r
            os.rename('./output/'+file_name, './output/'+new_name)
print("done.")