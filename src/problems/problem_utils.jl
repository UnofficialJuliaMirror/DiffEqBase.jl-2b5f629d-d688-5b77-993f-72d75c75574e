promote_tspan(tspan::Tuple{T,T}) where T = tspan
function promote_tspan(tspan::Tuple{T1,T2}) where {T1,T2}
  T = promote_type(map(typeof,tspan)...)
  (map(T,tspan)...,)
end
promote_tspan(tspan::Number) = (zero(tspan),tspan)
promote_tspan(tspan::Nothing) = (nothing,nothing)

### Displays

Base.summary(prob::DEProblem) = string(parameterless_type(prob)," with uType ",typeof(prob.u0)," and tType ",typeof(prob.tspan[1]),". In-place: ",isinplace(prob))
Base.summary(prob::AbstractSteadyStateProblem{uType,iip}) where {uType,iip} = string(parameterless_type(prob)," with uType ",uType)
Base.summary(prob::AbstractNoiseProblem) = string(parameterless_type(prob)," with WType ",typeof(prob.noise.W[1])," and tType ",typeof(prob.tspan[1]),". In-place: ",isinplace(prob))
function Base.show(io::IO, A::DEProblem)
  println(io,summary(A))
  print(io,"timespan: ")
  show(io,A.tspan)
  println(io)
  print(io,"u0: ")
  show(io, A.u0)
end
function Base.show(io::IO, A::AbstractNoiseProblem)
  println(io,summary(A))
  print(io,"timespan: ")
  show(io,A.tspan)
  println(io)
end
function Base.show(io::IO, A::AbstractDAEProblem)
  println(io,summary(A))
  print(io,"timespan: ")
  show(io,A.tspan)
  println(io)
  print(io,"u0: ")
  show(io, A.u0)
  println(io)
  print(io,"du0: ")
  show(io, A.du0)
end
function Base.show(io::IO, A::AbstractSteadyStateProblem)
  println(io,summary(A))
  print(io,"u0: ")
  show(io, A.u0)
end

Base.summary(prob::AbstractMonteCarloProblem) = string(DiffEqBase.parameterless_type(prob)," with problem ",DiffEqBase.parameterless_type(prob.prob))
Base.show(io::IO, A::AbstractMonteCarloProblem) = print(io,summary(A))