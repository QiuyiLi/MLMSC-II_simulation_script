library(ape)
library(treeCentrality)

"""
Set the working directory to 'data_analysis',
or change dir to the full directory to 'data_analysis', 
such as dir = '~/desktop/simulation_script/data_analysis/'
"""
dir = './'

files_dir = paste(dir, 'simphy_tree/gene/', sep='')
files = list.files(files_dir)

summary_data = data.frame(colless=numeric(), std_colless=numeric(),
                          r_d=numeric(), coal_unit=numeric())

for (i in 1:length(files)){
  file_dir = paste(files_dir, files[i], sep='')
  file_data = readLines(file_dir, n=1000)
  
  colless_index = rep(0,length(file_data))
  for (j in 1:length(file_data)) {
    treeString = file_data[j]
    tree = read.tree(text=treeString)
    colless_index[j] = computeColless(tree)
  }
  
  paras = strsplit(files[i], '_')[[1]][3]
  paras = strsplit(paras, '.newick')[[1]][1]
  
  r_d = strsplit(paras, 'L')[[1]][1]
  r_d = strsplit(r_d, 'D')[[1]][2]
  r_d = as.numeric(r_d)
  
  r_l = strsplit(paras, 'C')[[1]][1]
  r_l = strsplit(r_l, 'L')[[1]][2]
  r_l = as.numeric(r_l)
  
  coal_unit = strsplit(paras, 'C')[[1]][2]
  coal_unit = as.numeric(coal_unit)
  
  new_data = data.frame(colless=mean(colless_index), std_colless=sd(colless_index)/sqrt(length(colless_index)),
                        r_d=r_d, coal_unit=coal_unit)
  summary_data = rbind(summary_data, new_data)
}

simphy_gene = summary_data
simphy_gene$model = 'DLCoal'

#######################################################################################
files_dir = paste(dir, 'mlmsc_tree/gene/', sep='')
files = list.files(files_dir)

summary_data = data.frame(colless=numeric(), std_colless=numeric(),
                          r_d=numeric(), coal_unit=numeric())

for (i in 1:length(files)){
  file_dir = paste(files_dir, files[i], sep='')
  file_data = readLines(file_dir, n=1000)
  
  colless_index = rep(0,length(file_data))
  for (j in 1:length(file_data)) {
    treeString = file_data[j]
    tree = read.tree(text=treeString)
    colless_index[j] = computeColless(tree)
  }
  
  paras = strsplit(files[i], '_')[[1]][3]
  paras = strsplit(paras, '.newick')[[1]][1]
  
  r_d = strsplit(paras, 'L')[[1]][1]
  r_d = strsplit(r_d, 'D')[[1]][2]
  r_d = as.numeric(r_d)
  
  r_l = strsplit(paras, 'C')[[1]][1]
  r_l = strsplit(r_l, 'L')[[1]][2]
  r_l = as.numeric(r_l)
  
  coal_unit = strsplit(paras, 'C')[[1]][2]
  coal_unit = as.numeric(coal_unit)
  
  new_data = data.frame(colless=mean(colless_index), std_colless=sd(colless_index)/sqrt(length(colless_index)),
                        r_d=r_d, coal_unit=coal_unit)
  summary_data = rbind(summary_data, new_data)
}

mlmsc_gene = summary_data
mlmsc_gene$model = 'MLMSC-II'

#######################################################################################
combined_data = rbind(mlmsc_gene, simphy_gene)
summary_dir = paste(dir, 'summary_colless_gene.csv', sep='')

write.csv(combined_data, summary_dir, row.names = FALSE)
combined_data = read_csv(summary_dir)

ggplot(combined_data, aes(r_d, colless, color=factor(coal_unit), linetype=model)) +
  geom_errorbar(
    aes(ymin = colless-std_colless, ymax = colless+std_colless, color = factor(coal_unit)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('Colless index') +
  guides(color=guide_legend(title="2N (10^7)"), 
         linetype=guide_legend(title="models")) + 
  theme_minimal()

#######################################################################################
basic_summary_dir = paste(dir, 'summary_data.csv', sep='')
basic_summary_df = read_csv(basic_summary_dir)

colless_summary_dir = paste(dir, 'summary_colless_gene.csv', sep='')
colless_summary_df = read_csv(colless_summary_dir)
colless_summary_df$r_l = 1

combined_summary_df = merge(x=colless_summary_df, y=basic_summary_df, 
                            by=c("r_d","r_l","coal_unit","model"))

ggplot(combined_summary_df, aes(n_dups, colless, color=factor(coal_unit), linetype=model)) +
  geom_errorbar(
    aes(ymin = colless-std_colless, ymax = colless+std_colless, color = factor(coal_unit)), width = 0.3) + 
  geom_errorbar(
    aes(xmin = n_dups-std_dups, xmax = n_dups+std_dups, color = factor(coal_unit)), width = 0.005) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Number of duplications') +
  ylab('RF distance') +
  guides(color=guide_legend(title="2N (10^7)"), 
         linetype=guide_legend(title="models")) + 
  theme_minimal()

#######################################################################################

simphy_D4L4C9 = readLines(paste(dir, 'simphy_tree/gene/gene_tree_D4L4C9.newick', sep=''), n=1000)
mlmsc_D4L4C9 = readLines(paste(dir, 'mlmsc_tree/gene/gene_tree_D4L4C9.newick', sep=''), n=1000)

colless_simphy_D4L4C9 = rep(0,length(simphy_D4L4C9))
colless_mlmsc_D4L4C9 = rep(0,length(mlmsc_D4L4C9))

for (j in 1:length(simphy_D4L4C9)) {
  treeString = simphy_D4L4C9[j]
  tree = read.tree(text=treeString)
  colless_simphy_D4L4C9[j] = computeColless(tree)
}

for (j in 1:length(mlmsc_D4L4C9)) {
  treeString = mlmsc_D4L4C9[j]
  tree = read.tree(text=treeString)
  colless_mlmsc_D4L4C9[j] = computeColless(tree)
}

distr_dups = data.frame(num_dups=c(colless_simphy_D4L4C9, colless_mlmsc_D4L4C9), 
                        models=c(rep('DLCoal',length(colless_simphy_D4L4C9)),rep('MLMSC-II',length(colless_mlmsc_D4L4C9))))
ggplot(distr_dups, aes(x=num_dups, color=models)) +
  geom_density(alpha=0.4, adjust = 4) + 
  xlab('Colless index') +
  theme_minimal()











