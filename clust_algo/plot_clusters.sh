Rprog=R


points_file=$1
centers_file=$2
k=$3



#points_file=$1
#centers_file=$2
#k=$3

$Rprog --no-save BATCH $points_file $centers_file $k < plot_clusters.R > "r_Errors.txt" 2>&1

