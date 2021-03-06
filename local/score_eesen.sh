#!/bin/bash
#
# Copyright Johns Hopkins University (Author: Daniel Povey) 2012,
#           Brno University of Technology (Author: Karel Vesely) 2014,
# Apache 2.0
#

# begin configuration section.
cmd=run.pl
stage=0
decode_mbr=true
beam=7  # speed-up, but may affect MBR confidences.
word_ins_penalty=0 # not used for now
min_acwt=5
max_acwt=10
acwt_factor=0.1   # the scaling factor for the acoustic scale. The scaling factor for acoustic likelihoods
                 # needs to be 0.5 ~1.0. However, the job submission script can only take integers as the
                 # job marker. That's why we set the acwt to be integers (5 ~ 10), but scale them with 0.1
                 # when they are actually used.
#end configuration section.

[ -f ./path.sh ] && . ./path.sh
. parse_options.sh || exit 1;

if [ $# -ne 3 ]; then
  echo "Usage: local/score_sclite.sh [--cmd (run.pl|queue.pl...)] <data-dir> <lang-dir|graph-dir> <decode-dir>"
  echo " Options:"
  echo "    --cmd (run.pl|queue.pl...)      # specify how to run the sub-processes."
  echo "    --stage (0|1|2)                 # start scoring script from part-way through."
  echo "    --min_acwt <int>                # minumum LM-weight for lattice rescoring "
  echo "    --max_acwt <int>                # maximum LM-weight for lattice rescoring "
  exit 1;
fi

data=$1
lang=$2 # Note: may be graph directory not lang directory, but has the necessary stuff copied.
dir=$3

model=$dir/../final.mdl # assume model one level up from decoding dir.
symtab=$lang/words.txt

hubscr=$KALDI_ROOT/tools/sctk/bin/hubscr.pl 
[ ! -f $hubscr ] && echo "Cannot find scoring program at $hubscr" && exit 1;
hubdir=`dirname $hubscr`

for f in $data/stm $data/glm $lang/words.txt $lang/phones/word_boundary.int \
     $data/segments $data/reco2file_and_channel $dir/lat.1.gz; do
  [ ! -f $f ] && echo "$0: expecting file $f to exist" && exit 1;
done

# name=`basename $data`; # e.g. eval2000
nj=$(cat $dir/num_jobs)

mkdir -p $dir/scoring/log

if [ $stage -le 0 ]; then
  for wip in $(echo $word_ins_penalty | sed 's/,/ /g'); do
    $cmd ACWT=$min_acwt:$max_acwt $dir/scoring/log/get_ctm.ACWT.${wip}.log \
      set -e -o pipefail \; \
      mkdir -p $dir/score_ACWT_${wip}/ '&&' \
      lattice-1best --acoustic-scale=ACWT --ascale-factor=$acwt_factor "ark:gunzip -c $dir/lat.*.gz|" ark:- \| \
      nbest-to-ctm ark:- - \| \
      utils/int2sym.pl -f 5 $symtab \| \
      utils/convert_ctm.pl $data/segments $data/reco2file_and_channel \| \
      sort -k1,1 -k2,2 -k3,3nb '>' $dir/score_ACWT_${wip}/ctm || exit 1;
  done
fi

if [ $stage -le 1 ]; then
  # Remove some stuff we don't want to score, from the ctm.
  for x in $dir/score_*/ctm; do
    cat $x | grep -v -E '"\[BREATH|NOISE|COUGH|SMACK|UM|UH\]"' | \
      grep -v -E '"!SIL|\<UNK\>"' > ${x}.filt || exit 1;
  done
fi

# Score the set...
if [ $stage -le 2 ]; then
  for wip in $(echo $word_ins_penalty | sed 's/,/ /g'); do
    $cmd ACWT=$min_acwt:$max_acwt $dir/scoring/log/score.ACWT.${wip}.log \
      cp $data/stm $dir/score_ACWT_${wip}/ '&&' \
      $hubscr -p $hubdir -V -l english -h hub5 -g $data/glm -r $dir/score_ACWT_${wip}/stm $dir/score_ACWT_${wip}/ctm.filt || exit 1;
  done
fi

exit 0
