KALDI_ROOT=~/eesen
# EESEN_ROOT set to /pylon2/ir3l68p/metze/eesen in path.tf.sh
#EESEN_ROOT=~/eesen
EESEN_MODELS_ROOT=$(CLUSTER_USER_WORK)/eesen-tf-models
SEGMENTS=show.s.seg
BEAM=17.0

# Tensorflow swbd models
ACWT=0.6
GRAPH_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/swbd/v2-pitch-30ms-tf-new/data/lang_phn_sw1_fsh_tgpr
#MODEL_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/swbd/v2-pitch-30ms-tf-new/exp/train_phn_l5_c280_tf_29o/dbr-run6/model/epoch18
MODEL_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/swbd/v2-pitch-30ms-tf-new/exp/train_phn_l5_c280_tf_29o
sample_rate=8k
fbank=make_fbank_pitch

# 8k models from switchboard
#ACWT=0.6
#GRAPH_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/swbd/v1-pitch/data/lang_phn_sw1_fsh_tgpr
#MODEL_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/swbd/v1-pitch/exp/train_phn_l5_c320
#sample_rate=8k
#fbank=make_fbank_pitch

# v2-30ms 16k models from tedlium-release2
ACWT=0.8
# choose one GRAPH_DIR below
# smaller LM, faster decode, less RAM
GRAPH_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/tedlium/v2-30ms/data/lang_phn_test_test_newlm
# most general, largest vocabulary/grammar
#GRAPH_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/tedlium/v2-30ms/data/lang_phn_test
MODEL_DIR?=$(EESEN_MODELS_ROOT)/asr_egs/tedlium/v2-30ms/exp/train_phn_l5_c320_v1s
#sample_rate=16k
#fbank=make_fbank
