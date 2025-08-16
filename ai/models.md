# Leaderboards
1. Contestants
   1. Gemini Pro (Google)
   2. ChatGPT (OpenAI)
   3. Llama (Meta)
   4. Grok
   5. Claude (Anthropic)
   6. Nova (Amazon)
   7. Deepseek
2. 202508
   1. Gemini Pro
   2. GPT5
   3. Claude
   4. Llama
   
# Architecture
## GPT3
1. Embeddings matrix
   1. config 
      1. 12288 dimensions
      2. 50k words / tokens (50257)
      3. total 617 million weights / parameters
2. Attention layers 
   1. config
      1. 12288 dimensions
      2. context size = 2048 tokens
      3. total 57 billion parameters
      4. 6.3 million parameters per attention head
      5. 96 multi-head attention layers
   2. single-headed and multi-headed attention
      1. position in context is stored along with attention head (like noun and adjectives in front like fluffly, blue creature)
   3. Matrices
      1. Query matrix (looking for adjectives) 
         1. 12288 columns x 128 rows
      2. Key matrix (answers queries when closely aligns to each other)
         1. 12288 columns x 128 rows
         2. high alignment means the keys for fluffy and blue "attend to" the embedding of creature
         3. masking prevents later tokens to influence earlier ones (set to infinity before softmax to normalize [adds to 0])
      3. value matrix
         1. value down and up (2 step matrices, saves parameters)
            1. essentially number of parameters = number query parameters + number key parameters
            2. "output matrix" is concatenated value up matrices
            3. "value map" is concatenated value down matrices
         2. results in vectors to be added to original embedding vector
   4.  Cross attention heads for language translation due to grammar structure?
3. Unembedding layer
   1. config
      1. 50k rows corresponding to the 50k words / tokens
      2. 12288 columns to enable dot product and softmax function to get probability of word
      3. total 617 million weight / parameters
   2. If embedding matrix size is m x n then unembedding is n x m
   3. Temperature is a hyper parameter
      1. low T results in higher weight domination
      2. high T results in more lower weight representation
   4. Layer before Unembedding layer contain the "logits"