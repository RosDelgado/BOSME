# BOSME
This is a source code from a script written in R programming language by Rosario Delgado and José David Núñez-González 
to implement the oversampling algorithm BOSME introduced and described in the paper 

"Bayesian network-based over-sampling method (BOSME) with application to indirect cost-sensitive learning", Scientific Reports 8724(12) 2022
https://doi.org/10.1038/s41598-022-12682-8

Abstract:
Traditional supervised learning algorithms do not satisfactorily solve the classification problem on imbalanced data sets, 
since they tend to assign the majority class, to the detriment of the minority class classification. In this paper, 
we introduce the Bayesian network-based over-sampling method (BOSME), which is a new over-sampling methodology based on Bayesian networks. 
Over-sampling methods handle imbalanced data by generating synthetic minority instances, with the benefit that classifiers learned 
from a more balanced data set have a better ability to predict the minority class. What makes BOSME different is that it relies on a new approach, 
generating artificial instances of the minority class following the probability distribution of a Bayesian network that is learned 
from the original minority classes by likelihood maximization. We compare BOSME with the benchmark synthetic minority over-sampling technique (SMOTE) 
through a series of experiments in the context of indirect cost-sensitive learning, with some state-of-the-art classifiers and various data sets, 
showing statistical evidence in favor of BOSME, with respect to the expected (misclassification) cost.

## Getting started
### Usage 
#### Script Input: 
- dataset: R dataframe. Usually, a training dataset, which is unbalanced attending to the binary class variable
- variable: name of the binary class variable
- classmin: name of the minority class for which we want to create artificial instances to enlarge the dataset
- percentage: the percentage we want the minority class represent in the enlarged dataset with the artificially created instances
- cont: numbwe of the numeric continuous variables in the dataset

### R Packages
The only package used is: bnlearn

## Support
Contact Rosario Delgado at: rdvolterra16@gmail.com  

## License
Distributed under the MIT License. See LICENSE for more information.
