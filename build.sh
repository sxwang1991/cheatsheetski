#!/bin/bash

CURRENT_DIR=$(pwd)
PDF_OUTPUTDIR=$CURRENT_DIR/pdf
PDF_MAINNAME=cheatsheetski
LOGFILE=$CURRENT_DIR/output_cmd.log

set -e

if [ -z $1 ];then set 1="";fi
if [ $1 = "cleanall" ]; then
    echo "Cleaning..."
    if [ $(basename $CURRENT_DIR) != "cheatsheetski" ]; then
        echo "Please run build.sh clean in the cheatsheetski/ directory"
        exit
    fi
    rm *.log *.aux *.pdf
    cd pdf
    rm *.log *.aux *.pdf
    echo "Done !"
    exit
fi

type pdflatex > /dev/null

for f in $CURRENT_DIR/contents/sections/*; do
    texfilename=$f/page.tex
    name_section=$(basename $(dirname $texfilename))
    echo "Generating PDF for $name_section ..."
    pdflatex -halt-on-error -jobname $name_section -output-directory $PDF_OUTPUTDIR $texfilename > $LOGFILE 2>&1 
done

echo "Generating the main pdf..."
pdflatex -halt-on-error -jobname $PDF_MAINNAME $CURRENT_DIR/contents/main.tex > $LOGFILE 2>&1
echo "Done, all in $PDF_MAINNAME.pdf ;-)"

if [ $1 = "clean" ]; then
    rm *.log *.aux
    cd pdf
    rm *.pdf *.log *.aux
fi
