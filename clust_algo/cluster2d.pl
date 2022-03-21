#!/usr/bin/perl
#user inputs: k clusters, max # of iterations, (x,y) data points file, output file
#data points can be negative or positive

##############################################
## Bringing in values from the shell script.##
##############################################
$k_clust = $ARGV[0];
$num_itera = $ARGV[1];
$infile = $ARGV[2];
$outfile = $ARGV[3];


open(INFILE, "<", $infile) || die("Can't find the file $infile");
open(OUTFILE, ">", $outfile) || die("Can't find the file $outfile");

$line_one = ("X" . "\t" . "Y" . "\t" .  "Cluster" . "\n");
print(OUTFILE $line_one);


#######################################
## Pushing the data points to arrays.##
#######################################

#Separates the data points by xs and by ys (2D coordinates).

@xs = ();
@ys = ();
while ($point = <INFILE>){
    chomp($point);
    @points = split(/\t/, $point);
    $x_header = '"x"';
    $y_header = '"y"';
    if ($points[0] eq $x_header && $points[1] eq $y_header) {
        next;
    } else {
    $x_cord = $points[0];
    $y_cord = $points[1];
    push (@xs, $x_cord);
    push (@ys, $y_cord);
    }
}


#################################################################
##Creating random cluster centers within the range of the data.##
#################################################################



@sorted_xs = sort {$a <=> $b} @xs;      #sort the numbers in the xs array in ascending order
@sorted_ys = sort {$a <=> $b} @ys;      #sort the numbers in the ys array in ascending order


$xmin = $sorted_xs[0];  #take the first number in the sorted_xs array and assign it as the minimum x value
$xmax = $sorted_xs[-1]; #take the last number in the sorted_xs array and assign it as the maximum x value


$ymin = $sorted_ys[0];  #take the first number in the sorted_ys array and assign it as the minimum y value
$ymax = $sorted_ys[-1]; #take the last number in the sorted_ys array and assign it as the maximum y value

#need to know the range in order to keep the randomally generated cluster in the vicinity (i.e. range) of the data points
#if the y min is neg and ymax is pos then the y range is calculated one way, else the range is calculated another way (accounts for crazy calculations that might happen with neg values). 

if ($ymin < 0 && $ymax >= 0) {          #if ymin is neg and ymax is zero or positive
    $yrange = abs($ymax) + abs($ymin);  #add the absolute value of both the min and the max to find the range
} else {
    $yrange = $ymax - $ymin;            #else the range is max added to min
}

if ($xmin < 0 && $xmax >= 0) {
    $xrange = abs($xmax) + abs($xmin);
} else {
    $xrange = $xmax - $xmin;
}



#creating random centers and pusing them to appropriate arrays (x and ys separate)
@x_centers = ();
@y_centers = ();
#RANDOM CENTERS -only do once
for ($i	= 1; $i	<= $k_clust; $i++) {            #$i <= k_clust because the first round of the cluster centers should be randomly generated
    $rand_x = rand($xrange) + $xmin;
    $rand_y = rand($yrange) + $ymin;
    push (@x_centers, $rand_x);
    push (@y_centers, $rand_y);
}



##############################
##Subroutines section below.##
##################################################################
            ##Go to **** section for code using the subroutines.##
            ######################################################

##################################################################################################################################
##Subroutine that calculates the euclidean distances between the data points and the cluster centers (separately for xs and ys).##
##################################################################################################################################

#The calc_euc subroutine is called in the cluster_assignments subroutine.

sub calc_euc {
    @eucs = ();
    $x_data = shift(@_);    #Takes in the xs depening upon the values insterted when the subroutine is called
    $y_data = shift(@_);
        for ($e = 0; $e < $k_clust; $e++) {  #Each cluster center (the number given by the user) is compared to a single data point (x and y) 
                $x_cent = $x_centers[$e];
                $y_cent = $y_centers[$e];
                $euc_val = sqrt((($x_cent - $x_data)**2) + (($y_cent - $y_data)**2)); #euclidean distance calculation
                push(@eucs, $euc_val);
                #print("***********euc val ", $euc_val, "\n");
        }
}


#################################################################
##Subroutine that gives cluster assingments to the data points.##
#################################################################

sub cluster_assignments {
    @clusters = (); 
    @sorted_eucs = ();
    for ($i = 0; $i < scalar(@xs); $i++) {        
        undef(@eucs);
        #print("xs and ys", $xs[$i], $ys[$i], "\n"); 
        calc_euc($xs[$i], $ys[$i]);               #calculate the euclidean distance for each x and y coordinate
        @sorted_eucs = sort {$a <=> $b} @eucs;    #sort the euclidean distance values
        $min_euc = @sorted_eucs[-1]**2;          #initialize a minimum euc distance --guaranteed to be larger than the largest euc from the data
            for ($j = 0; $j < $k_clust; $j++) {   #The number of euc distances should equal the number of k clusters. Comparing each euc distance (of a single data point to the k # of cluster centers) to determine the smallest.
            if ($eucs[$j] < $min_euc) {                 #k cluster centers are in order. Ex: If the euc is smaller  1st value is the smallest the clust assign will = 1. 
            $min_euc = $eucs[$j];
            $clust_assign = $j + 1;            #This loop will then happen for each point found in the data file (thanks to the outer for loop that goes for < scalar@xs)
            }
        }
        #print("clust assign is: ", $clust_assign, "\n"); 
        push(@clusters, $clust_assign);          #push the cluster assignments to a clusters array
        #foreach $thing (@clusters) {
        #print ("clusters array inside loop: ",$thing . "\n");
        #}

    }
}

