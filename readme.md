
How to use deep learning to build a recommendation system or product search engine?
=================
1. Use word2vec/LDA/GloVe to transform natural language and clicks/downloads/purchases/sessions info into feature vectors.
-----------------------

1.	**Word vector**  
  *	It’s a little bit challenging to figure out the best training parameters for word2vec. Fortunately, Levy & Goldberg’s paper pointed us to the right direction:
Improving Distributional Similarity with Lessons Learned from Word Embeddings  
From their paper:  
    *i) SGNS (Skip-Grams with Negative Sampling) is a robust baseline. While it might not be the best method for every task, it does not significantly underperform in any scenario. Moreover, SGNS is the fastest method to train, and cheapest (by far) in terms of disk space and memory consumption.*  
    *ii) With SGNS, prefer many negative samples.*  
My own experience with word2vec + deep learning also shows SGNS (cbow=0 and hs=0) is the best option.
  *	For SGNS, here is what I believe really happens during the training:
If two words appear together, the training will try to increase their cosine similarity. If two words never appear together, the training will reduce their cosine similarity. So if there are a lot of user queries such as “auto insurance” and “car insurance”, then “auto” vector will be similar to “insurance” vector (cosine similarity ~= 0.3) and “car” vector will also be similar to “insurance” vector. Since “insurance”, “loan” and “repair” rarely appear together in the same context, their vectors have small mutual cosine similarity (cosine similarity ~= 0.1). We can treat them as orthogonal to each other and think them as different dimensions. After training is complete, “auto” vector will be very similar to “car” vector (cosine similarity ~= 0.6) because both of them are similar in “insurance” dimension, “loan” dimension and “repair” dimension.   This intuition will be useful if you want to better design your training data to meet the goal of your text learning task.
2.	**Query vector**  
A query usually has 1-10 words. There are 4 ways to generate query vectors. You can use them together or separately.

  * **Use composition**  
   For a query "hotel deal", you can first train vectors for "hotel" and "deal" using all query set. Then vector of "hotel deal" can be represented by taking average of vectors of "hotel" and "deal".

  * **Use downloads/clicks/purchases info**  
   If user searches for a query1, and then clicks an itemA. Gather all the set of (query item) pairs. Then you can train vectors for query and item with word2vec

  * **Use session info**  
   If user searches for query1, query2, query3 in a user session, put (query1 query2 query3) together as a sentence. Then you can train vectors for query1, query2 and query3 with word2vec

  *	**Use tri-letter gram**  
Another way to use word2vec is to transform training data into tri-letter gram format. Say if we have a query called “best hotel deal”. We can transform it into “bes est hot ote tel dea eal”. Then use word2vec to train vector for each tri-letter gram. Query vector is just an average of tri-letter gram vectors.
Tri-letter gram vector can be useful in detecting meanings of misspellings, unknown words and domain names. For example, if someone types “cooool”, we can figure out its meaning is similar to “cool”.


3.	**Sentence and paragraph vector**  
We have to set our expectation reasonable here: there exists no such magic to accurately transform sentence and paragraph with infinite possibilities into 300-dimension vector with word2vec. Can you image we spit out 300 random numbers instead of saying a whole sentence to convey our meaning?  For word and phrase, since they appear in a lot of contexts, we can utilize those contexts. However, for sentence and paragraph, they usually only appear once in training corpus. A better way to represent sentence or paragraph is to use LDA. A major difference between word2vec and LDA is that word2vec treats everything as a single training corpus whereas LDA you have to have multiple documents. In word2vec two words are similar if they appear adjacent to each other very often or have similar contexts. While in LDA two words are similar if they appear together in a lot of documents, thus they belong to the same topic. With LDA, sentence or paragraph can be represented as a vector of topics.

![architecture](https://github.com/nliu86/word2vec-doc2vec/blob/master/architecture.png)

2.  Do high dimension nearest neighbor search to find similar items.
-----------------------
All the vectors above can be used to do high dimension nearest neighbor search to find similar queries, similar items or similar products. We can either use bruteforce or use [NMSLIB](https://github.com/searchivarius/nmslib) to do similarity search.

3. Build a deep learning model using user feedback such as clicks/purchases.
-----------------------
All the feature engineering with word2vec/LDA/GloVe is very useful for deep learning. For machine learning, it is good to have feature that will help machine learning model to memorize but also help it to generalize. Embedding vectors have exactly this kind of property. It's unique: when you see a vector, you know it's associated with a certain item. But this vector has distance measure with other vectors, which help model to generalize to the neighborhood of this vector. For my classification problem with 1TB training data and 200 million rows, deep-learning-based model outperforms simple neural network model by more than 10%. 
