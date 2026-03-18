# Alphabetized List

1. **Candidate_count (x)**  
   1. Chooses x distinct complete answers instead of just 1  
2. **context window**
3. **Frequency penalty (-2 to 2)**  
   1. Frequency Penalty controls how much the model avoids repeating the same words or phrases in its output
4. Precision
   1. When the model predicted the positive class, what percentage of the predictions were correct?
   2. True positives / (true positives + false positives)
5. **Presence penalty (-2 to 2)**  
   1. not cumulative like frequency penalty  
6. **prompt engineering**  
   1. Role  
      1. Act as an astrophysicist and explain black holes to a high school student.  
   2. Format  
      1. List the planets in our solar system. Format the output as a two-column table with the planet's name in the first column and its distance from the sun in the second.  
   3. Context  
      1. "Here is a transcript of our project kickoff meeting held on August 7th. [Paste Transcript]. Summarize the key decisions made and the action items assigned."  
   4. Task  
      1. The AI is optimized to respond to commands. Words like "summarize," "translate," "classify," "generate," or "analyze" are direct instructions it understands well.  
   5. Tone  
      1. You can request a "formal and professional" tone for a business email, a "witty and humorous" tone for a social media post, or an "empathetic and caring" tone for a customer service reply.  
   6. Exemplars  
   7. CoT  
      1. Chain of thought request  
      2. A bat and a ball cost $1.10 in total. The bat costs $1.00 more than the ball. How much does the ball cost? Explain your reasoning step-by-step.  
   8. Constraints  
   9. Audience  
   10. Length  
7.  Recall
   1.  When ground truth was the positive class, what percentage of predictions did the model correctly identify as the positive class?
      1. true positives / (true positives + false negatives)
8. **Seed (x)**  
   1. Helps keep a deterministic output  
9. **Temperature (0-2)**  
   1. temperature parameter controls the diversity and randomness of generated outputs  
   2. Low (0.1): "The capital of France is Paris." (Predictable, conservative).  
   3. High (1.5): "Paris, that city of, well, lights and, uh, croissants, is surely, arguably, France's, you know, capital." (Creative, random)  
10. **token**  
   1. A simple, common word like "the" or "cat" is usually 1 token. A more complex word like "language" might be broken into two tokens (e.g., "lang" + "uage"). Punctuation marks like periods and commas are also tokens.  
   2. A useful rule of thumb for English text is that 1 token is approximately 0.75 words or about 4 characters.  
11. **Top_k=20 (x)**  
   1. chooses from top x most probable next tokens  
12. **Top_p (0-1)**  
   1. Limits options to only the most likely, cutting off the "tail" of unpredictable words. Keeping 0-100% of the probability mass of tokens  