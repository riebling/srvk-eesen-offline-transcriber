export CLUSTER_USER_WORK=/pylon2/ci560op/riebling
export EESEN_ROOT=/pylon2/ir3l68p/metze/eesen
export KALDI_ROOT=/pylon5/ci560op/riebling/kaldi

# paths to sox, lame                                                                                                                        
export SOX=$CLUSTER_USER_WORK/sox-14.4.2/
export LD_LIBRARY_PATH=$SOX/src/.libs:$LD_LIBRARY_PATH
export PATH=$CLUSTER_USER_WORK/sox-14.4.2/src:$CLUSTER_USER_WORK/lame-3.99.5/frontend:$PATH

export PATH=$KALDI_ROOT/src/online2bin:$EESEN_ROOT/src/bin:$EESEN_ROOT/tools/sctk/bin:$EESEN_ROOT/tools/sph2pipe_v2.5:$EESEN_ROOT/tools/ope\
nfst/bin:$EESEN_ROOT/src/fstbin/:$EESEN_ROOT/src/featbin/:$EESEN_ROOT/src/lm/:$EESEN_ROOT/src/decoderbin:$EESEN_ROOT/src/netbin:$PWD:$PATH

export LC_ALL=C

# ROCKS                                                                                                                                     
#module load gcc-4.9.2                                                                                                                      
#module load python27                                                                                                                       

# PSC Bridges                                                                                                                               
module load atlas
module load gcc

