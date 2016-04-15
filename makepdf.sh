#!/usr/bin/env bash

# check if necessary parameters are set
if [ "$#" -lt "2" ]
then
    echo "Usage: $0 <result file> <file 1> [... <file n>]"
    exit 1
fi

# check if file already exists
if [ -e $1 ]
then
    echo "$1 already exists. Please choose another name for your new PDF."
    exit 1
fi

# create temporary file
tmp=$(mktemp)

# declare and initialize variable 'c'; Required for loop to skip first parameter
declare -i c
c=0

# write LaTeX preamble into temporary file
echo '\documentclass{article}' >> $tmp
echo '\usepackage{pdfpages}' >> $tmp
echo '\begin{document}' >> $tmp

# now write includes for every file
for f in $@
do
    # skip first parameter to avoid inclusion of itself
    if [ $c -lt 1 ]
    then
        c=c+1
        continue
    fi
    echo '\includepdf{'$f'}' >> $tmp
done
echo '\end{document}' >> $tmp

# generate pdf file from LaTeX document
pdflatex $tmp 

# finally rename and move generated pdf file to the specified result file. Also remove the temporary LaTeX file.
mv tmp.pdf "$1"
rm $tmp
