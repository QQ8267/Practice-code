library(lattice)
library(ggplot2)

Results <- read_csv("ReferendumResults.csv")
Results$Leave <- ifelse(Results$Leave == -1, NA, Results$Leave)
Results$Postals <- as.factor(Results$Postals)

#___________________

# GROUPING BY AGE

# none voters
age0_17 <- Results$Age_0to4 + Results$Age_5to7 + Results$Age_8to9 + Results$Age_10to14 + Results$Age_15 + Results$Age_16to17

# young adults
age18_29 <- Results$Age_18to19 + Results$Age_20to24 + Results$Age_25to29

# middle age
age30_64 <- Results$Age_30to44 + Results$Age_45to59 + Results$Age_60to64

# retired
age65_above <- Results$Age_65to74 + Results$Age_75to84 + Results$Age_85to89 + Results$Age_90plus

# proportion of Leave votes
Leave_p <- Results$Leave/Results$NVotes

#___________________

# New dataset -- VotingData
Results2 <- cbind(Results[1:1070,c(1:10, 27:49)], age0_17 , age18_29 , age30_64 , age65_above, Leave_p)
VotingData <- cbind(Results2[1:803,])

#___________________

# Explanatory Analysis

# calculate the correlations between 'Leave' and other attributes
cor.VotingData <- cor(VotingData[,9:37], VotingData$Leave_p,
                      use = "complete.obs")
# create a dataframe that also contains the abs correlations
cor.VotingData.df <- data.frame(cor = cor.VotingData, abs.cor = abs(cor.VotingData),
                                row.names = rownames(cor.VotingData))
# sort the dataframe by the abs correlations
cor.VotingData.df <- cor.VotingData.df[order(-cor.VotingData.df$abs.cor),]

Fig1 <- ggplot(cor.VotingData.df,
              aes(x = reorder(row.names(cor.VotingData.df), -abs.cor),
                  y = cor, fill = cor)) +
  geom_col() +
  ggtitle("VotingData: Top Postive/Negative Correlating Attributes") +
  xlab("Attribute") +
  scale_fill_gradient(low = "red", high = "green") +
  theme(axis.text.x = element_text(angle = -90, hjust = 0)) +
  labs(caption = "Fig1")

Fig1
ggsave("Fig1.tiff", units="in", dpi=300, compression = 'lzw')
dev.off()


plotA <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(NoQuals, Leave_p, color = "NoQuals")) +
  geom_point(aes(L1Quals, Leave_p, color = "L1Quals")) +
  geom_point(aes(L4Quals_plus, Leave_p, color = "L4Quals_plus")) +
  ggtitle("A") + 
  labs(x = "Proportion of leave votes", y = "Proportion of permanent residents", color = "Legend title") +
  scale_color_manual(values = c("red", "green", "blue"),
                     labels = c("L1Quals", "L4Quals_plus", "NoQuals"),
                     name = "Qualifications")


plotB <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(C1C2DE, Leave_p, color = "C1C2DE")) +
  geom_point(aes(C2DE, Leave_p, color = "C2DE")) +
  geom_point(aes(DE, Leave_p, color = "DE")) +
  ggtitle("B") + 
  labs(x = "Proportion of leave votes", y = "Proportion of households", color = "Legend title") +
  scale_color_manual(values = c("red", "green", "blue"),
                     labels = c("C1C2DE", "C2DE", "DE"),
                     name = "Social Grades")


plotC <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(HigherOccup, Leave_p, color = "HigherOccup")) +
  geom_point(aes(RoutineOccupOrLTU, Leave_p, color = "RoutineOccupOrLTU")) +
  geom_point(aes(Unemp, Leave_p, color = "Unemp")) +
  geom_point(aes(UnempRate_EA, Leave_p, color = "UnempRate_EA")) +
  ggtitle("C") + 
  labs(x = "Proportion of leave votes", y = "Proportion of permanent residents", color = "Legend title") +
  scale_color_manual(values = c("red", "green", "blue", "pink"),
                     labels = c("HigherOccup", "RoutineOccupOrLTU", "Unemp", "UnempRate_EA"),
                     name = "Occupation Type")


plotD <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(Asian, Leave_p, color = "Asian")) +
  geom_point(aes(Black, Leave_p, color = "Black")) +
  geom_point(aes(Indian, Leave_p, color = "Indian")) +
  geom_point(aes(Pakistani, Leave_p, color = "Pakistani")) +
  geom_point(aes(White, Leave_p, color = "White")) +
  ggtitle("D") + 
  labs(x = "Proportion of leave votes", y = "Proportion of permanent residents", color = "Legend title") +
  scale_color_manual(values = c("red", "green", "blue", "pink", "yellow"),
                     labels = c("Asian", "Black", "Indian", "Pakistani", "White"),
                     name = "Ethnicity")


