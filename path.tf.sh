#export CLUSTER_USER_WORK=/pylon2/ci560op/riebling
export CLUSTER_USER_WORK=/data/ASR5/er1k
#export EESEN_ROOT=/pylon2/ir3l68p/metze/eesen
export EESEN_ROOT=/data/ASR5/fmetze/eesen-tf
#export KALDI_ROOT=/pylon5/ci560op/riebling/kaldi
export KALDI_ROOT=/data/ASR5/fmetze/kaldi-latest

# paths to sox, lame

export SOX=/data/ASR1/tools/sox-14.4.2/
export LAME=/data/ASR1/tools/lame-3.99.5/frontend
export LD_LIBRARY_PATH=$SOX/install/lib:$LD_LIBRARY_PATH
export PATH=$SOX/install/bin:$LAME:$PATH

export PATH=$KALDI_ROOT/src/online2bin:$EESEN_ROOT/src/bin:$EESEN_ROOT/tools/sctk/bin:$EESEN_ROOT/tools/sph2pipe_v2.5:$EESEN_ROOT/tools/openfst/bin:$EESEN_ROOT/src/fstbin/:$EESEN_ROOT/src/featbin/:$EESEN_ROOT/src/lm/:$EESEN_ROOT/src/decoderbin:$EESEN_ROOT/src/netbin:$PWD:$PATH

export LC_ALL=C

# ROCKS
module load gcc-4.9.2
module load python27

# PSC Bridges

#module load atlas
#module load gcc

