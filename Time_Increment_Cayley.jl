using Plots
using LinearAlgebra

Ψ = Vector{ComplexF64}(undef, 100)

#Ψ = [ℯ^((i/10)*10im-(i/10-5)^2)/(10*sqrt(pi)) for (i,x) in enumerate(Ψ)]

Ψ = [ℯ^((i/10)*10im-(i/10-2.5)^2)/(10*sqrt(pi))+ℯ^((i/10)*-10im-(i/10-7.5)^2)/(10*sqrt(pi)) for (i,x) in enumerate(Ψ)]

H = [i==j ? 2 : (i==j+1 || i+1==j) ? -1 : 0 for i in 1:length(Ψ), j in 1:length(Ψ)]

U(t) = (I-0.5im*t*H)*inv(I+0.5im*t*H)

print(abs2(det(U(0.1))))

anim = @animate for t in 0:0.1:30
    global Ψ
    plot(1:100,abs2.(Ψ))
    #plot(1:100,Ψ)
    Ψ = U(0.1)*Ψ
end

gif(anim, "psi2plot.gif", fps=15)