########################################################################################
##Subroutine that calculates the averages of the data points assigned to each cluster.##
########################################################################################


sub calc_avg {
    undef(@xs_avg_array);
    undef(@ys_avg_array);
    
    for ($m = 0; $m < $k_clust; $m++) {
        for ($n = 0; $n < scalar(@clusters); $n++) { 
            #print ("n is: ", $n . "\n");
            #print ("clusters[$n] is: ", $clusters[$n], "| m + 1 is: ", ($m + 1), "\n");
            if ($clusters[$n] == $m + 1) { #pushing the clust assingments for each cluster into an array - pushing order of the cluster assignments will be in numerical order - one loop only loops through a single k cluster
                #print ("THE CONDITIONAL WAS TRUE AND clusters[$n] is: ", $clusters[$n], "| m + 1 is: ", ($m + 1), "\n");
                #print ("Pushing ", $xs[$n], " to the temp x array. ", "\n");
                push (@temp_xs, $xs[$n]);
                push (@temp_ys, $ys[$n]);
            }
        }

            for ($f = 0; $f < scalar(@temp_xs); $f++) {              #the average of the data points in a single k cluster is calculated for both x and y coordinates
                $xnum = $temp_xs[$f];
                $x_sum = $x_sum + $xnum;
                $x_clust_count = $f + 1;
            }
            for ($p = 0; $p < scalar(@temp_ys); $p++) {              #the average of the data points in a single k cluster is calculated for both x and y coordinates
                $ynum = $temp_ys[$p];
                $y_sum = $y_sum + $ynum;
                $y_clust_count = $p + 1;
  
            } 

            if (x_clust_count == undef && y_clust_count <= 0) { # prevents an "Illegal division by zero" error if a cluster never get a data point assigned to it.
                $x_clust_count = $x_clust_count || 1;
                $y_clust_count = $y_clust_count || 1;
            }
            
            $x_avg = ($x_sum/$x_clust_count);           #sums are divided by the number of k clusters
            $y_avg = ($y_sum/$y_clust_count);

            push (@xs_avg_array, $x_avg);       #the averages are pushed to an array
            push (@ys_avg_array, $y_avg);
           
            undef(@temp_xs);                    #refreshing temp array and the sum values
            undef(@temp_ys);
            $x_sum = 0;
            $y_sum = 0; 
            $x_clust_count = 0;
            $y_clust_count = 0;
        }
            
    }


#####################################################################################
##Subroutine that uses these averages calculated aboves as the new cluster centers.##
#####################################################################################


sub push_to_cent{
    undef(@x_centers); #erase whats in these center arrays first
    undef(@y_centers);
    push(@x_centers, @xs_avg_array);
    push(@y_centers, @ys_avg_array);
}




#************************************************************************************************************************************#

##################################################
##Heart of the code. Subroutines to the rescue! ##  --sub calls for the first iteration
##################################################

cluster_assignments; #Subroutine that gives cluster assignments to the data points. Located above.
                     #cluster_assignments includes the subroutine calc_eucs which calculates the euclidean distances of a single data point to k cluster centers.
calc_avg;            #Subroutine that calculates the averages of the data points assigned to each cluster. Located above.
push_to_cent;        #Subroutine that uses these averages calculated aboves as the new cluster centers. Located above.

#--all subsequent iterations (after the first) will not use randomally generated cluster centers

for ($z = 1; $z < $num_itera; $z++) { # starting the loop at one (instead of zero) because the random cluster iteration will technically be the first iteration
    #print("----------ITERATION SEPARATION---------- Iteration number ", ($z + 1) , "\n");

    cluster_assignments;
    calc_avg;
    push_to_cent;

    if (@clusters ~~ @temp_clusters) {   ##~~~ is a special perl operator called "smartmatch". When we have ARRAY ~~ ARRAY (of the same length) it is matching each indexed value of one array to the same indexed value in the other array.
    #if statement evaluated beginning at the third iteration. First iteration: only values in @clusters. Second iteration: we have values in @clusters and @temp_clusters, but the @temp_cluster values are not assigned until after this conditional.
    print ("CONVERGENCE HAS BEEN REACHED. Cluster assignments from iteration ", $z, " are the same as the cluster assignments from iteration ", ($z + 1), ".\n");
    print("Printing the cluster assignments to the outfile and stopping the algorithm.", "\n");
    for ($l = 0; $l < scalar(@clusters); $l++) {
        print(OUTFILE $xs[$l], "\t", $ys[$l],"\t", $clusters[$l], "\n");
     }
    last;
    }

    if (($z + 1) % 2 == 0) {            #at the end of every even iteration, the cluster assignments are pushed to another array. Later in the next iteration, the @cluster is compared to @temp_cluster (which holds the clust assigns from the previous iteration).
        @temp_clusters = ();            # % modulo operator conducts euc division. In this situation an even number will always evenly separate out into 2s. Thus, an even number % 2 will always = 0.
        push (@temp_clusters, @clusters);
    }

}




