#!/bin/bash

FILE=$1

if [ "${FILE}" == "" ]; then
    echo "usage: $0 file"
    exit 1 
fi

OUTFILE=n3.out.$$
LOGFILE="logs/$(basename ${FILE%.*}.txt)"

eye --quiet --nope --pass example_tester.n3 ${FILE} > ${OUTFILE} 2> ${LOGFILE}

if [ $? -eq 0 ]; then
    echo "OK : ${FILE} : syntax valid"
else
    echo "ERROR : ${FILE} : syntax not valid"
    rm $OUTFILE
    exit 2
fi

VALID=0

grep ":examples :valid true." ${OUTFILE} > /dev/null 2>&1 

if [ $? -eq 0 ]; then
    VALID=1
else
    VALID=0
fi

SKIPPED=0

grep "fno:TestSkip" ${FILE} > /dev/null 2>&1 

if [ $? -eq 0 ]; then
    SKIPPED=1
fi

if [ ${SKIPPED} -eq 1 ]; then
    echo "NA : ${FILE} : example skipped"
    rm $LOGFILE
    rm $OUTFILE
elif [ ${VALID} -eq 1 ]; then
    echo "OK : ${FILE} : example valid"
    rm $LOGFILE
    rm $OUTFILE
else
    echo "** ERROR : ${FILE} : example not valid **"
    rm $OUTFILE
    exit 3
fi