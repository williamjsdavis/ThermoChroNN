"""
    MapIn(layers...)
Maps input through multiple layers / functions, so it is broadcasted
over.
# Examples
```jldoctest
julia> m = MapIn(Chain(Dense(1, 4), Dense(4, 1)));
julia> size(m(Float32[1, 2, 3])) == (3,)
true
```
"""
struct MapIn{T<:Tuple}
    layers::T
    MapIn(xs...) = new{typeof(xs)}(xs)
end
applychain(::Tuple{}, x) = x
applychain(fs::Tuple, x) = applychain(Base.tail(fs), first(fs)(x))
(a::MapIn)(x) = broadcast(y -> applychain(a.layers, y), x)
(a::MapIn)(x::Array{Float32,1}) = broadcast(first, a(map(y -> [y], x)))
Flux.trainable(a::MapIn) = a.layers

#Base.getindex(x::MapIn, args...) = Base.getindex(x.layers)
Base.length(x::MapIn, args...) = Base.length(x.layers)
#Base.first(x::MapIn, args...) = Base.first(x.layers)
#Base.last(x::MapIn, args...) = Base.last(x.layers)
#Base.iterate(x::MapIn, args...) = Base.iterate(x.layers)
#Base.lastindex(x::MapIn, args...) = Base.lastindex(x.layers)

function Base.show(io::IO, c::MapIn)
  print(io, "MapIn(")
  join(io, c.layers, ", ")
  print(io, ")")
end
