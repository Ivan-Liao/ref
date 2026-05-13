# Vocab
1. Action spaces
   1. set of all valid actions
   2. Can be discrete like Go
   3. Can be continuous like movement
2. Advantage functions
3. Agent Environment interaction loop
   1. Agent >> Action (on)>> Environment >> State and Reward (transfered to)>> Agent
4. Bellman Equations
5. Optimal Q function and action
6. Policy
   1. Determines which action to take
   2. Can be deterministic (greek mu) or stochastic (greek pi)
      1. deterministic e.g. multilayer perceptron (MLP)
      2. stochastic
         1. Categorical (discrete action spaces)
         2. Diagonal Gaussian (continuous action spaces)
         3. key computations
            1. sampling actions from the policy,
            2. computing log likelihoods of particular actions
   3. Defined by parameters (theta or phi)
7. Reward and return
   1. Reward functions
      1. Dependent on current state, action, and next state
      2. finite-horizon undiscounted return
         1. finite time, return is not discounted / decayed
      3. infinite-horizon discounted return
         1. no time horizon, more time taken is discounted / decayed
8. States and Observations
   1. Observation
      1. Partial description of the state, which may omit info
      2. e.g. RGB matrix of pixel values for image
      3. "partially observed"
   2. State
      1. State is the complete description of the world, nothing is omitted
      2. e.g. robot's collection of joint angles and velocities
      3. "fully observed"
   3. Described as vectors, matrices, or tensors
9. Trajectory / Episodes / Rollout
   1. Sequence of states and actions in the world
10. Value Function