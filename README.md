# BOSME
This is a source code from a script written in R programming language by Rosario Delgado and José David Núñez-González 
to implement the over-sampling algorithm BOSME introduced and described in the paper 

"Bayesian network-based over-sampling method (BOSME) with application to indirect cost-sensitive learning", Scientific Reports 8724(12) 2022
https://doi.org/10.1038/s41598-022-12682-8

Extract of the abstract:
Traditional supervised learning algorithms do not satisfactorily solve the classification problem on imbalanced data sets, 
since they tend to assign the majority class, to the detriment of the minority class classification. In this paper, 
we introduce the Bayesian network-based over-sampling method (BOSME), which is a new over-sampling methodology based on Bayesian networks. 
Over-sampling methods handle imbalanced data by generating synthetic minority instances, with the benefit that classifiers learned 
from a more balanced data set have a better ability to predict the minority class. What makes BOSME different is that it relies on a new approach, 
generating artificial instances of the minority class following the probability distribution of a Bayesian network that is learned 
from the original minority classes by likelihood maximization. 

## Getting started
### Usage 
#### Script Input: 
- dataset: R dataframe. Usually, a training dataset, which is unbalanced attending to the binary (output) class variable
           with some input variables or features, that can be numeric (continuous) or factor (categorical)
- variable: name of the binary class (output) variable (which must be factor)
- percentage: the percentage we want the minority class represent in the enlarged dataset with the artificially created instances
              by default, it is 50
- iterations: the maximum number of iterations in the wrapper to learn the Bayesian network to be used for over-sampling purposes
              by default, it is 25  

### Script Output:  
dataset_plus: R dataframe which is the enlargement of "dataset" with new artificially generated instances of the minority class, 
              so that the minority class represents a percentage equal to "percentage" of the enlarged dataset "dataset_plus".

### R Packages
The only package used is: bnlearn by Marco Scutari.

Scutari M (2010). “Learning Bayesian Networks with the bnlearn R Package.” Journal of Statistical Software, 35(3), 1–22.
https://www.jstatsoft.org/article/view/v035i03

## Support
Contact Rosario Delgado at: Rosario.Delgado@uab.cat

## License
Distributed under the MIT License. See LICENSE for more information.
