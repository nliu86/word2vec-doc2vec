Embedding vector for word, query, sentence and paragraph

I’ve played with word2vec for almost a year and learned a great deal. I’d like to share my experiences here to help others to better use this powerful tool:
1.	Word vector
a.	It’s a little bit challenging to figure out the best training parameters for word2vec. Fortunately, Levy & Goldberg’s paper pointed us to the right direction:
Improving Distributional Similarity with Lessons Learned from Word Embeddings
From their paper:
•	SGNS(Skip-Grams with Negative Sampling) is a robust baseline. While it might not be the best method for every task, it does not significantly underperform in any scenario. Moreover, SGNS is the fastest method to train, and cheapest (by far) in terms of disk space and memory consumption.
•	With SGNS, prefer many negative samples.
My own experience with word2vec + deep learning also shows SGNS (cbow=0 and hs=0) is the best option.
b.	For SGNS, here is what I believe really happens during the training:
If two words appear together, the training will try to increase their cosine similarity. If two words never appear together, the training will reduce their cosine similarity. So if there are a lot of user queries such as “auto insurance” and “car insurance”, then “auto” vector will be similar to “insurance” vector and “car” vector will also be similar to “insurance” vector. Eventually “auto” vector will be very similar to “car” vector because both of them are similar to “insurance”, “loan” and “repair” vector. This intuition will be useful if you want to better design your training data to meet the goal of your information retrieval task.
2.	Query vector
A query usually has 1-10 words. I have implemented and tried two query vector predictors.
a.	Sentence vector based on Quoc Le & Tomas Mikolov’s paper: Distributed Representations of Sentences and Documents 
b.	Avg predictor by averaging the word vectors of each word in a query. You can check out source code here
https://github.com/nliu86/Fixed-length-vector-predictor-for-text
The avg predictor is implemented in multi-thread and is super-fast. For my experiment with word2vec + deep learning, avg predictor slightly beats sentence vector.
3.	Sentence and paragraph vector
We have to set our expectation reasonable here: there exists no such magic to accurately transform sentence and paragraph with infinite possibilities into 300-dimension vector. Can you image we spit out 300 random numbers instead of saying a whole sentence to convey our meaning?  For word and phrase, since they appear in a lot of contexts, we can exploit those contexts. However, for sentence and paragraph, they usually only appear once in training corpus. The only thing we can exploit is to use the relationship between sentence and the words in it. By doing so, we get something that’s similar to the avg predictor mentioned earlier. So for sentence and paragraph, the best way to represent them is to first remove all the stop words. Then for the rest words, pick a dominant word set and use avg predictor for the dominant word set. If we don’t pick dominant word set, avg predictor will average every word in the sentence and the resulted vector will be super noisy. I’ve used a special training data to train word2vec and then used vector clustering to pick dominant word sets from this article: Disneyland Bought Extra Land For A Billion-Dollar Park Expansion. The sets look like [disney disneyland park] and [disney disneyland star_wars], which are good enough for my purpose.
4.	Tri-letter gram vector
Another way to use word2vec is to transform training data into tri-letter gram format. Say if we have a query called “best hotel deal”. We can transform it into “bes est hot ote tel dea eal”. Then use word2vec to train vector for each tri-letter gram. If we combine this with query avg predictor and deep learning, we will get something that’s similar to DSSM, but much simpler:
Learning Deep Structured Semantic Models for Web Search using Clickthrough Data
Tri-letter gram vector can be useful in detecting meanings of misspellings, unknown words and domain names. For example, if someone types “cooool”, we can figure out its meaning is similar to “cool”.
5.	Embedding vectors and deep learning
Embedding vectors are married to deep learning. Without deep learning, we lose a lot of benefits of embedding vectors. For my predictive modeling problem with 1TB training data and 200 million rows, deep-learning-based model outperforms simple neural network model by about 10%. 

In summary, here is what I recommend if you plan to use word2vec: choose the right training parameters and training data for word2vec, use avg predictor for query, sentence and paragraph(code here) and apply deep learning on resulted vectors.
