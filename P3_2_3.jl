using Pkg
using Noise
using Plots
using CSV
using DataFrames

function modelFunction( x, a)
    a[1]  + a[2]*x
end

function changeZeroOneArray(onesPlace, arr)
    arr[:] .= 0
    arr[onesPlace] = 1
    return arr
end


function buildX(f, x, n)
    X = zeros(Float64, length(x), n)
    zeroOneArray = zeros(Int, n)
    for i in 1:length(x)
        for j in 1:n
            changeZeroOneArray(j, zeroOneArray)
            X[i, j] = f(x[i], zeroOneArray)
        end
    end
    return X
end

## Part 4

function myCurveFit( X, y)
    a = (transpose(X) * X)^-1 * transpose(X) * y
    return a
end

## Part 5

#=

x = [0.01:.01:10;]
y = 2  .+ 1.2 .* x

yWNoise = poisson(y, 100)

plot(x,[y, yWNoise])


a = myCurveFit(buildX(modelFunction, x, 2), yWNoise)

newYs = x .* a[2] .+ a[1]
display(a)
plot(x, [y, yWNoise, newYs])


=#

digitizerResultsFrame = DataFrame(CSV.File("curvePoints.csv"))
plot(digitizerResultsFrame[:,1], digitizerResultsFrame[:,2])


## Part 6

function Cnum(i, j)
    if i == 0 && j == 1
        return 1
    elseif i == 1 && j == 0
        return 2
    elseif i == 1 && j == 1
        return 3
    elseif i == 2 && j == 0
        return 4
    elseif i == 0 && j == 2
        return 5
    end
end

function modelFunctionrubber( λ, C)
    result =  2*(λ-λ^-2) * (C[Cnum(1,0)] + C[Cnum(0,1)] * λ^-1 + 2*C[Cnum(2,0)]*(λ^2 + 2*λ^-1 - 3) + 2*C[Cnum(0,2)]*(2*λ + λ^-2 - 3) + 3 * C[Cnum(1,1)] * (λ - 1 - λ^-1 + λ^-2))
    return result
end

function evaluateRubber()
    alpha = [1:.1:7.5;]

    avals = myCurveFit(buildX(modelFunctionrubber, digitizerResultsFrame[:,1], 5), digitizerResultsFrame[:,2])

    resultYs = zeros(Float64, length(digitizerResultsFrame[:,1]))
    for i in 1:length(digitizerResultsFrame[:,1])
        resultYs[i] = modelFunctionrubber(alpha[i], avals)
    end

    plot(digitizerResultsFrame[:,1], [digitizerResultsFrame[:,2], resultYs])


end
