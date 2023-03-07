using Pkg; Pkg.activate(".")
using LinearAlgebra
using Plots


function SOR(A, b, omega, initial_guess, convergence_criteria)
    step = 0
    phi = copy(initial_guess)
    residual = norm((A*phi) - b)
    while(residual > convergence_criteria)
        for i in 1:size(A)[2]
            sigma = 0
            for j in 1:size(A)[1]
                if j != i
                    sigma += A[i,j] * phi[j]
                end
            end
            phi[i] = (1 - omega) * phi[i] + (omega / A[i, i]) * (b[i] - sigma)
        end
        residual = norm((A*phi) - b)
        step += 1
        #print("Step " , string(step) , " Residual " , string(residual))
    end
    return phi
end

#=
A = zeros(Float64, 9,9)
A[1,:] = [4, -1, 0, -1, 0, 0, 0, 0, 0]
A[2,:] = [-1, 4, -1, 0, -1, 0, 0, 0, 0]
A[3,:] = [0, -1, 4, 0, 0, -1, 0, 0, 0]
A[4,:] = [-1, 0, 0, 4, -1, 0, -1, 0, 0]
A[5,:] = [0, -1, 0, -1, 4, -1, 0, -1, 0]
A[6,:] = [0, 0, -1, 0, -1, 4, 0, 0, -1]
A[7,:] = [0, 0, 0, -1, 0, 0, 4, -1, 0]
A[8,:] = [0, 0, 0, 0, -1, 0, -1, 4, -1]
A[9,:] = [0, 0, 0, 0 ,0, -1, 0, -1, 4]

b = [75; 0; 50; 75; 0; 50; 175; 100; 150]

omega = .5
initialGuess = zeros(Float64, 9,1)
convergence = 1e-6

print(SOR(A,b,omega, initialGuess, convergence))
=#

for y in [1,2,3]
    print(y)
end