# #2.5
## Part 1
using LinearAlgebra

σ = 10* [2 5 3
        5 1 4
        3 4 3]

vals = eigvals(σ)

## Part 2
vecs = eigvecs(σ)
display(vecs)

## Part 3 
τmax = (maximum(vals)-minimum(vals))/2

##Part 4
σᵥ = sqrt(1/2*((σ[1,1]-σ[1,2])^2 + (σ[2,2]-σ[3,3])^2 + (σ[3,3] - σ[1,1])^2 + 6*(σ[1,2]^2 + σ[2,3]^2 + σ[3,1]^2)))

##Part 5

        #Redefine σ

̄σ = 