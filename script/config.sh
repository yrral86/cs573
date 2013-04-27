Jar="${HOME}/weka.jar"
Weka="java -Xmx256M -cp $Jar  "


Cart="weka.classifiers.trees.M5P -R"
C45="weka.classifiers.trees.J48  -C 0.25 -M 2 "
Apriori="weka.associations.ApriorI \
   	-T 1 -C 1 -D 0.05 -U 1.0 -M 0.3 -S -1.0 "

blab() {
    echo $* >&2
}


Tmp=$HOME/tmp
mkdir -p $Tmp

nbins() {
   $Weka \
     weka.filters.unsupervised.attribute.Discretize \
     -F -B $1 \
     -R first-last  -i $2 -o $3
}

fayyadIrani() {
    echo ":in $1 :out $2"
   $Weka \
     weka.filters.supervised.attribute.Discretize \
     -c last -R first-last  -i $1 -o $2
}

j48() {
    local suffix=""
    local C=${1:-0.25}
    local m=${2:-2}
    if [ -n "$4" ]; then suffix=" -T $4 "; fi
    $Weka weka.classifiers.trees.J48  -C $C -M $m -t $3 $suffix 
}

apriori() {
    local c=${1:-0.5}
    local M=${2:-0.1}
    $Weka weka.associations.Apriori  -C $c -M $M -t $3
}

