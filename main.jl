## He gradient test
using Flux
include("helperFunctions.jl")
include("utils.jl")
using .MapInLayer

using Plots
using SmoothLivePlot
using Printf
gr(show = true)



## Plotting functions
function myPlotFun(tforPlot, tDomain, trueTemperature, tempData, initialEstAll, initialEst, finalEstAll, finalEst)
  plot(tforPlot, trueTemperature,
    label = "True",
    xmirror=true)
  scatter!(tDomain, tempData, markersize = 5, label = "Data")
  plot!(tforPlot, initialEstAll, color = "green", label = "Original")
  scatter!(tDomain, initialEst, markersize = 5, color = "green", label = "")
  plot!(tforPlot, finalEstAll, color = "red", label = "Final")
  scatter!(tDomain, finalEst, markersize = 5, color = "red", label = "")
  plot!(xaxis = ("Time, Ma", :flip))
  plot!(yaxis = ("Temperature, C", :flip))
  #display(fig)
end

## Main functions
function trueTemperatureFun(t::Real)
  # Based on QTQt test temperature
  intc = Float32(100)
  midp = Float32(50)
  grad = Float32(8/5)
  Float32(intc - grad*abs(t - midp))
end
function formModel()
  # Set up neural network
  temperatureNet = Chain(
  Dense(1, 16, gelu),
  Dense(16, 32, gelu),
  Dense(32, 64),
  +)

  # NOTE: This function seems to be less effective than inlining
  initalizeWeights!(temperatureNet)


  temperatureMap = MapIn(temperatureNet)
end
function initalizeWeights!(net)
  # Randomize weights
  p, re = Flux.destructure(net)
  p[p.!=0.0] = Float32.(0.5*randn(sum(p.!=0.0)))
  p[p.==0.0] = (50.0 .+ Float32.(10.0*randn(sum(p.==0.0))))
  net = re(p)
  net = MapIn(net)
end
function makeData(tDomain, nTrain)
  tempData = trueTemperatureFun.(tDomain)
  #data = [(tDomain, trueTemperature)]
  data = Iterators.repeated((tDomain, tempData), nTrain)
  return data, tempData
end
function main()

  # True temperature for comparison
  tforPlot = collect(range32(0, 100, 0.1))
  trueTemperature = trueTemperatureFun.(tforPlot)

  # Sample true data
  tDomain = Float32[0.1, 5.3, 15.5, 25.5, 39.9, 45.3, 55.5, 65.5, 89.9, 99.5]
  data, tempData = makeData(tDomain, 1000)

  # Model and initial prediction
  temperatureMap = formModel()
  initialEstAll = temperatureMap(tforPlot)
  initialEst = temperatureMap(tDomain)

  # Training requirements
  parameters = params(temperatureMap)
  loss(x, y) = Flux.mae(temperatureMap(x), y)
  opt = ADAM(0.1)
  evalcb() = begin
    println(loss(data.xs.x...))
    finalEstAll = temperatureMap(tforPlot)
    finalEst = temperatureMap(tDomain)
    # NOTE: Get SmoothLivePlot working with this
    display(myPlotFun(tforPlot, tDomain, trueTemperature, tempData, initialEstAll, initialEst, finalEstAll, finalEst))
  end

  # Start simple training
  Flux.train!(loss, parameters, data, opt, cb = Flux.throttle(evalcb, 0.1))
  Flux.train!(loss, parameters, data, ADAM(0.01), cb = Flux.throttle(evalcb, 0.1))

  # Compare results
  finalEstAll = temperatureMap(tforPlot)
  finalEst = temperatureMap(tDomain)
  myPlotFun(tforPlot, tDomain, trueTemperature, tempData, initialEstAll, initialEst, finalEstAll, finalEst)

end

main()
