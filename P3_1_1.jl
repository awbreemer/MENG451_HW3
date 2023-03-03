using Pkg 

using LinearAlgebra

using Plots

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

print(b)

x = A\b

newx = zeros(Float64, 3, 3)
newx[1,:] = x[1:3]
newx[2,:] = x[4:6]
newx[3,:] = x[7:9]

boarder = zeros(Float64, 5,5)
boarder[1,:] = [87.5 100 100 100 75]
boarder[2,:] = [ 75 x[1:3]' 50]
boarder[3,:] = [75 x[4:6]' 50]
boarder[4,:] = [75 x[7:9]' 50]
boarder[5,:] = [75/2 0 0 0 25]

reverse(boarder, dims = 1) 

contour(boarder, fill=true)

xForLater = x

##PART 2

eigStuff = eigen(A)
eigVals = eigStuff.values
K =  maximum(eigVals)/minimum(eigVals)

cond(A)

##PART 3

function myBiCSTAB(A, xInitialGuess, b, xForLater, tolerance = 1e-6)
    
    x = xInitialGuess
    r = b-A*x
    r0hat = r
    if(dot(r0hat,r) == 0)
        print("You fucked up")
    end

    rhoPrev = 1
    alpha = 1
    omega = 1


    v = zeros(Float64, 9, 1)
    p = zeros(Float64, 9, 1)

    rho = 0.
    beta = 0.
    h = 0.
    s = 0.
    t = 0.

    residual = Vector([])


    while(true)
        print("\niterate\n")
        push!(residual,norm(r))
        rho = dot(r0hat, r)
        beta = (rho / rhoPrev) * (alpha / omega)
        p = r + beta*(p-omega*v)
        v = A*p
        alpha = rho / dot(r0hat, v)
        h = x + alpha*p
        if(norm(h-xForLater) < 1e-6)
            x = h
            break
        end
        s = r - alpha*v
        t = A*s
        omega = dot(t,s)/dot(t,t)
        x = h + omega*s
        if(norm(x-xForLater) < 1e-6)
            break
        end
        r = s-omega*t
        rhoPrev = rho
    end
    return(x, residual)
end

x = zeros(Float64, 9, 1)

answer = myBiCSTAB(A, x, b, xForLater)
display(answer[1])
plot(answer[2])