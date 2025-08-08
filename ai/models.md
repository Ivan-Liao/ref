# GPT 3
## Architecture
1. Embeddings matrix
   1. 50k words / tokens (50257)
   2. 12288 dimensions
   3. total 617 million weights / parameters
2. Attention layers
   1. context size = 2048 tokens
   2. 12288 dimensions
3. Unembedding layer
   1. If embedding matrix size is m x n then unembedding is n x m
   2. 50k rows corresponding to the 50k words / tokens
   3. 12288 columns to enable dot product and softmax function to get probability of word
   4. total 617 million weight / parameters
   5. Temperature is a hyper parameter
      1. low T results in higher weight domination
      2. high T results in more lower weight representation
   6. Layer before Unembedding layer contain the "logits"