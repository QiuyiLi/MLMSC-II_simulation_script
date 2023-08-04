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
      print ('script_mlmsc.py -t <inputfile> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> ')
      sys.exit(2)
 
    
for opt, arg in opts:
      if opt == '-h':
         print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> ')
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
      print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> ')
      sys.exit(2)
     
if (len(d)==0):
      print ('Please provide a duplication rate')
      print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> ')
      sys.exit(2)
     
if (len(l)==0):
      print ('Please provide a loss rate')
      print ('script_mlmsc.py -t <species tree file> -n <number of gene trees (default 1)> -d <duplication rate> -l <loss rate> -c <effective population size multiplier (default 1)> ')
      sys.exit(2)
     
               
        
print ('The species tree file is', t)
print ('The number of gene trees is', n)
print ('The duplication rate is', d)
print ('The loss rate is', l)
print ('The effective population size multiplier is', c)

isExist = os.path.exists('./output/')
if not isExist:
   os.makedirs('./output/')


mlmsc_command = 'python3 MLMSC/MLMSC.py -i ' + str(t) + ' -n ' + str(n) + ' -d ' + str(float(d)*0.001) + ' -l ' + str(float(l)*0.001) + ' -c ' + str(1/float(c)) + ' -u 1'

for i in range(1):
    seed = str(np.random.random())[2:10]
    seed = str(int(seed))
    os.system(mlmsc_command + ' -s ' + seed)

    files = os.listdir('./output/')
    for file_name in files:
        if file_name.endswith((".txt", ".newick")):
         name_l = file_name.split('D')[0]
         name_r = file_name.split('.')[-1]
         r_d = float(file_name.split('D')[1].split('L')[0])
         r_l = float(file_name.split('L')[1].split('C')[0])
         r_c = float(file_name.split('C')[1][:-len(name_r)-1])
                 
         if abs(r_d-float(d)*0.001)<10**(-6) and abs(r_l-float(l)*0.001)<10**(-6) and abs(r_c-float(c))<10**(-6):
            middle_name = str(d) + 'L' + str(l) + 'C' + str(c) 
            new_name = name_l + 'D' + middle_name + '.' + name_r
            os.rename('./output/'+file_name, './output/'+new_name)
            
            
print("done.")

