library(ggplot2)
library(dplyr)

# The dataset is provided in the gapminder library
install.packages('gapminder')
library(gapminder)
data <- read.table('GO_cispla.csv', header = TRUE, sep=',') %>% filter(dataset=="Acis_down") %>% dplyr::select(-dataset)

# Most basic bubble plot
data %>%
  arrange(desc(enrichment)) %>%
  mutate(pathway = factor(pathway, pathway)) %>%
  ggplot(aes(x=count, y=pathway, size=enrichment, color=FDR)) +
  geom_point(alpha=0.5) +
  scale_size(range = c(.1, 24), name="Enrichment")
