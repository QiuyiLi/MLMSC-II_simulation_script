import sys, getopt
import os
import numpy as np





t = ''
n = '1'
d = ''
l = ''
c = '1'


try:
      opts, args = getopt.getopt(sys.argv[1:],"h:t:n:d:l:c:")

except getopt.GetoptError:
      print ('Option not recognized')
      print ('script_mlmsc.py -t <inputfile> -n <number of gene trees> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
 
    
for opt, arg in opts:
      if opt == '-h':
         print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
         sys.exit()
      elif opt in ("-t"):
         t = arg
      elif opt in ("-n"):
         n = arg
      elif opt in ("-d"):
         d = arg  
      elif opt in ("-l"):
         l = arg  
      elif opt in ("-c"):
         c = arg

         
  
if (len(t)==0):
      print ('Please provide a species tree')
      print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
     
if (len(d)==0):
      print ('Please provide a duplication rate')
      print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
     
if (len(l)==0):
      print ('Please provide a loss rate')
      print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size (default 1)> ')
      sys.exit(2)
     
               
        
print ('The species tree file is', t)
print ('The number of gene trees is', n)
print ('The duplication rate is', d)
print ('The loss rate is', l)
print ('The effective population size multiplier is', c)

isExist = os.path.exists('./output/')
if not isExist:
   os.makedirs('./output/')

fullName ='N' + str(n) + 'D' + str(d) +  'L' + str(l) +  'C' + str(c) 

f = open(str(t),'r')
speciesTreeString = '"' + f.read() + '"' 


# -rl F:120000 to be sure that enough trees are created, because some trees are empty....

simphy_command = "./SimPhy/bin/simphy -v 0 -rs 1 -rl F:120000 -s " + speciesTreeString + " -si F:1 -sp F:" + str(10000000*float(c)) + " -sg F:" + str(10/float(c)) + " -lb F:"+ str(0.0000000001*float(d)) + " -ld F:" + str(0.0000000001*float(l)) + " -hg F:0 -o tmp_" + fullName


for i in range(1):
    seed = str(np.random.random())[2:]
    seed = str(int(seed))

    # files = os.listdir('.')
    # if 'output_' + name not in files:   
    os.system(simphy_command + ' -cs ' + seed)  
    argsToSend = ' -t '  + str(t) + ' -n ' + str(n) + ' -d ' + str(d) +  ' -l ' + str(l) +  ' -c ' + str(c) 
    os.system("python3 process_simphy.py " + argsToSend)
    os.system("rm -r tmp_" + fullName)
    

print("done.")
