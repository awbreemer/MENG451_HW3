include("SORfun.jl")
include("GridIncrease.jl")


function iterateGrids()
    newGridSizeBase = 3
    omega = .5
    convCriteriaSOR = 1e-6
    convCriteriaΔGrid = 10^(-6)
    gridCenter = zeros(Float64, 1)
    loopCount = 1
    while(true)
        loopCount += 1
        A, b = gridGen(75, 50, 100, 0, newGridSizeBase^2)
        initGuess = zeros(Float64, newGridSizeBase^2, 1)
        x = SOR(A, b, omega, initGuess, convCriteriaSOR)
        push!(gridCenter, x[Int(floor(length(x)/2)+1)])
        if abs(gridCenter[loopCount] - gridCenter[loopCount - 1]) < convCriteriaΔGrid
            return(x, gridCenter)
        end
        if loopCount > 10
            return(x, gridCenter)
        end
        print("The new grid center value is " , gridCenter[loopCount], " and the old grid center value is ", gridCenter[loopCount - 1], "\n")
        newGridSizeBase += 2
    end
end

function createBoarder(topTemp, botTemp, lhsTemp, rhsTemp, grid)
    newGrid = zeros(size(Grid,1))
    for i in size(grid)
    end
end


x, gridCenter = iterateGrids()
xnew = reshape(x, Int(sqrt(length(x))), Int(sqrt(length(x))))
contour(xnew, fill = true)
display(gridCenter)




    



#=
A, b = gridGen(75, 50, 100, 0, 9)
initialGuess = zeros(Float64,9,1)
x = SOR(A, b, .5, initialGuess, 1e-6)

xSquare = reshape(x, 3,3)
contour(xSquare, fill = true)
=#