"""
Roots

Approximates the roots of polynomial using the Roots package.
"""
module SolveRoots
@doc raw"""
Returns a function representing a polynomial defined by the coefficients of `a`
as follows:

```math
f(x) = a_1 + a_2^x + a_3x^2 + \dots + a_nx^n
```
"""
function PolyGenerator(a...)
	return function(x)
    return sum([a[i+1]*x^i for i in 0:length(a)-1])
	end
end
end

using Roots

# 10x^2 + 3x + 1
polynomial = SolveRoots.PolyGenerator(1, 3, -10)
zeros = Roots.find_zeros(polynomial, -10, 10)

println("f(x) has zeros at ", zeros)
