###PcoA on Pfam and InterProScan results###

library(vegan) #load library

#Import files for analysis
data1 <- read.csv("PFAM.csv", header=TRUE, row.names=1)
data2 <_ read.csv("InterProScan.csv", header=TRUE, row.names=1)

#Transposition of data
data_t1 <- t(data1)
data_t2 <- t(data2)

#Calculate Vray-Curtis dissimilarity matrix
dist_matrix1 <- vegdist(data_t1, method="bray")
dist_matrix2 <- vegdist(data_t2, method="bray")

#Performon PCoA analysis
pcoa1 <- cmdscale(dist_matrix1, eig=TRUE, k=2)
pcoa2 <- cmdscale(dist_matrix2, eig=TRUE, k=2)

##Potting for PFAM data

# Generate colors for the PFAM dataset
colors1 <- rainbow(length(rownames(pcoa1$points)))

# Plot PCoA for PFAM data
plot(pcoa1$points[,1], pcoa1$points[,2], 
     xlab="PCoA1", ylab="PCoA2", 
     pch=16, cex=1.5, main="Pfam", 
     col=colors1)

# Add legend for PFAM data
legend("topright", legend=rownames(pcoa1$points), 
       fill=colors1, cex=0.8, title="Samples")

##Plotting for InterProScan data

# Generate colors for the second dataset
colors2 <- rainbow(length(rownames(pcoa2$points)))

# Plot PCoA for InterProScan data
plot(pcoa2$points[,1], pcoa2$points[,2], 
     xlab="PCoA1", ylab="PCoA2", 
     pch=16, cex=1.5, main="InterProScan", 
     col=colors2)

# Add legend for InterProScan data
legend("topright", legend=rownames(pcoa2$points), 
       fill=colors2, cex=0.8, title="Samples")
