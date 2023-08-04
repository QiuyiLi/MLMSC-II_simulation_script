library(ape)
library(treeCentrality)

# Set the working directory to 'data_analysis',
# or define dir as the full directory to 'data_analysis', 
# such as dir = '~/desktop/simulation_script/data_analysis/'

### load simphy trees ###
dir = './'

files_dir = paste(dir, 'simphy_tree/gene/', sep='')
files = list.files(files_dir)

summary_data = data.frame(colless=numeric(), std_colless=numeric(),
                          r_d=numeric(), r_l=numeric(), coal_unit=numeric())

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
  
  if (r_d != 0){
    r_l = r_l/r_d
    new_data = data.frame(colless=mean(colless_index), std_colless=sd(colless_index)/sqrt(length(colless_index)),
                          r_d=r_d, r_l=r_l, coal_unit=coal_unit)
    summary_data = rbind(summary_data, new_data)
  }else{
    r_ls = c(0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2.0)
    for (k in 1:length(r_ls)){
      new_data = data.frame(colless=mean(colless_index), std_colless=sd(colless_index)/sqrt(length(colless_index)),
                            r_d=r_d, r_l=r_ls[k], coal_unit=coal_unit)
      summary_data = rbind(summary_data, new_data)
    }
  }
}

simphy_gene = summary_data
simphy_gene$model = 'DLCoal'

### load mlmsc trees ###
files_dir = paste(dir, 'mlmsc_tree/gene/', sep='')
files = list.files(files_dir)

summary_data = data.frame(colless=numeric(), std_colless=numeric(),
                          r_d=numeric(), r_l=numeric(), coal_unit=numeric())

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
  
  if (r_d != 0){
    r_l = r_l/r_d
    new_data = data.frame(colless=mean(colless_index), std_colless=sd(colless_index)/sqrt(length(colless_index)),
                          r_d=r_d, r_l=r_l, coal_unit=coal_unit)
    summary_data = rbind(summary_data, new_data)
  }else{
    r_ls = c(0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2.0)
    for (k in 1:length(r_ls)){
      new_data = data.frame(colless=mean(colless_index), std_colless=sd(colless_index)/sqrt(length(colless_index)),
                            r_d=r_d, r_l=r_ls[k], coal_unit=coal_unit)
      summary_data = rbind(summary_data, new_data)
    }
  }
}

mlmsc_gene = summary_data
mlmsc_gene$model = 'MLMSC-II'

### combine/select data ###
combined_data = rbind(mlmsc_gene, simphy_gene)

summary_dir = paste(dir, 'summary_colless_gene.csv', sep='')

write.csv(combined_data, summary_dir, row.names = FALSE)
combined_data = read_csv(summary_dir)

# all data which looks messy
sub_combined_data = combined_data 
# only look at the cases where rd=rl
sub_combined_data = combined_data[which(combined_data$r_l==1),] 
# only look at the cases where rd=0.5*rl, rd=rl, rd=2*rl
sub_combined_data = combined_data[which(combined_data$r_l==0.5 | combined_data$r_l==1 | combined_data$r_l==2),] 

### plot summary data with x = event rates ###
ggplot(sub_combined_data, aes(r_d, colless, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = colless-std_colless, ymax = colless+std_colless, color = factor(coal_unit)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('Colless index') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()


### plot summary data with x = number of duplications ###
basic_summary_dir = paste(dir, 'summary_data.csv', sep='')
basic_summary_df = read_csv(basic_summary_dir)

colless_summary_dir = paste(dir, 'summary_colless_gene.csv', sep='')
colless_summary_df = read_csv(colless_summary_dir)

combined_summary_df = merge(x=colless_summary_df, y=basic_summary_df, 
                            by=c("r_d","r_l","coal_unit","model"))

# all data which looks messy
sub_combined_summary = combined_summary_df 
# only look at the cases where rd=rl
sub_combined_summary = combined_summary_df[which(combined_summary_df$r_l==1),] 
# only look at the cases where rd=0.5*rl, rd=rl, rd=2*rl
sub_combined_summary = combined_summary_df[which(combined_summary_df$r_l==0.5 | combined_summary_df$r_l==1 | combined_summary_df$r_l==2),] 

ggplot(sub_combined_summary, aes(n_dups, colless, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = colless-std_colless, ymax = colless+std_colless, color = factor(coal_unit)), width = 0.3) + 
  geom_errorbar(
    aes(xmin = n_dups-std_dups, xmax = n_dups+std_dups, color = factor(coal_unit)), width = 0.005) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Number of duplications') +
  ylab('Colless index') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()


### plot density ###
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