plotE <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(Owned, Leave_p, color = "Owned")) +
  geom_point(aes(OwnedOutright, Leave_p, color = "OwnedOutright")) +
  geom_point(aes(PrivateRent, Leave_p, color = "PrivateRent")) +
  geom_point(aes(SocialRent, Leave_p, color = "SocialRent")) +
  ggtitle("E") + 
  labs(x = "Proportion of leave votes", y = "Proportion of households", color = "Legend title") +
  scale_color_manual(values = c("red", "green", "blue", "pink"),
                     labels = c("Owned", "OwnedOutright", "PrivateRent", "SocialRent"),
                     name = "Housing Type")


plotF <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(AdultMeanAge, Leave_p, color = "AdultMeanAge")) +
  geom_point(aes(MeanAge, Leave_p, color = "MeanAge")) +
  ggtitle("F") + 
  labs(x = "Proportion of leave votes", y = "Mean Age", color = "Legend title") +
  scale_color_manual(values = c("red", "green"),
                     labels = c("AdultMeanAge", "MeanAge"),
                     name = "Types of Mean Age")

plotG <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(Deprived, Leave_p, color = "Deprived")) +
  geom_point(aes(MultiDepriv, Leave_p, color = "MultiDepriv")) +
  ggtitle("G") + 
  labs(x = "Proportion of leave votes", y = "Proportion of households", color = "Legend title") +
  scale_color_manual(values = c("red", "green"),
                     labels = c("Deprived", "MultiDepriv"),
                     name = "Dimensions of Deprivation")

plotH <- ggplot(VotingData, aes(Leave_p)) +
  geom_point(aes(age0_17, Leave_p, color = "age0_17")) +
  geom_point(aes(age18_29, Leave_p, color = "age18_29")) +
  geom_point(aes(age30_64, Leave_p, color = "age30_64")) +
  geom_point(aes(age65_above, Leave_p, color = "age65_above")) +
  ggtitle("H") + 
  labs(x = "Proportion of leave votes", y = "Proportion of permanent residents", color = "Legend title") +
  scale_color_manual(values = c("red", "green", "blue", "pink"),
                     labels = c("age0_17", "age18_29", "age30_64", "age65_above"),
                     name = "Age type")

plotI <- ggplot(VotingData, aes(Leave_p, Postals)) + 
  ggtitle("I") + 
  geom_boxplot()

