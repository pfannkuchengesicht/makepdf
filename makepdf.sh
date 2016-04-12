#!/bin/bash

if [ -e $1 ]
then
    echo $1 Existiert schon. Neuen Dateinamen für Ausgabedatei wählen.
    exit 1
fi

tmp=$(mktemp)
declare -i c
c=0

echo '\documentclass{article}' >> $tmp
echo '\usepackage{pdfpages}' >> $tmp
echo '\begin{document}' >> $tmp
for f in $@
do
    if [ $c -lt 1 ]
    then
        c=c+1
        continue
    fi
    echo '\includepdf{'$f'}' >> $tmp
done
echo '\end{document}' >> $tmp

pdflatex $tmp 
mv tmp.pdf "$1"
rm $tmp
