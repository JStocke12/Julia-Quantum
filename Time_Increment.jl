using Plots
using AutoGrad
using Interpolations

Ψ(x::ComplexF64) = exp((x*0.1)im-(x*0.1)^2)

print()

H(a) = a

print(ForwardDiff.derivative(Ψ, 1.0+0.0im))

#=
plot(-10:10,abs2.(H(Ψ)))

savefig("psi2plot.png")
=#

anim = @animate for t in 0:0.01:1
    global Ψ
    plot(-10:10,abs2.(H(Ψ)))
    Ψ += -im*H(Ψ)
end

gif(anim, "psi2plot.gif", fps=15)