plotA
ggsave("Qualifications.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotB
ggsave("Social Grades.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotC
ggsave("Occupation Type.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotD
ggsave("Ethnicity.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotE
ggsave("Housing Type.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotF
ggsave("Types of Mean Age.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotG
ggsave("Dimensions of Deprivation.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotH
ggsave("Age type.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

plotI
ggsave("Postals.tiff", units="in", width=5, height=4, dpi=300, compression = 'lzw')
dev.off()

#___________________

#PCA (Ethnicity, Education, Social Grade, Housing, Occupation)

# -- Ethnicity
round(cor(Results[,27:31]),2)
Ethnicity.PCs <- prcomp(Results[,27:31], scale.=TRUE)
print(Ethnicity.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(Ethnicity.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(Ethnicity.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(Ethnicity.PCs, main="Variances of Ethnicity PCs")
Ethnicity_white <- Ethnicity.PCs$x[,1]
Ethnicity_nonblack <- Ethnicity.PCs$x[,2]
# Cumulative Proportion: 0.8434 --> 2 components


# -- Education
round(cor(Results[,36:38]),2)
Education.PCs <- prcomp(Results[,36:38], scale.=TRUE)
print(Education.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(Education.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(Education.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(Education.PCs, main="Variances of Education PCs")
Education_low <- Education.PCs$x[,1]
# Cumulative Proportion: 0.8843 --> 1 component


# -- Social Grade
round(cor(Results[,47:49]),2)
SocialGrade.PCs <- prcomp(Results[,47:49], scale.=TRUE)
print(SocialGrade.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(SocialGrade.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(SocialGrade.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(SocialGrade.PCs, main="Variances of Social Grade PCs")
SocialGrade <- SocialGrade.PCs$x[,1]
# Cumulative Proportion: 0.938 --> 1 component


# -- Housing
round(cor(Results[,32:35]),2)
Housing.PCs <- prcomp(Results[,32:35], scale.=TRUE)
print(Housing.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(Housing.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(Housing.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(Housing.PCs, main="Variances of Housing PCs")
HousingType <- Housing.PCs$x[,1]
HousingType2 <- Housing.PCs$x[,2]
# Cumulative Proportion: 0.9608 --> 2 components


# -- Unemployment
round(cor(Results[,c(40:41)]),2)
Occupation.PCs <- prcomp(Results[,c(40:41)], scale.=TRUE)
print(Occupation.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(Occupation.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(Occupation.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(Occupation.PCs, main="Variances of Occupation PCs")
Occupation <- Occupation.PCs$x[,1]
# Cumulative Proportion: 0.9894 --> 1 component


# -- Routine employment

round(cor(Results[,c(42:43)]),2)
RoutineEmploy.PCs <- prcomp(Results[,c(42:43)], scale.=TRUE)
print(RoutineEmploy.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(RoutineEmploy.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(RoutineEmploy.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(RoutineEmploy.PCs, main="Variances of Occupation PCs")
RoutineEmploy <- RoutineEmploy.PCs$x[,1]
# Cumulative Proportion: 0.9789 --> 1 component


# -- Deprivation
round(cor(Results[,c(45:46)]),2)
Deprivation.PCs <- prcomp(Results[,c(45:46)], scale.=TRUE)
print(Deprivation.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(Deprivation.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(Deprivation.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(Deprivation.PCs, main="Variances of Deprivation PCs")
Wealth <- Deprivation.PCs$x[,1]
# Cumulative Proportion: 0.9874 --> 1 component


# -- Age average
round(cor(Results[,c(9:10)]),2)
AverageAge.PCs <- prcomp(Results[,c(9:10)], scale.=TRUE)
print(AverageAge.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(AverageAge.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(AverageAge.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(AverageAge.PCs, main="Variances of Mean Age PCs")
AverageAge <- AverageAge.PCs$x[,1]
# Cumulative Proportion: 0.9675 --> 1 component


# -- Age total
round(cor(Results[,c(11:26)]),2)
TotalAge.PCs <- prcomp(Results[,c(11:26)], scale.=TRUE)
print(TotalAge.PCs, digits=2) # Columns are coefficients a[ij]
par(mfrow=c(1,1),lwd=2, mar=c(3,3,2,1), mgp=c(2, 0.75, 0))
biplot(TotalAge.PCs, col=c("skyblue3", "darkred"),
       xlabs=Results2$ID, cex=c(0.75,1.5), lwd=2)

summary(TotalAge.PCs)
par(mar=c(3,3,3,1), mgp=c(2,0.75,0))
plot(TotalAge.PCs, main="Variances of Total Age PCs")
Age1 <- TotalAge.PCs$x[,1]  #Young - Middle age Adults
Age2 <- TotalAge.PCs$x[,2]  #All Adults
Age3 <- TotalAge.PCs$x[,3]  #Education
# Cumulative Proportion: 0.8136 --> 3 components


#___________________

# New Variables Residents_p
Residents_p <- Results$Residents / Results$Households
HigherOccup <- Results2$HigherOccup
RoutineOccupOrLTU <- Results2$RoutineOccupOrLTU

# New dataset -- VotingData2
Results3 <- cbind(Results2[,c(1:8, 23, 28, 34:37)], Age1, Age2, Age3, AverageAge, 
                  Education_low, Ethnicity_nonblack, Ethnicity_white, 
                  HousingType, HousingType2, Occupation, RoutineEmploy,
                  SocialGrade, Wealth, Residents_p, Leave_p)
VotingData2 <- cbind(Results3[1:803,])

#___________________

# Clustering

# Means of covariates for each region
png(file="Region Cluster.png")
RegionMeans <- # Means of covariates for each region
  aggregate(Results[,-(1:8)], by=list(Results$RegionName), FUN=mean)
rownames(RegionMeans) <- RegionMeans[,1]
RegionMeans <- scale(RegionMeans[,-1]) # Standardise to mean 0 & SD 1
Distances <- dist(RegionMeans) # Pairwise distances
ClusTree <- hclust(Distances, method="complete") # Do the clustering
par(mar=c(3,3,3,1), mgp=c(2,0.75,0)) # Set plot margins
plot(ClusTree, xlab="Region name, Fig3", ylab="Separation", cex.main=0.8)
abline(h=10.3, col="red", lty=2) 
dev.off()

NewGroups <- cutree(ClusTree, k=3)
print(NewGroups, width=90)

# Updating VotingData2
VotingData2 <- merge(data.frame(RegionName=names(NewGroups), NewGroup=NewGroups), VotingData2)
table(VotingData2[,c("NewGroup", "RegionName")], dnn=c("Group", "Region"))
VotingData2$NewGroup <- as.factor(VotingData2$NewGroup)


# Means of covariates for each area type
png(file="Area Type Cluster.png")
AreaTypeMeans <- # Means of covariates for each region
  aggregate(Results[,-(1:8)], by=list(Results$AreaType), FUN=mean)
rownames(AreaTypeMeans) <- AreaTypeMeans[,1]
AreaTypeMeans <- scale(AreaTypeMeans[,-1]) # Standardise to mean 0 & SD 1
Distances <- dist(AreaTypeMeans) # Pairwise distances
ClusTree <- hclust(Distances, method="complete") # Do the clustering
par(mar=c(3,3,3,1), mgp=c(2,0.75,0)) # Set plot margins
plot(ClusTree, xlab="Area Type, Fig4", ylab="Separation", cex.main=0.8)
abline(h=6, col="red", lty=2) 
dev.off()

NewAreas <- cutree(ClusTree, k=3)
print(NewAreas, width=90)

# Updating VotingData2
VotingData2 <- merge(data.frame(AreaType=names(NewAreas), NewArea=NewAreas), VotingData2)
table(VotingData2[,c("NewArea", "AreaType")], dnn=c("Group", "Area"))
VotingData2$NewArea <- as.factor(VotingData2$NewArea)


#___________________

# calculate the correlations between 'Leave' and other attributes
cor.VotingData2 <- cor(VotingData2[,c(11:12, 17:30)], VotingData2$Leave_p,
                       use = "complete.obs")
# create a dataframe that also contains the abs correlations
cor.VotingData.df2 <- data.frame(cor = cor.VotingData2, abs.cor = abs(cor.VotingData2),
                                 row.names = rownames(cor.VotingData2))
# sort the dataframe by the abs correlations
cor.VotingData.df2 <- cor.VotingData.df2[order(-cor.VotingData.df2$abs.cor),]

Fig2 <- ggplot(cor.VotingData.df2,
       aes(x = reorder(row.names(cor.VotingData.df2), -abs.cor),
           y = cor, fill = cor)) +
  geom_col() +
  ggtitle("VotingData: Top Postive/Negative Correlating Attributes") +
  xlab("Attribute") +
  scale_fill_gradient(low = "red", high = "green") +
  theme(axis.text.x = element_text(angle = -90, hjust = 0)) +
  labs(caption = "Fig2")

Fig2
ggsave("Fig2.tiff", units="in", dpi=300, compression = 'lzw')
dev.off()

#___________________


# Modelling

# 1. Remove low correlated variables

Model1 <- glm(Leave_p ~ NewGroup  +NewArea + Students + Density + Age1 + Age2 + Age3 + Postals
              + AverageAge + Education_low + Ethnicity_nonblack + Ethnicity_white 
              + HousingType + HousingType2 + Occupation + RoutineEmploy + SocialGrade 
              + Wealth + Residents_p, 
              data = VotingData2, weights = NVotes, family = gaussian())
summary(Model1)
# From Fig 2: Occupation, Residents_p, Age3 are the weakest

# Removing Occupation
Model1a <- glm(Leave_p ~ NewGroup + NewArea + Students + Density + Age1 + Age2 + Age3 + Postals
               + AverageAge + Education_low + Ethnicity_nonblack + Ethnicity_white 
               + HousingType + HousingType2 + RoutineEmploy + SocialGrade 
               + Wealth + Residents_p, 
               data = VotingData2, weights = NVotes, family = gaussian())

# Removing Residents_p
Model1b <- glm(Leave_p ~ NewGroup + NewArea + Students + Density + Age1 + Age2 + Age3 + Postals
               + AverageAge + Education_low + Ethnicity_nonblack + Ethnicity_white 
               + HousingType + HousingType2 + Occupation + RoutineEmploy + SocialGrade 
               + Wealth, 
               data = VotingData2, weights = NVotes, family = gaussian())

# Removing Age3
Model1c <- glm(Leave_p ~ NewGroup + NewArea + Students + Density + Age1 + Age2 + Postals
              + AverageAge + Education_low + Ethnicity_nonblack + Ethnicity_white 
              + HousingType + HousingType2 + Occupation + RoutineEmploy + SocialGrade 
              + Wealth + Residents_p, 
              data = VotingData2, weights = NVotes, family = gaussian())

anova(Model1, Model1a, test = "Chi") # p-value 0.04077
anova(Model1, Model1b, test = "Chi") # p-value 0.01798
anova(Model1, Model1c, test = "Chi") # p-value 1.012e-05
# all 3 p-values are significant (<0.05) --> full model is better