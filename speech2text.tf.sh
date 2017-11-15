#!/bin/bash

BASEDIR=$(dirname $0)

echo "$0 $@"  # Print the command line for logging

txt=""
trs=""
ctm=""
sbv=""
srt=""
clean=false
nthreads=""
nnet2_online=false

. $BASEDIR/utils/parse_options.sh || exit 1;

. $BASEDIR/path.tf.sh

if [ $# -ne 1 ]; then
  echo "Usage: speech2text [options] <audiofile>"
  echo "Options:"
  echo "  --nthreads <n>        # Use <n> threads in parallel for decoding"
  echo "  --txt <txt-file>      # Put the result in a simple text file"
  echo "  --trs <trs-file>      # Put the result in trs file (XML file for Transcriber)"
  echo "  --ctm <ctm-file>      # Put the result in CTM file (one line pwer word with timing information)"
  echo "  --sbv <sbv-file>      # Put the result in SBV file (subtitles for e.g. YouTube)"
  echo "  --srt <srt-file>      # Put the result in SRT file (subtitles)"
  echo "  --labels <lbl-file>   # Put the result in Audacity labels format"
  echo "  --clean (true|false)  # Delete intermediate files generated during decoding (true by default)"
  echo "  --nnet2-online (true|false) # Use one-pass decoding using online nnet2 models. 3 times faster, 10% relatively more errors (false by default)"
  exit 1;
fi

DIRNAME=$(dirname $1)

nthreads_arg=""
if [ ! -z $nthreads ]; then
  echo "Using $nthreads threads for decoding"
  nthreads_arg="nthreads=$nthreads"
fi
  
cp -u $1 $BASEDIR/src-audio

makefile="Makefile.tf"

filename=$(basename "$1")
basename="${filename%.*}"

nnet2_online_arg="DO_NNET2_ONLINE=no"
if $nnet2_online; then
  nnet2_online_arg="DO_NNET2_ONLINE=yes"
fi

(cd $BASEDIR; make -f ${makefile} $nthreads_arg $nnet2_online_arg build/output/${basename%.*}.{txt,trs,ctm,sbv,srt,labels} || exit 1; if $clean ; then make -f ${makefile} .${basename%.*}.clean; fi)

# put phonetic transcription in output folder (not part of Makefile)
#python local/readphonemes.py build/trans/${basename}/eesen/decode/phones.1.txt > build/output/${basename}.phones

rm $BASEDIR/src-audio/$filename

echo "Finished transcribing, result is in files $BASEDIR/build/output/${basename%.*}.{txt,trs,ctm,sbv,srt,labels}"

if [ ! -z $txt ]; then
 cp $BASEDIR/build/output/${basename%.*}.txt $txt
 echo $txt
fi

if [ ! -z $trs ]; then
 cp $BASEDIR/build/output/${basename%.*}.trs $trs
fi
                                                                   
if [ ! -z $ctm ]; then
 cp $BASEDIR/build/output/${basename%.*}.ctm $ctm
fi
                                                                   
if [ ! -z $sbv ]; then
 cp $BASEDIR/build/output/${basename%.*}.sbv $sbv
fi  

if [ ! -z $srt ]; then
 cp $BASEDIR/build/output/${basename%.*}.srt $srt
fi

if [ ! -z $labels ]; then
 cp $BASEDIR/build/output/${basename%.*}.labels $labels
fi
