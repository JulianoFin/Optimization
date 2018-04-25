function NelderMead(Func::Function, nVariables; MaxIter=100, MultiDimPar=false)
Prints = zeros(nVariables,4,MaxIter)
if MultiDimPar
    α = 1.0; β = 2.0 + 2.0*nVariables
    γ = 0.75 - (0.5/nVariables); δ = 1.0 - (1.0/nVariables)
else
    α = 1.0; β = 2.0; γ = 0.5; δ = 0.5
end

#nVariables = 2
nPoints = 3
Points = [5.0 7.0 7.0; 5.0 5.0 7.0] #rand(nVariables,nPoints)
FuncVal = zeros(nPoints)

for Iter = 1:MaxIter

    for i = 1:nPoints
        FuncVal[i] = Func(Points[:,i])[1]
    end

    IndexOrder = sortperm(FuncVal)
    FuncOrder = sort(FuncVal)

    #Reflection Calculation
    MediumPoint = zeros(nVariables)
    for i = 1:(nPoints-1)
        MediumPoint = MediumPoint + Points[:,IndexOrder[i]]
    end
    MediumPoint = MediumPoint/(nPoints-1)

    Reflection = MediumPoint + α*(MediumPoint - Points[:,IndexOrder[end]])

    if ((FuncOrder[1] <= Func(Reflection)[1]) & (FuncOrder[end-1] > Func(Reflection)[1]))
        Points[:,IndexOrder[end]] = Reflection
    #Expansion condition
    elseif (FuncOrder[1] > Func(Reflection)[1])
        Expansion = MediumPoint + β*(Reflection - MediumPoint)
        if (Func(Reflection)[1] > Func(Expansion)[1])
            Points[:,IndexOrder[end]] = Expansion
        else
            Points[:,IndexOrder[end]] = Reflection
        end
    #Outside Contraction
    elseif ((FuncOrder[end-1] <= Func(Reflection)[1]) & (FuncOrder[end] > Func(Reflection)[1]))
        OutContract = MediumPoint + γ*(Reflection - MediumPoint)
        if (Func(Reflection)[1] > Func(OutContract)[1])
            Points[:,IndexOrder[end]] = OutContract
        else
            for i = 2:nPoints
                Points[:,i] = Points[:,1] + δ*(Points[:,i] - Points[:,1])
            end
        end
    #Inside Contraction
    else
        InContract = MediumPoint - γ*(Reflection - MediumPoint)
        if (FuncOrder[end] > Func(InContract)[1])
            Points[:,IndexOrder[end]] = InContract
        else
            for i = 2:nPoints
                Points[:,i] = Points[:,1] + δ*(Points[:,i] - Points[:,1])
            end
        end
    end

end

end

    
