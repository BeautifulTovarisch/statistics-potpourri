@doc raw"""
Weather Report

This script simulates a 3-state markov chain modelling the weather of a city.
There are three states the weather can exhibit:

  1. Fine
  2. Cloudy
  3. Rain

We use a 3x3 transition matrix to describe the probability distribution of each
transition into another weather state:

|Current      |Next      |Probability|
|:------------|:---------|----------:|
|Fine         |Fine      |0.50       |
|Fine         |Cloudy    |0.40       |
|Fine         |Rain      |0.10       |
|Cloudy       |Cloudy    |0.20       |
|Cloudy       |Fine      |0.30       |
|Cloudy       |Rain      |0.50       |
|Rain         |Cloudy    |0.20       |
|Rain         |Cloudy    |0.30       |
|Rain         |Cloudy    |0.50       |

This table is then converted to a Transition matrix which serves as the input
for a few analytical methods:

1. Raising P^n, where n is some high number simulates taking its limit
2. Solving a linear system:

```math
\piP = \pi and \sum_{i=1}^3 \pi_{i} = 1
```

which is organized into a matrix:

```math
\begin{bmatrix}
P_{11} - 1 & P_{21}       & P_{31} \\
P_{12} - 1 & P_{22} - 1   & P_{32} \\
1          & 1            & 1      \\
\end{bmatrix}
\begin{bmatrix}
\pi_1 \\
\pi_2 \\
\pi_3
\end{bmatrix}
=
\begin{bmatrix}
0 \\
0 \\
1
\end{bmatrix}
```

3. Eigenvectors vis-a-vis Perron Frobenius theorem
4. Straight up Monte Carlo simulation
"""
module WeatherReport
using LinearAlgebra, StatsBase

P = [0.5 0.4 0.1;
     0.3 0.2 0.5;
     0.5 0.3 0.2]

"""
Raise matrix `P` to the `k`th power and returns an arbitrary row containing the
steady-state markov distribution.
"""
function MatrixPower(k)
  # TODO: Benchmark diagonalization against this direct method.
  return (P^100)[1,:]
end

# Method 4: Monte Carlo simulation


"""
Performs `N` iterations of a Monte Carlo simultation according to the
probability distributions in `P`
"""
function MonteCarlo(N)
  # Create a 0-vector to represent each state
  numInState = zeros(Int, 3)
  state =1

  for t in 1:N
    numInState[state] += 1
    state = sample(1:3, weights(P[state, :]))
  end

  return numInState / N
end
end
