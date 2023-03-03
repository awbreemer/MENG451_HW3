function gridGen(lhsTemp, rhsTemp, topTemp, botTemp, sizeA)
    #=
    lhsTemp = 75
    topTemp = 100
    rhsTemp = 50
    botTemp = 0
    sizeA = 9
    =#
    A = zeros(Float64, sizeA, sizeA)
    b = zeros(Float64, sizeA)
    gridSize = Int(sqrt(size(A,1)))
    print("gridsize is " , gridSize)
    curLine = 1
    for i in 1:gridSize
        for j in 1:gridSize
            if isCorner(gridSize, i, j)
                #print("Line " , curLine, " is a corner with i, j: " , i, ",", j)
                processCorner(A, b,  i, j, lhsTemp, rhsTemp, topTemp, botTemp, curLine, gridSize)
            elseif isEdge(gridSize, i, j)
                #print("Line " , curLine, " is a edge with i, j: " , i, ",", j)
                processEdge(A, b, i, j, lhsTemp, rhsTemp, topTemp, botTemp, curLine, gridSize)
            else
                #print("Line " , curLine, " is a center with i, j: " , i, ",", j)
                processCenter(A, i, j, curLine, gridSize)
            end
            curLine += 1
        end
    end
    return A, b
end


function gridToArray(i, j, gridLen)
    return (i-1)*gridLen+j
end


function isCorner(lenA, i, j)
    if (i == 1 || i == lenA) && (j == 1 || j == lenA)
        return true 
    else
        return false 
    end
end


function isEdge(lenA, i, j)
    if (i == 1 || i == lenA || j == 1 || j == lenA)
        return true
    else
        return false
    end
end


function processCorner(A, b, i, j, lhsTemp, rhsTemp, topTemp, botTemp, curLine, gridSize)
    #print(gridSize)
    A[curLine, gridToArray(i, j, gridSize)] = 4
    if i == 1
        A[curLine, gridToArray(i+1, j, gridSize)] = -1
        b[curLine] += lhsTemp
    else
        A[curLine, gridToArray(i-1, j, gridSize)] = -1
        b[curLine] += rhsTemp
    end
    if j == 1
        A[curLine, gridToArray(i, j+1, gridSize)] = -1
        b[curLine] += botTemp
    else
        A[curLine, gridToArray(i, j-1, gridSize)] = -1
        b[curLine] += topTemp
    end

end

function processEdge(A, b, i, j, lhsTemp, rhsTemp, topTemp, botTemp, curLine, gridSize)
    A[curLine, gridToArray(i, j, gridSize)] = 4
    if i == 1
        A[curLine, gridToArray(i+1, j, gridSize)] = -1
        A[curLine, gridToArray(i, j+1, gridSize)] = -1
        A[curLine, gridToArray(i, j-1, gridSize)] = -1
        b[curLine] = lhsTemp
    elseif j == 1
        A[curLine, gridToArray(i+1, j, gridSize)] = -1
        A[curLine, gridToArray(i-1, j, gridSize)] = -1
        A[curLine, gridToArray(i, j+1, gridSize)] = -1
        b[curLine] = botTemp
    elseif i == gridSize
        A[curLine, gridToArray(i-1, j, gridSize)] = -1
        A[curLine, gridToArray(i, j+1, gridSize)] = -1
        A[curLine, gridToArray(i, j-1, gridSize)] = -1
        b[curLine] = rhsTemp
    elseif j == gridSize
        A[curLine, gridToArray(i+1, j, gridSize)] = -1
        A[curLine, gridToArray(i-1, j, gridSize)] = -1
        A[curLine, gridToArray(i, j-1, gridSize)] = -1
        b[curLine] = topTemp
    end
end

function processCenter(A, i, j, curLine, gridSize)
    A[curLine, gridToArray(i, j, gridSize)] = 4
    A[curLine, gridToArray(i+1, j, gridSize)] = -1
    A[curLine, gridToArray(i-1, j, gridSize)] = -1
    A[curLine, gridToArray(i, j+1, gridSize)] = -1
    A[curLine, gridToArray(i, j-1, gridSize)] = -1
end

#=

A, b = gridGen(75, 50, 100, 0, 25);
display(A)  
display(b)

initialGuess = zeros(Float64, 25, 1)

x = SOR(A, b, .5, initialGuess, 1e-6)

x[Int(floor(length(x)/2+1))]

xnew = reshape(x, 5, 5)

contour(xnew, fill = true)

=#