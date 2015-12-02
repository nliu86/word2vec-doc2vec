
Notes:
Use word2vec to train word vectors from documents, which can be wikipedia articles or a query list, or a document list.
Parameter values have been chosen to train SGNS (skip gram negative sampling with cbow=0 and hs=0), which has shown very good performance based on Levy &
Goldberg’s paper: https://levyomer.files.wordpress.com/2015/03/improving-distributional-similarity-tacl-2015.pdf
Their paper pointed out that word2vec’s superiority lies in its clever chosen hyperparameters:
--SGNS(Skip-Grams with Negative Sampling) is a robust baseline. While it might not be the best method for every task, it does not significantly underperform in any   scenario. Moreover, SGNS is the fastest method to train, and cheapest (by far) in terms of disk space and memory consumption.
--With SGNS, prefer many negative samples.
My own experience with word2vec + deep learning also shows SGNS is the best option.

After word2vec models are trained, we can use them to predict vectors for new queries using the multi-threaded query2vec predictor.
I tried two predictors, one is called sentence vector based on Quoc Le & Tomas Mikolov’s paper: Distributed Representations of Sentences and Documents: http://cs.stanford.edu/~quocle/paragraph_vector.pdf
The other one is the avg predictor by averaging the word vectors of each word in a query, which is implemented in query2vec.c
In my experiment with word2vec + deep learning, the avg predictor slightly beats sentence vector.

For long sentence or document, it's best to extract dominant query set first before taking average of word vectors, which can be acomplished by word2vec + clustering.

The vectors for query, sentence or document are most suited for deep learning instead of shallow learning such as logistic regression.
I have used word2vec + deep learning to beat significantly my already very good baseline.
