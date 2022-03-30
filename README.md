# school-stuff
Some Assignments I have done for school  
## Data Analytics (Jan 2021)
The project involves data taken from [ECDC](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide).  
At first, some statistical analysis is included, mainly focusing on fitting distribution objects to the data of some countries, testing on whether the peak of the deaths is actually 14 days later than the peak of the daily cases (using hypothesis testing and correlation analysis) and so on.  
Then regression analysis takes place, in trying to predict the daily deaths using data from the daily Cases. Predictions on the second wave based on data from the first wave are also made (using multiple linear models, stepwise and lasso regression).
## DIP (Spring 2021)
Consists of three exercises on the Digital Image Processing Course.   
The first includes implementing a Bayer to Truecolor conversion algorithm, image resampling techniques (Nearest Neighbour and Bilinear Interpolation), Quantising/Dequantising and finally saving using PPM format.  
The second includes image segmentation, by implementing Spectral Clustering, Normalised cuts and recursive Normalised Cuts techniques.  
The third includes implementing a SIFT detector.  
## SMDS (Spring 2021)
Includes two exercises for the Course of Simulation and Modelling of Dynamical Systems.  
In the first, we use Newton's and Kirchhoff's Laws to create Linear regression Models to describe dynamical systems (Mass/Spring/Damper and an electrical circuit). Then using OLS and simulation to estimate some parameters and check how the systems behave.  
In the second, we get some State space models of LTI systems and by using continuous time Gradient Descent and Lyapunov (Parallel and Series-Parallel) based estimation methods we achieve online parameter estimation.  
## Fuzzy Systems (Spring 2021)
Includes two exercises for the Computational Intelligence Course.  
In the first after designing a classical PID controller, I use a Mamdani FIS to create an FZ-PI controller.  
In the second one I use an ANFIS to solve a regression problem. I use a grid search for the optimisation of some hyperparameters, feature selection and both subtractive clustering and grid partitioning for the rule initialisation.  
## Microprocessors (April 2021)
In this short assignment I have to create a function to efficiently calculate a hash value for a string. This project basically is string analysis using inline assembly (Cortex M4) for low level optimisation.  
## Signal Processing Techniques (Spring 2021)  
By following the [Higher Order Statistics](https://labcit.ligo.caltech.edu/~rana/mat/HOSA/HOSA.PDF) Signal analysis techniques , I present two exercises.  
In the first we examine the methods for the power spectrum and higher order spectrum estimation, and by using plots we can see the existence of quadratic phase coupling.  
In the second, we get a signal which is the output of an LTI system with a Non gaussian noice input. We use [a formula](https://ieeexplore.ieee.org/document/1458151)  studied by George Giannakis which can model the system creating the timeseries by using an MA equation (only works for non gaussian processes but offers robustness to gaussian noise).  
## Neural Networks (Autumn 2021)
Two small projects are presented here, covering some basic concepts of neural networks. 

In the first one, I use keras to solve the multiclass problem of the MNIST dataset. After some basic testing on the hyperparameters, I use the keras tuner for hyperparameter optimisation.

In the second one I solve [a regression problem](https://www.kaggle.com/rodolfomendes/abalone-dataset). After preprocessing, I use linear and polynomial (quadratic) regression. I continue by implementing an RBF Network and using L1/L2 regularisation for the output neuron. I finish by implementing an exhaustive grid search on the number of centers and the regularisation parameter.

## Optimisation Techniques (Autumn 2021)
In the first exercise I study some techniques used for the optimisation of functions defined by scalar variables. I implement and apply the Bisection Method (with and without the use of derivatives), the Golden Section Method as well as the Fibonacci Method. 

In the second exercise I study techniques based on gradient descent. I implement and apply the Steepest Descent Method, the Newton Method, the Levenberg–Marquardt Method for the choice of the direction for change, and the Armijo Method, a Line Search Method and a Constant Gamma Method for the choice of the 
gamma parameter.

In the third exercise I use the projection method to apply the gradient descent principles and solve a constrained optimisation problem.

In the project, I have to train an RBF Network to solve a regression problem. The network is required to be as simple as possible, and must not have more than 15 RBF nodes. At first I tackle the problem using a classical Kmeans/least squares technique and then I implement a genetic algorithm, to manage to attain an optimal solution for the tuning of the parameters of this minimal network. 

## Network Science (Jan 2021)
In this assignment, I have to implement [this algorithm](https://arxiv.org/abs/0903.2181) to solve a problem regarding the detection of overlapping communities in networks. I use NetworkX, mainly the [Louvain](https://networkx.org/documentation/latest/reference/algorithms/generated/networkx.algorithms.community.louvain.louvain_communities.html#networkx.algorithms.community.louvain.louvain_communities) method to optimise the modularity, which is a step I have to do to continue with the rest of the implementation. Finally I test the algorithm on a couple of datasets. 
## Theta QAM (June 2020)
It is a simulation of a telecommunication system using [Theta QAM](https://ieeexplore.ieee.org/document/5439302). The scripts involve computing the BER,SER and making the appropriate plots.
