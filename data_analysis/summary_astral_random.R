library(readr)
library(ggplot2)

# change to user's own directory
dir = '/Users/qiuyi_li/Desktop/simulation_script/data_analysis/'

files_dir = paste(dir, 'astral_simphy/random/', sep='')
files = list.files(files_dir)

summary_data = data.frame(rf=numeric(), std_rf=numeric(),
                          cp=numeric(), std_cp=numeric(),
                          n_quartets=numeric(), std_quartets=numeric(), 
                          r_d=numeric(), r_l=numeric(), coal_unit=numeric())

for (i in 1:length(files)){
  file_dir = paste(files_dir, files[i], sep='')
  file_data = read_csv(file_dir)
  
  paras = strsplit(files[i], '_')[[1]][2]
  
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
    new_data = data.frame(rf=mean(file_data$rf), std_rf=sd(file_data$rf)/sqrt(length(file_data$rf)),
                          cp=mean(file_data$correct_prop), std_cp=sd(file_data$correct_prop)/sqrt(length(file_data$correct_prop)),
                          n_quartets=mean(file_data$total_quartet), std_quartets=sd(file_data$total_quartet)/sqrt(length(file_data$total_quartet)),
                          r_d=r_d, r_l=r_l, coal_unit=coal_unit)
    summary_data = rbind(summary_data, new_data)
  }else{
    r_ls = c(0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2.0)
    for (j in 1:length(r_ls)){
      new_data = data.frame(rf=mean(file_data$rf), std_rf=sd(file_data$rf)/sqrt(length(file_data$rf)),
                            cp=mean(file_data$correct_prop), std_cp=sd(file_data$correct_prop)/sqrt(length(file_data$correct_prop)),
                            n_quartets=mean(file_data$total_quartet), std_quartets=sd(file_data$total_quartet)/sqrt(length(file_data$total_quartet)),
                            r_d=r_d, r_l=r_ls[j], coal_unit=coal_unit)
      summary_data = rbind(summary_data, new_data)
    }
  }
}

simphy_random = summary_data
simphy_random$model = 'DLCoal'

#######################################################################################
files_dir = paste(dir, 'astral_mlmsc/random/', sep='')
files = list.files(files_dir)

summary_data = data.frame(rf=numeric(), std_rf=numeric(),
                          cp=numeric(), std_cp=numeric(),
                          n_quartets=numeric(), std_quartets=numeric(), 
                          r_d=numeric(), r_l=numeric(), coal_unit=numeric())

for (i in 1:length(files)){
  file_dir = paste(files_dir, files[i], sep='')
  file_data = read_csv(file_dir)
  
  paras = strsplit(files[i], '_')[[1]][2]
  
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
    new_data = data.frame(rf=mean(file_data$rf), std_rf=sd(file_data$rf)/sqrt(length(file_data$rf)),
                          cp=mean(file_data$correct_prop), std_cp=sd(file_data$correct_prop)/sqrt(length(file_data$correct_prop)),
                          n_quartets=mean(file_data$total_quartet), std_quartets=sd(file_data$total_quartet)/sqrt(length(file_data$total_quartet)),
                          r_d=r_d, r_l=r_l, coal_unit=coal_unit)
    summary_data = rbind(summary_data, new_data)
  }else{
    r_ls = c(0.4, 0.5, 0.7, 0.9, 1, 1.1, 1.3, 1.5, 2.0)
    for (j in 1:length(r_ls)){
      new_data = data.frame(rf=mean(file_data$rf), std_rf=sd(file_data$rf)/sqrt(length(file_data$rf)),
                            cp=mean(file_data$correct_prop), std_cp=sd(file_data$correct_prop)/sqrt(length(file_data$correct_prop)),
                            n_quartets=mean(file_data$total_quartet), std_quartets=sd(file_data$total_quartet)/sqrt(length(file_data$total_quartet)),
                            r_d=r_d, r_l=r_ls[j], coal_unit=coal_unit)
      summary_data = rbind(summary_data, new_data)
    }
  }
}

