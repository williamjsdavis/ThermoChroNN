"""
    range32(start, stop, step)

StepRangeLen but for Float32.
"""
function range32(start::Real, stop::Real, step::Real)
  res = range(Float32(start), stop=Float32(stop), step = Float32(step))
  return StepRangeLen{Float32,Float32,Float32}(res)
end
