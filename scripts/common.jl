using befwm
using Gadfly
using DataFrames

function distrmax(x)
    return mean(x) .+ std(x)
end

function distrmin(x)
    return mean(x) .- std(x)
end

