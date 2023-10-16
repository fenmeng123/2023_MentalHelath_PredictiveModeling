library(bruceR)
library(openxlsx)
library(ggridges)
library(svglite)
set.wd()
sink('../Res_1_Logs/Log_OptimalLambda_Suicide.txt',
     type = 'output',
     append = F)
res <- read.xlsx('../Res_2_Results/ResML_OptimeHyperpara_Suicide/ResML_L2Logit_RFECV_IterNum1000_Suicide.xlsx')

# Find the best hyper parameter -------------------------------------------
res %>% select(-X1) %>%
  group_by(Lambda2)%>%
  summarise(BalancedACC = mean(balacc),
            SD = sd(balacc)) -> stats_res
Opt_lambda = stats_res$Lambda2[which.max(stats_res$BalancedACC)]
Opt_balacc = stats_res$BalancedACC[which.max(stats_res$BalancedACC)]
cat(sprintf('The Best L2 = %.6f (Balanced ACC=%.4f)\n',Opt_lambda,Opt_balacc))
annotate_text = bquote('Initial'~lambda[2] == .(round(Opt_lambda,digits = 6)))

res %>% select(-X1) %>%
  group_by(Lambda2)%>%
  summarise(BalancedACC = mean(balacc),
            SD = sd(balacc)) %>%
  ggplot(aes(x=Lambda2,y=BalancedACC))+
  geom_point(aes(colour=BalancedACC),size=1.5,alpha=0.4)+
  geom_line(alpha=0.4,linewidth=1)+
  scale_x_log10()+theme_bruce()+
  xlab(expression(paste(lambda[2],' [L2-norm Regularized Parameter]')))+
  ylab('Balanced ACC')+
  ggtitle('Predicting Suicidal Ideation: Hyper-parameter Optimization')+
  scale_y_continuous(breaks=c(0.5,0.6,0.7,0.8,0.9,1), 
                     labels = c('50%','60%','70%','80%','90%','100%'),
                     limits = c(0.5,1))+
  theme(panel.grid.major.y = element_line(colour = 'grey50',
                                          linewidth = 0.2,
                                          linetype = 'dashed'),
        plot.title = element_text(hjust = 0),
        legend.position = 'none')+
  scale_color_viridis_c(option = 'H')+
  geom_vline(xintercept = Opt_lambda,
             linetype='dashed',
             colour = "black",
             alpha=0.7,
             linewidth=1)+
  geom_point(aes(x=Opt_lambda,y = Opt_balacc),
             inherit.aes = F,
             size=4,
             colour = 'red',
             shape = 1,
             stroke = 2)+
  geom_vline(xintercept = Opt_lambda*0.5,
             linetype='dashed',
             colour = "grey",
             alpha=0.7,
             linewidth=1)+
  geom_vline(xintercept = Opt_lambda*1.5,
             linetype='dashed',
             colour = "grey",
             alpha=0.7,
             linewidth=1)+
  annotate(#添加箭头
    geom = "curve", x = 0.5, y = 0.91, xend = Opt_lambda, yend = Opt_balacc+0.005, 
    curvature = -0.2, arrow = arrow(length = unit(3, "mm")),
    linewidth = 1,
  ) +
  annotate(geom = "text", x = 0.4, y = 0.91,
           label = annotate_text, hjust = "right") -> p
p

ggsave('../Res_2_Results/ResML_OptimeHyperpara_Suicide/Res_Lineplot_HyperparaOptim_Suicide.png',
       plot = p)
ggsave('../Res_2_Results/ResML_OptimeHyperpara_Suicide/Res_Lineplot_HyperparaOptim_Suicide.svg',
       plot = p)
# Plot of result of fine-tuning -------------------------------------------
res <- read.xlsx('../Res_2_Results/ResML_OptimeHyperpara_Suicide/ResML_L2Logit_FineTune_IterNum100_Suicide.xlsx')
res %>% select(-X1) %>%
  group_by(Lambda2)%>%
  summarise(BalancedACC = mean(balacc),
            SD = sd(balacc)) -> stats_res
Opt_lambda = stats_res$Lambda2[which.max(stats_res$BalancedACC)]
Opt_balacc = stats_res$BalancedACC[which.max(stats_res$BalancedACC)]
cat(sprintf('Fine-tuning: the Best L2 = %.6f (Balanced ACC=%.4f)\n',Opt_lambda,Opt_balacc))
annotate_text = bquote('Optimal'~lambda[2] == .(round(Opt_lambda,digits = 6)))

res %>% select(-X1) %>%
  group_by(Lambda2)%>%
  summarise(BalancedACC = mean(balacc),
            SD = sd(balacc)) %>%
  ggplot(aes(x=Lambda2,y=BalancedACC))+
  geom_point(aes(colour=BalancedACC),size=1.5,alpha=0.8)+
  geom_line(alpha=0.4,linewidth=0.5)+theme_bruce()+
  xlab(expression(paste(lambda[2],' [L2-norm Regularized Parameter]')))+
  ylab('Balanced ACC')+
  theme(panel.grid.major.y = element_line(colour = 'grey50',
                                          linewidth = 0.2,
                                          linetype = 'dashed'),
        plot.title = element_text(hjust = 0),
        legend.position = 'none')+
  scale_color_viridis_c(option = 'H')+
  geom_vline(xintercept = Opt_lambda,
             linetype='dashed',
             colour = "black",
             alpha=0.7,
             linewidth=1)+
  geom_point(aes(x=Opt_lambda,y = Opt_balacc),
             inherit.aes = F,
             size=4,
             colour = 'red',
             shape = 1,
             stroke = 2)+
  annotate(geom = "text", x = 298, y = 0.8286,
           label = annotate_text, hjust = "left") -> p
p
ggsave('../Res_2_Results/ResML_OptimeHyperpara_Suicide/Res_Lineplot_FineTune_Suicide.png',
       plot = p)
ggsave('../Res_2_Results/ResML_OptimeHyperpara_Suicide/Res_Lineplot_FineTune_Suicide.svg',
       plot = p)
sink()