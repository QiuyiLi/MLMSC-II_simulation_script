library(readr)
library(ggplot2)

# Set the working directory to 'data_analysis',
# or define dir as the full directory to 'data_analysis', 
# such as dir = '~/desktop/simulation_script/data_analysis/'

### load simphy data ###
dir = './'
files_dir = paste(dir, 'simphy_summary/', sep='')
files = list.files(files_dir)

summary_data = data.frame(n_dups=numeric(), std_dups=numeric(),
                          n_genes=numeric(), std_genes=numeric(),
                          n_species=numeric(),std_species=numeric(),
                          r_d=numeric(), r_l=numeric(), coal_unit=numeric())

for (i in 1:length(files)){
  file_dir = paste(files_dir, files[i], sep='')
  file_data = read_csv(file_dir)
  
  paras = strsplit(files[i], '_')[[1]][2]
  paras = strsplit(paras, '.txt')[[1]][1]
  
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
    new_data = data.frame(n_dups=mean(file_data$n_d), std_dups=sd(file_data$n_d)/sqrt(length(file_data$n_d)),
                          n_genes=mean(file_data$n_genes), std_genes=sd(file_data$n_genes)/sqrt(length(file_data$n_genes)),
                          n_species=mean(file_data$n_species),std_species=sd(file_data$n_species)/sqrt(length(file_data$n_species)),
                          r_d=r_d, r_l=r_l, coal_unit=coal_unit)
    summary_data = rbind(summary_data, new_data)
  }else{
    r_ls = c(0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2.0)
    for (j in 1:length(r_ls)){
      new_data = data.frame(n_dups=mean(file_data$n_d), std_dups=sd(file_data$n_d)/sqrt(length(file_data$n_d)),
                            n_genes=mean(file_data$n_genes), std_genes=sd(file_data$n_genes)/sqrt(length(file_data$n_genes)),
                            n_species=mean(file_data$n_species),std_species=sd(file_data$n_species)/sqrt(length(file_data$n_species)),
                            r_d=r_d, r_l=r_ls[j], coal_unit=coal_unit)
      summary_data = rbind(summary_data, new_data)
    }
  }
}

simphy_data = summary_data
simphy_data$model = 'DLCoal'

### load mlmsc data ###
files_dir = paste(dir, 'mlmsc_summary/', sep='')
files = list.files(files_dir)

summary_data = data.frame(n_dups=numeric(), std_dups=numeric(),
                          n_genes=numeric(), std_genes=numeric(),
                          n_species=numeric(),std_species=numeric(),
                          r_d=numeric(), r_l=numeric(), coal_unit=numeric())

for (i in 1:length(files)){
  file_dir = paste(files_dir, files[i], sep='')
  file_data = read_csv(file_dir)
  
  paras = strsplit(files[i], '_')[[1]][2]
  paras = strsplit(paras, '.txt')[[1]][1]
  
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
    new_data = data.frame(n_dups=mean(file_data$n_d), std_dups=sd(file_data$n_d)/sqrt(length(file_data$n_d)),
                          n_genes=mean(file_data$n_genes), std_genes=sd(file_data$n_genes)/sqrt(length(file_data$n_genes)),
                          n_species=mean(file_data$n_species),std_species=sd(file_data$n_species)/sqrt(length(file_data$n_species)),
                          r_d=r_d, r_l=r_l, coal_unit=coal_unit)
    summary_data = rbind(summary_data, new_data)
  }else{
    r_ls = c(0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2.0)
    for (j in 1:length(r_ls)){
      new_data = data.frame(n_dups=mean(file_data$n_d), std_dups=sd(file_data$n_d)/sqrt(length(file_data$n_d)),
                            n_genes=mean(file_data$n_genes), std_genes=sd(file_data$n_genes)/sqrt(length(file_data$n_genes)),
                            n_species=mean(file_data$n_species),std_species=sd(file_data$n_species)/sqrt(length(file_data$n_species)),
                            r_d=r_d, r_l=r_ls[j], coal_unit=coal_unit)
      summary_data = rbind(summary_data, new_data)
    }
  }
}

mlmsc_data = summary_data
mlmsc_data$model = 'MLMSC-II'

### combine/select data ###
combined_data = rbind(mlmsc_data, simphy_data)

summary_dir = paste(dir, 'summary_data.csv', sep='')

write.csv(combined_data, summary_dir, row.names = FALSE)
combined_data = read_csv(summary_dir)

# all data which looks messy
sub_combined_data = combined_data 
# only look at the cases where rd=rl
sub_combined_data = combined_data[which(combined_data$r_l==1),] 
# only look at the cases where rd=0.5*rl, rd=rl, rd=2*rl
sub_combined_data = combined_data[which(combined_data$r_l==0.5 | combined_data$r_l==1 | combined_data$r_l==2),] 


### plot summary data with x = event rates ###
ggplot(sub_combined_data, aes(r_d, n_dups, shape=factor(coal_unit), linetype=model, color=factor(r_l))) +
  geom_errorbar(
    aes(ymin = n_dups-std_dups, ymax = n_dups+std_dups, color = factor(r_l)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('Number of surviving duplications') +
  guides(shape=guide_legend(title="2N (10^7)"), 
         color=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

ggplot(sub_combined_data, aes(r_d, n_genes, shape=factor(coal_unit), linetype=model, color=factor(r_l))) +
  geom_errorbar(
    aes(ymin = n_genes-std_genes, ymax = n_genes+std_genes, color = factor(r_l)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('Number of surviving duplications') +
  guides(shape=guide_legend(title="2N (10^7)"), 
         color=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

ggplot(sub_combined_data, aes(r_d, n_species, shape=factor(coal_unit), linetype=model, color=factor(r_l))) +
  geom_errorbar(
    aes(ymin = n_species-std_species, ymax = n_species+std_species, color = factor(r_l)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('Number of surviving duplications') +
  guides(shape=guide_legend(title="2N (10^7)"), 
         color=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

### plot density ###
simphy_D4L4C9 = read_csv(paste(dir, 'simphy_summary/summary_D4L4C9.txt', sep=''))
mlmsc_D4L4C9 = read_csv(paste(dir, 'mlmsc_summary/summary_D4L4C9.txt', sep=''))

distr_dups = data.frame(num_dups=c(simphy_D4L4C9$n_d, mlmsc_D4L4C9$n_d), 
                          models=c(rep('DLCoal',length(simphy_D4L4C9$n_d)),rep('MLMSC-II',length(mlmsc_D4L4C9$n_d))))
ggplot(distr_dups, aes(x=num_dups, color=models)) +
  geom_density(alpha=0.4, adjust = 4) + 
  xlab('Number of duplications') +
  theme_minimal()

