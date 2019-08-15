abstract type AbstractNLSolverAlgorithm end
abstract type AbstractNLSolverCache end

@enum NLStatus::Int8 begin
  FastConvergence     = 2
  Convergence         = 1
  SlowConvergence     = 0
  VerySlowConvergence = -1
  Divergence          = -2
end

# solver

mutable struct NLSolver{algType<:AbstractNLSolverAlgorithm,IIP,uType,rateType,uTolType,gType,cType,C}
  z::uType
  dz::uType
  tmp::uType
  ztmp::uType
  k::rateType
  alg::algType
  ηold::uTolType
  γ::gType
  c::cType
  nl_iters::Int
  status::NLStatus
  cache::C
end

# algorithms

struct NLFunctional{K,C} <: AbstractNLSolverAlgorithm
  κ::K
  fast_convergence_cutoff::C
  max_iter::Int
end

NLFunctional(; κ=1//100, max_iter=10, fast_convergence_cutoff=1//5) = NLFunctional(κ, fast_convergence_cutoff, max_iter)

struct NLAnderson{K,D,C} <: AbstractNLSolverAlgorithm
  κ::K
  fast_convergence_cutoff::C
  max_iter::Int
  max_history::Int
  aa_start::Int
  droptol::D
end

NLAnderson(; κ=1//100, max_iter=10, max_history::Int=5, aa_start::Int=1, droptol=nothing, fast_convergence_cutoff=1//5) =
  NLAnderson(κ, fast_convergence_cutoff, max_iter, max_history, aa_start, droptol)

struct NLNewton{K,C1,C2} <: AbstractNLSolverAlgorithm
  κ::K
  max_iter::Int
  fast_convergence_cutoff::C1
  new_W_dt_cutoff::C2
end

NLNewton(; κ=1//100, max_iter=10, fast_convergence_cutoff=1//5, new_W_dt_cutoff=1//5) = NLNewton(κ, max_iter, fast_convergence_cutoff, new_W_dt_cutoff)

# caches

mutable struct NLNewtonCache{W,J,T,du1Type,ufType,jcType,lsType,uType,C} <: AbstractNLSolverCache
  new_W::Bool
  W::W
  J::J
  W_dt::T
  du1::du1Type
  uf::ufType
  jac_config::jcType
  linsolve::lsType
  weight::uType
  new_W_dt_cutoff::C # to be removed
end

mutable struct NLNewtonConstantCache{W,J,T,ufType,C} <: AbstractNLSolverCache
  new_W::Bool
  W::W
  J::J
  W_dt::T
  uf::ufType
  new_W_dt_cutoff::C # to be removed
end

struct NLFunctionalCache{uType} <: AbstractNLSolverCache
  z₊::uType
end

struct NLFunctionalConstantCache <: AbstractNLSolverCache end

mutable struct NLAndersonCache{uType,gsType,QType,RType,gType} <: AbstractNLSolverCache
  z₊::uType
  dzold::uType
  z₊old::uType
  Δz₊s::gsType
  Q::QType
  R::RType
  γs::gType
end

mutable struct NLAndersonConstantCache{gsType,QType,RType,gType} <: AbstractNLSolverCache
  Δz₊s::gsType
  Q::QType
  R::RType
  γs::gType
end
