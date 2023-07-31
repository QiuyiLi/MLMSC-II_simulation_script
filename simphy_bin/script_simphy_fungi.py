# put this script in the same directory of simphy
# this script produces and summarise the gene trees simulated by simphy

import sys
import os
import numpy as np
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

fullName = readCommand(sys.argv[1:]) 

n = int(fullName.split('N')[1].split('D')[0])
d = float(fullName.split('D')[1].split('L')[0])
l = float(fullName.split('L')[1].split('C')[0])
c = float(fullName.split('C')[1])

fungi_tree = "'(((((((A:70617600.0,B:70617600.0):49996800.0,C:120614400.0):59706000.0,D:180320400.0):526823100.0,E:707143500.0):72206550.0,F:779350050.0):231815475.0,((G:785532600.0,H:785532600.0):104349600.0,I:889882200.0):121283325.0):788834812.5,(((J:412758000.0,K:412758000.0):296329500.0,(L:523231200.0,M:523231200.0):185856300.0):311495850.0,((N:756158400.0,O:756158400.0):140068800.0,P:896227200.0):124356150.0):779416987.5);'"
# primate_tree = "'(((((((A:7846400.0,B:7846400.0):5555200.0,C:13401600.0):6634000.0,D:20035600.0):58535900.0,E:78571500.0):8022950.0,F:86594450.0):25757275.0,((G:87281400.0,H:87281400.0):11594400.0,I:98875800.0):13475925.0):87648312.5,(((J:45862000.0,K:45862000.0):32925500.0,(L:58136800.0,M:58136800.0):20650700.0):34610650.0,((N:84017600.0,O:84017600.0):15563200.0,P:99580800.0):13817350.0):86601887.5);'"

# simphy_command = "simphy/bin/simphy_lnx64 -v 0 -rs 1 -rl F:120000 -rg 1 -s " + fungi_tree + " -si F:1 -sp F:" + str(10000000*c) + " -sg F:" + str(10/c) + " -lb F:"+ str(0.0000000001*d) + " -ld F:" + str(0.0000000001*l) + " -hg F:0 -o fungi_" + fullName
simphy_command = "simphy/bin/simphy -v 0 -rs 1 -rl F:120000 -rg 1 -s " + fungi_tree + " -si F:1 -sp F:" + str(10000000*c) + " -sg F:" + str(10/c) + " -lb F:"+ str(0.0000000001*d) + " -ld F:" + str(0.0000000001*l) + " -hg F:0 -o fungi_" + fullName

# os.system("chmod +x simphy/bin/simphy_lnx64")
os.system("chmod +x simphy/bin/simphy")

for i in range(1):
    seed = str(np.random.random())[2:]
    seed = str(int(seed))

    # files = os.listdir('.')
    # if 'output_' + name not in files:
    os.system(simphy_command + ' -cs ' + seed)

    os.system("python3 process_simphy_fungi.py -n " + fullName)

    os.system("rm -r fungi_" + fullName)
    




