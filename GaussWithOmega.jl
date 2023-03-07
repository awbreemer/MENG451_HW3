## 
using Printf
using LinearAlgebra
using Plots

function gaussSeidel(nx,ny, tol, maxIter, T0, w; verbose=false)

    T = copy(T0)
    residuals = zeros(nx,ny)

    flag = 0
    iter = 0
    while flag == 0
        iter += 1 # iter = iter + 1

        # update all the open values of T
        # T[i,j] = 1/4*( T[i+1,j] + T[i-1,j] + T[i,j+1] + T[i,j-1]  )

        # Gauss-Seidel (no Tnew)
        for i = 2:nx-1
            for j = 2:ny-1
                Ts = 1/4*( T[i+1,j] + T[i-1,j] + T[i,j+1] + T[i,j-1]  )
                T[i,j] = (1-w)*T[i,j] + w*Ts
            end
        end
        
        for i = 2:nx-1
            for j = 2:ny-1
                residuals[i,j] = T[i+1,j] + T[i-1,j] + T[i,j+1] + T[i,j-1] - 4*T[i,j]
            end
        end

        if verbose
            @printf("iter=%3d, |res|=%.3e\n", iter, norm(residuals))
        end

        if norm(residuals) <= tol
            flag = 1
        elseif iter >= maxIter
            flag = -1
            error("Failed to converge")
        end

    end

    return (T, iter)
end


function createBoarder(topTemp, botTemp, lhsTemp, rhsTemp, gridSize)
    grid = zeros(gridSize, gridSize)
    for i in 1:size(grid, 1)
        grid[1,i] = topTemp
        grid[size(grid,1),i] = botTemp
        grid[i,1] = lhsTemp
        grid[i,size(grid,1)] = rhsTemp       
    end
    return grid
end

function getGridCenter(grid)
    centerDistance = Int(floor(size(grid,1)/2)+1)
    return grid[centerDistance,centerDistance]
end

function getBIG()
    converged = false
    i = 5

    centerTemps = [0.0]
    resids = Float64[]
    while !converged
        thisGrid = createBoarder(100,0,75,50,i)
        tempgrid, numIts =  gaussSeidel(i,i,1e-6,30,thisGrid,1.5)
        if abs( getGridCenter(tempgrid)-centerTemps[Int(length(centerTemps))]) < 1e-4
            converged = true
        end
        push!(centerTemps, getGridCenter(tempgrid))
        push!(resids,abs(centerTemps[length(centerTemps)] - centerTemps[length(centerTemps)-1]))
        i += 2
    end
    plot(resids)
    
end

getBIG()

    

heatMatrix, iters = gaussSeidel(7, 7, 1e-6, 30, createBoarder(100, 0, 75, 50, 7), 1.5)
contour(reverse(heatMatrix, dims = 1), fill = true)


 ##T, iter = gaussSeidel(nx,ny,tol, maxIter, T0)

