# ThermoChroNN

`ThermoChroNN` is a Julia package for quantitative thermochronology calculations, using artificial neural networks. This is a work in progress.

# Motivation

Modelling the thermal history of geologic regions is an integral part of tectonic studies, and is key for. In recent decades, due to the availability of data from high precision measurement techniques and computation resources, sophisticated methods have been developed to estimate time–temperature paths of rock samples using fission track, U–Th–He, 4He/3He and vitrinite reflectance data. Two examples of these are: QTQt ([Transdimensional inverse thermal history modeling for quantitative thermochronology, Gallagher (2012)](https://doi.org/10.1029/2011JB008825)), and HeFTy ([Forward and Inverse Modeling of Low-Temperature Thermochronometry Data, Ketcham (2005)](https://doi.org/10.2138/rmg.2005.58.11)). 

Both QTQt and HeFTy sample a series of points in time–temperature space, and calculate a metric based on the path. This metric is based on physical models of how minerals in the rock respond to temperature changes over millions of years, including: [multi-kinetic annealing models](https://doi.org/10.2138/am.2007.2281); helium diffusion models with [Radiation Damage Accumulation and Annealing Model (RDAAM)](https://doi.org/10.1016/j.gca.2009.01.015), and others. If the candidate model compares well with the experimental data, then the time–temperature path is a good representation of the "true" time–temperature path. The two methods differ in how the time–temperature parameter space is sampled. HeFTy uses a frequentist p-value approach, and searches for well fitting models from a large number of candidate models. On the other hand, QTQt implements a Markov chain Monte Carlo Bayesian approach to searching the parameter space. While both of these techniques are suitable, I want to explore other methods of solving the inverse problem of estimating time–temperature paths from experimental data.

# Method

One option is to view the time–temperature (t, T) path as a general function linking every time temperature T = f(t),

<img src="https://render.githubusercontent.com/render/math?math=f:\mathbb{R}\rightarrow\mathbb{R}.">

We can approximate this function with an artificial neural network, based on some parameters

<img src="https://render.githubusercontent.com/render/math?math=T = f_{NN}(t, \theta),">

so that is can model the non-linear map from time to temperature. Through a learning process we can alter parameters θ such that some sort of metric is optimised, similarly to the methods mentioned above. According to the Universal Approximation Theorem from machine learning, if we enough layers and parameters, f(t) can approximate any nonlinear function sufficiently close. 

Another advantage is that it is possible to calculate gradients of the metric with respect to the parameters. In other words, it is very easy to find out what parts of the time–temperature path are the most sensitive to the observed data. This could be useful for determining where the prediction is robust, and investigating why.

Currently, I have only implemented a pathwise comparison metric for the time–temperature path. However I hope to add more physically (and data motivated) loss functions to train the network.

# Example

Here is an example of the esimation method. Say we have some time–temperature path for the last 100 million years which has been sampled at a few points (see figure below).

<img src="/figures/originalData.png" height="400"/>

We can form our neural network function <img src="https://render.githubusercontent.com/render/math?math=T = f_{NN}(t, \theta),">. The network can have any structure, but I found that dense layers with increasing numbers of nodes worked well (see example below).

<img src="/figures/nn(2).png" height="400"/>

The network is trained to minimise the pathwise error in temperature at the sampled points. After training, the function fits the data well (see below).

<img src="/figures/fitData.png" height="400"/>

Here it a video of the model during the training process.

![anim_fps30](https://user-images.githubusercontent.com/38541020/86980829-c2940a80-c139-11ea-90d6-4cd7ff6ba49a.gif)

# Future

I plan to expand on this work by implementing physical models of how the time–temperature path effects the observed data. In addition I want to add other modelling features, such as "bounding boxes" for where there is independent evidence for a point in the time–temperature path.

I'm also interested in combining this with the Julia package [DiffEqFlux](https://github.com/SciML/DiffEqFlux.jl). Advantages include placing physical constraints on the evolution of temperature through time, as well as being able to use the estimated termperature path as a input (or output) of other differential equations.


# TODOs
- [ ] Add physical models to loss function.
- [ ] Collect sets of well fitting models.
- [ ] Output gradients with result.
- [ ] Make test suite.
- [ ] Benchmark performance.

# Changelog
- Version 0.1.0 - Introduced original version.
