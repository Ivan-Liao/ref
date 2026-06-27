# Algorithms
1. PPO (Proximal Policy Optimization)
   1. Value-based reinforcement learning method: learning an action-value function that will tell us the most valuable action to take given a state and action.
   2. Policy-based reinforcement learning method: learning a policy that will give us a probability distribution over actions.

# Vocab
1. Action spaces
   1. set of all valid actions
   2. Can be discrete like Go
   3. Can be continuous like movement
2. Advantage functions
   1. How much better a function is compared to others
3. Agent Environment interaction loop
   1. Agent >> Action (on)>> Environment >> State and Reward (transfered to)>> Agent
4. Bellman Equations
   1. The value of your starting point is the reward you expect to get from being there, plus the value of wherever you land next.
5. Exploration exploitation tradeoff
   1. Restaurant example...the usual place vs a new grand opening...known reward vs probably high reward
6. Expected Return
7. Optimal Q function and action
8. Policy
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
9.  Reward and return
   1. Reward functions
      1. Dependent on current state, action, and next state
      2. finite-horizon undiscounted return
         1. finite time, return is not discounted / decayed
      3. infinite-horizon discounted return
         1. no time horizon, more time taken is discounted / decayed
   2. Discount rate gamma
      1. Between 0 and 1, usually .95-.99
10. States and Observations
   1. Observation
      1. Partial description of the state, which may omit info
      2. e.g. RGB matrix of pixel values for image
      3. "partially observed"
   2. State
      1. State is the complete description of the world, nothing is omitted
      2. e.g. robot's collection of joint angles and velocities
      3. "fully observed"
   3. Described as vectors, matrices, or tensors
11. Trajectory / Episodes / Rollout
   1. Sequence of states and actions in the world
12. Value Function
    1.  On-policy value function
    2.  On-policy action-value function
        1.  Expected return after endlessly applying policy
    3.  Optimal Value function
    4.  Optimal Action-value function