mlmsc_random = summary_data
mlmsc_random$model = 'MLMSC-II'

#######################################################################################

combined_data = rbind(mlmsc_random, simphy_random)
summary_dir = paste(dir, 'summary_rf_random.csv', sep='')

write.csv(combined_data, summary_dir, row.names = FALSE)
combined_data = read_csv(summary_dir)

# all data which looks messy
sub_combined_data = combined_data 
# only look at the cases where rd=rl
sub_combined_data = combined_data[which(combined_data$r_l==1),] 
# only look at the cases where rd=0.5*rl, rd=rl, rd=2*rl
sub_combined_data = combined_data[which(combined_data$r_l==0.5 | combined_data$r_l==1 | combined_data$r_l==2),] 

ggplot(sub_combined_data, aes(r_d, rf, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = rf-std_rf, ymax = rf+std_rf, color = factor(coal_unit)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('RF distance') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

ggplot(sub_combined_data, aes(r_d, cp, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = cp-std_cp, ymax = cp+std_cp, color = factor(coal_unit)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('RF distance') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

ggplot(sub_combined_data, aes(r_d, n_quartets, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = n_quartets-std_quartets, ymax = n_quartets+std_quartets, color = factor(coal_unit)), width = 0.3) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Duplication rate') +
  ylab('RF distance') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

#######################################################################################

basic_summary_dir = paste(dir, 'summary_data.csv', sep='')
basic_summary_df = read_csv(basic_summary_dir)

rf_summary_dir = paste(dir, 'summary_rf_random.csv', sep='')
rf_summary_df = read_csv(rf_summary_dir)

combined_summary_df = merge(x=rf_summary_df, y=basic_summary_df, 
                            by=c("r_d","r_l","coal_unit","model"))

# all data which looks messy
sub_combined_data = combined_summary_df 
# only look at the cases where rd=rl
sub_combined_data = combined_summary_df[which(combined_summary_df$r_l==1),] 
# only look at the cases where rd=0.5*rl, rd=rl, rd=2*rl
sub_combined_data = combined_summary_df[which(combined_summary_df$r_l==0.5 | combined_summary_df$r_l==1 | combined_summary_df$r_l==2),] 

ggplot(sub_combined_data, aes(n_dups, rf, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = rf-std_rf, ymax = rf+std_rf, color = factor(coal_unit)), width = 0.3) + 
  geom_errorbar(
    aes(xmin = n_dups-std_dups, xmax = n_dups+std_dups, color = factor(coal_unit)), width = 0.005) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Number of duplications') +
  ylab('RF distance') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

ggplot(sub_combined_data, aes(n_dups, cp, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = cp-std_cp, ymax = cp+std_cp, color = factor(coal_unit)), width = 0.3) + 
  geom_errorbar(
    aes(xmin = n_dups-std_dups, xmax = n_dups+std_dups, color = factor(coal_unit)), width = 0.005) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Number of duplications') +
  ylab('Correct proportion') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()

ggplot(sub_combined_data, aes(n_dups, n_quartets, color=factor(coal_unit), linetype=model, shape=factor(r_l))) +
  geom_errorbar(
    aes(ymin = n_quartets-std_quartets, ymax = n_quartets+std_quartets, color = factor(coal_unit)), width = 0.3) + 
  geom_errorbar(
    aes(xmin = n_dups-std_dups, xmax = n_dups+std_dups, color = factor(coal_unit)), width = 0.005) + 
  geom_point() +
  geom_path() + 
  scale_linetype_manual(values=c("dashed", "solid")) +
  xlab('Number of duplications') +
  ylab('Number of quartets') +
  guides(color=guide_legend(title="2N (10^7)"), 
         shape=guide_legend(title="r_l/r_d"),
         linetype=guide_legend(title="models")) + 
  theme_minimal()