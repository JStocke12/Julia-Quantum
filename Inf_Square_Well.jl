using Plots
using QuadGK

function StationaryState(x,t,n)
    sqrt(2)*sin(n*pi*x)*ℯ^(-1im*n^2*pi^2*0.5*t)
end

function psi(x,t,coff)
    sum(map(n -> sqrt(coff[n])*StationaryState(x,t,n), 1:length(coff)))
end

@userplot Psi2Plot
@recipe function f(ps::Psi2Plot)
    t, numpts, coff = ps.args
    xs = range(0, 1, length = numpts)
    ys = map(x -> abs2(psi(x,t,coff)), xs)

    ylims --> (0, 4.0)

    xs, ys
end

function fourierCoefs(f, maxCoffNum)
    map(n -> abs2(quadgk(x -> sqrt(f(x))*StationaryState(x,0,n), 0, 1)[1]), 1:maxCoffNum)
end

lst = fourierCoefs(x -> -120*x*(x-1)*(x-0.5)^2, 50)

anim = @animate for t in 0:0.01:1
    plot(Psi2Plot((t, 100, lst)))
end

gif(anim, "psi2plot.gif", fps=15)