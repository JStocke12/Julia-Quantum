using Plots
using LinearAlgebra

Ψ = Vector{ComplexF64}(undef, 100)

#Ψ = [ℯ^((i/10)*1im-(i/10-2.5)^2)/(10*sqrt(pi))+ℯ^((i/10)*-1im-(i/10-7.51)^2)/(10*sqrt(pi)) for (i,x) in enumerate(Ψ)]

#=a = Vector{ComplexF64}(undef, 100)

a = [ℯ^((i/10)*1im-(i/10-2.5)^2)/(10*sqrt(pi)) for i in 1:50]

Ψ = [i<51 ? a[i] : a[101-i] for (i,x) in enumerate(Ψ)]=#

#Ψ = [sin(i*pi/101)/(pi*202) for i in 1:length(Ψ)]

#Ψ = convert(Vector{ComplexF64}, [i < 50 ? sin(i*pi/49)/(pi*49*2) : 0 for i in 1:length(Ψ)])

#V = [(i == 50 || i == 51) ? 1 : 0 for i in 1:length(Ψ)]

delta_x = 20/99

x = [-10+(i-1)*delta_x for i in 1:100]

#Ψ = [delta_x/sqrt(sqrt(pi))*ℯ^(-(x[i]^2)/2) for i in 1:100]

lambda = 1/(2*delta_x^2)

V = [(x[i]^2)/2+48.5 for i in 1:length(Ψ)]

H = lambda*[i==j ? 2.0-V[i]/lambda : (i==j+1 || i+1==j) ? -1.0 : 0.0 for i in 1:length(Ψ), j in 1:length(Ψ)]

#U(t) = (I-0.5im*t*H)*inv(I+0.5im*t*H)

Ψ = [eigvecs(H)[i,100]+eigvecs(H)[i,98] for i in 1:100]

print(dot(Ψ,H*Ψ))

U(t, Ψ) = (I+0.5im*t*H)\((I-0.5im*t*H)*Ψ)

anim = @animate for t in 0:1:100
    global Ψ
    plot(1:100,abs2.(Ψ))
    #plot(1:100,Ψ)
    #plot(1:100,real.(Ψ))
    Ψ = U(0.1, Ψ)
end

gif(anim, "psi2plot.gif", fps=15)