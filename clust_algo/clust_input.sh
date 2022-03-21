#shell script for the clustering algorithm in cluster2d.pl
#cluster2d.pl will cluster x and y coordinate data based on Euclidean distances
#./cluster2d.pl <number of clusters> <number of iterations> <input file> <output file>

#input file is tab delimited and contains two columns (x and y) of x and y coordinates. Can have no header on this file or a header of "x" and "y" (needs the quotation marks).
#output files will contain the data points and their cluster assignments
#integers only (no decimals)

#./cluster2d.pl 7 20 Clustering_DataPoints.txt output.txt

#./cluster2d.pl 3 50 kirchofn_datapoints.txt output.txt
./cluster2d.pl 10 50 kirchofn_datapoints.txt output.txt

#./cluster2d.pl 2 10 Clust_Data.txt output.txt

