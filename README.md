# ThermoChroNN

`ThermoChroNN` is a Julia package for quantitative thermochronology calculations, using artificial neural networks. This is a work in progress.

# Motivation

Modelling the thermal history of geologic regions is an integral part of tectonic studies, and is key for. In recent decades, due to the availability of data from high precision measurement techniques and computation resources, sophisticated methods have been developed to estimate time–temperature paths of rock samples using fission track, U–Th–He, 4He/3He and vitrinite reflectance data. Two examples of these are: QTQt ([Transdimensional inverse thermal history modeling for quantitative thermochronology, Gallagher (2012)](https://doi.org/10.1029/2011JB008825)), and HeFTy ([Forward and Inverse Modeling of Low-Temperature Thermochronometry Data, Ketcham (2005)](https://doi.org/10.2138/rmg.2005.58.11)). 

Both QTQt and HeFTy sample a series of points in time–temperature space, and calculate a metric based on the path. This metric is based on physical models of how minerals in the rock respond to temperature changes over millions of years, including: [multi-kinetic annealing models](https://doi.org/10.2138/am.2007.2281); helium diffusion models with [Radiation Damage Accumulation and Annealing Model (RDAAM)](https://doi.org/10.1016/j.gca.2009.01.015), and others. If the candidate model compares well with the experimental data, then the time–temperature path is a good representation of the "true" time–temperature path. The two methods differ in how the time–temperature parameter space is sampled. HeFTy uses a frequentist p-value approach, and searches for well fitting models from a large number of candidate models. On the other hand, QTQt implements a Markov chain Monte Carlo Bayesian approach to searching the parameter space. While both of these techniques are suitable, I want to explore other methods of solving the inverse problem of estimating time–temperature paths from experimental data.

One option is to view the time–temperature path as a T = f(t)

<img src="https://render.githubusercontent.com/render/math?math=f:\mathbb{R}\rightarrow\mathbb{R}">

Currently, I have tested the following capabilities: 
- Modifying values in X and/or Y array(s) in scatter and plot
- Modifying colours in scatter and plot
- Modifying text elements (e.g. titles, xlabels, etc...)
- Modifying matricies in contour plots
- Adding new elements to X,Y arrays in 2d line and scatter plots 
- Adding new elements to X,Y,Z in 3d line and scatter plots

Text

<img src="/figures/originalData.png" height="400"/>

Text

<img src="/figures/fitData.png" height="400"/>

Text

<img src="/figures/nn(2).png" height="400"/>


Note: this package is designed to work with the __plot plane in Juno__. If you force it to plot in a gui it will look really weird.

# Using the package
1. Import the module using `using SmoothLivePlot`. 
2. Create a live plot with macro `outPlotObject = @makeLivePlot myPlotFunction(argument1, argument2, ...)`.
   - Function `myPlotFunction(argument1, argument2, ...)` is a user defined plotting function.
   - Output `outPlotObject` is a mutable output array of plot features. Its elements are the input aruments of `myPlotFunction()`.
3. Modify plot elements with function `modifyPlotObject!(outPlotObject, arg2 = newArg2, arg1 = newArg1, ...)`. 
   - The first argment of `modifyPlotObject!()` must be the mutable output array.
   - The following argments are optional and named. The name/value pair must be `arg<x> = newArg1`, where `<x>` in the name is an integer that indicates the position of the argument in the original plotting function `myPlotFunction()`. 
   - E.g. to modify `argument2` to `newArgument2`, use `modifyPlotObject!(outPlotObject, arg2 = newArgument2)`.
   - The modified arguments do not have to be in any specific order, and are updated at the same time.

### Short example

Here's a video showing an output live-plot from some magnetohydrodynamic calculations:

# TODOs
- [ ] Add capability to add additional elements to plots.
- [ ] Benchmark performance.

# Changelog
- Version 0.1.0 - Introduced original version.
