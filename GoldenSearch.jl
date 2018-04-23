
function GoldenSearch(Func::Function,Direct,X;Tol=1e-6,MaxIter=100,MaxIterB=50,α=2.0)
#needs more comments

α0 = α
Srnk = 0.7                                                                      #Shrink coefficient
Expnd = 1.3                                                                     #Expanding factor
ϕ = (1 + sqrt(5))/2                                                             #Golden Ratio (1.618)

FlBracket = Func(X)                                                             #First function evaluation for bracketing procedure
XiB = X + α*Direct
FiBracket = Func(XiB)                                                           #Intermediate function evaluation for bracketing procedure


## Finding the first point in which the function is smaller than its starting point
iter = 0
while ((FiBracket >= FlBracket) & (iter <= MaxIterB))
    α = α*Srnk
    XiB = X + α.*Direct
    FiBracket = Func(XiB)
    iter += 1
end

if (iter >= MaxIterB)
    println("Can't find a lower function value for given α - Probably not a Descent Direction")
    return
end

α = α0
XuB = XiB + α.*Direct
FuBracket = Func(XuB)


## Finding first point in which the function starts to grow again (closing interval)
iter = 0
while ((FuBracket <= FiBracket) & (iter <= MaxIterB))
    α = α*Expnd
    XuB = XiB + α.*Direct
    FuBracket = Func(XuB)
    iter += 1
end


if (iter >= MaxIterB)
    println("Can't find a greater function value for given α - Probably lost a viable interval, try lowering α value")
    return
end

XUpper = XuB                                                                    #Upper Bracket X
XLower = X                                                                      #Lower Bracket X
XiL = (XUpper - XLower)/(1+ϕ) + XLower                                          #Lower Intermediate X
XiU = ϕ*(XUpper - XLower)/(1+ϕ) + XLower                                        #Upper Intermediate X

iter = 0
while ((norm(XUpper-XLower) >= Tol) & (iter <= MaxIter))

    FiL = Func(XiL)
    FiU = Func(XiU)

    if FiL<FiU
        XUpper = XiU
        XiU = XiL
        XiL = (XUpper - XLower)/(1+ϕ) + XLower
    else
        XLower = XiL
        XiL = XiU
        XiU = ϕ*(XUpper - XLower)/(1+ϕ) + XLower
    end

    iter += 1

end

return (XiL+XiU)/2.0

end
