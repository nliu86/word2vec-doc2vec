
gcc query2vec.c -o word2vec -lm -pthread -O3 -march=native -funroll-loops

num_threads=40
vsize=300

# train vector with a query list file: train.txt
# output model to train_modelfile
#
# don't change the following parameter values:
# cbow =0
# hs = 0
# sentence-vectors = 0
# predict = 0
# print-query = 0

time ./word2vec -train train.txt   -output train_modelfile -cbow 0 -size $vsize -window 10 -negative 10 -hs 0 -sample 1e-3 -threads 40 -binary 0 -iter 10 -min-count 5 -sentence-vectors 0 -predict 0 -alpha 0.025 -ending_alpha 0.005 -save-vocab train_vocabfile -print-query 0

# predict vector for a new query list in train.txt
# word2vec model is in train_modelfile
#
# don't change the following parameter values:
# predict = 1
# read-vocab = train_vocabfile
#
# Only this parameter is really useful:
# print-query
# 
# Don't change values for other parameters.

time ./word2vec -train train.txt   -output train_modelfile -cbow 0 -size $vsize -window 10 -negative 10 -hs 0 -sample 1e-3 -threads 40  -binary 0 -iter 1 -min-count 2 -sentence-vectors 0 -predict 1 -alpha 0.025 -ending_alpha 0.005 -read-vocab train_vocabfile -print-query 0

cat `ls -- train.txt.vectors.0* | sort` > train.tsv
