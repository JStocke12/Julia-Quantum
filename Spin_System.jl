using LinearAlgebra
using Kronecker
using Plots

global num_spins = 4

global Ψ = Vector{ComplexF64}(undef, 2^num_spins)

global time_step = 0.001

Ψ[1] = 1

Ψ[3] = 1

M = diagm(0 => map((x, count) -> count_ones(x)*2-count, 0:2^num_spins-1, num_spins*Array{Int}(ones(2^num_spins,1))))

for r in eachrow(M)
    println(r)
end

CNOT = [1 0 0 0; 0 1 0 0; 0 0 0 1; 0 0 1 0]

PAULI_X(n) = kronecker([i == n ? [0 1; 1 0] : [1 0; 0 1] for i=1:num_spins]...)
PAULI_Y(n) = kronecker([i == n ? [0 -1im; 1im 0] : [1 0; 0 1] for i=1:num_spins]...)
PAULI_Z(n) = kronecker([i == n ? [1 0; 0 -1] : [1 0; 0 1] for i=1:num_spins]...)

#https://arxiv.org/pdf/quant-ph/0309188.pdf
SPIN_SWAP = -1*sum([PAULI_X(i)*PAULI_X((i%num_spins)+1)+PAULI_Y(i)*PAULI_Y((i%num_spins)+1)+PAULI_Z(i)*PAULI_Z((i%num_spins)+1) for i=1:num_spins])

println()

for r in eachrow(SPIN_SWAP)
    println(r)
end

H(Ψ, t) = normalize(Ψ-im*t*SPIN_SWAP*Ψ)

Ψ = H(Ψ, 0)
println(Ψ)

Mag_by_time = Vector{Float64}()

for i in 1:100000
    global Ψ = H(Ψ, time_step)
    append!(Mag_by_time, abs(dot(Ψ,M*Ψ)))
end

print([round(i, digits=5) for i in Ψ])

plot((1:100000)*time_step,Mag_by_time)

savefig("Magnetization.png")