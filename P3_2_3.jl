using Pkg
using Noise
using Plots
using CSV
using DataFrames

function modelFunction( x, a)
    return a[1]  + a[2]*x + a[3]*x^2
    end

function changeZeroOneArray(onesPlace, arr)
    arr[:] .= 0
    arr[onesPlace] = 1
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
yourmom = (buildX(modelFunction, x, 3))



x = LinRange(0,10,3000)
y = 3 .* x.^2  .+ 2 .* x .+ 1

yWNoise = add_gauss(y, 10)

plot(x,[ yWNoise])


a = myCurveFit(buildX(modelFunction, x, 3), yWNoise)

newYs = x.^2 .* a[3] .+ x .* a[2] .+ a[1]
display(a)
plot(x, [yWNoise, newYs])
=#



digitizerResultsFrame = DataFrame(CSV.File("curvePoints3.csv"))
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
    avals = myCurveFit(buildX(modelFunctionrubber, digitizerResultsFrame[:,1], 5), digitizerResultsFrame[:,2])

    resultYs = zeros(Float64, length(digitizerResultsFrame[:,1]))
    for i in 1:length(digitizerResultsFrame[:,1])
        resultYs[i] = modelFunctionrubber(digitizerResultsFrame[i,1], avals)
    end

    plot(digitizerResultsFrame[:,1], [digitizerResultsFrame[:,2], resultYs])
    #return avals

end

evaluateRubber()
display(aval)
