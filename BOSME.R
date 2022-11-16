

BOSME<-function(dataset, variable, percentage=50, max.iterations=25){
  
  ## input: 
  
  # dataset: R dataframe. Usually, a training dataset, which is unbalanced attending to the binary class (output) variable
             # with some input variables or features, 
             # that can be numeric (continuous) or factor (categorical)
  
  # variable: name of the binary (output) class variable (which must be factor)
  
  # percentage: the percentage we want classmin represent in the enlarged dataset with the artificially created instances
              # by default, it is 50
  
  # iterations: the maximum number of iterations in the wrapper to learn the Bayesian network to be used for over-sampling purposes
              # by default, it is 25

  ### 0) Preliminars
  
  library(bnlearn)   # package bnlearn by M. Scutari is needed
  
  ## The name of the class we want to oversample (the minority class)
  
  variable_num<-which(colnames(dataset)==variable) # column number of the class variable
  
  classmin<-levels(dataset[[variable_num]])[which.min(table(dataset[[variable_num]]))]
   
  ### The threshold for the difference in logLik when constructing of the net, 
  ### varying the max.iterations parameter (maximum number of iterations), to stop.  
  thr<-sqrt(.Machine$double.eps)   # square root of the "machine epsilon"
  

  ### 1) Split the dataset into two data subsets, with the classmin class and the other class.
  
  dataset_min<-subset(dataset,dataset[[variable_num]]==classmin) # data subset for classmin
  num_min<-length(dataset_min[[variable_num]])  # number of instances in the dataset_min
  dataset_max<-subset(dataset,dataset[[variable_num]]!=classmin ) # data subset for the other class
  num_max<-length(dataset_max[[variable_num]])  # number of instances in the dataset_max 
  
  M<-num_min+num_max   # Number of cases in the whole dataset
  
  ### The names of the numeric and factor variables (except the class variable)
  numer<-names(which(unlist(lapply(dataset_min[,-variable_num],is.numeric))==TRUE))  # names of numeric variables 
  categ<-setdiff(colnames(dataset_min[,-variable_num]),numer) # names of factor input variables (features)
  
   
  ### 2) The BOSME procedure itself
  
  if (100*num_min/M < percentage) # only oversample if it has sense. Otherwise, print the message
                                  # "The minority class already exceeds the percentage we want to reach"
  {
    # Choose the score function to be used by the "bnlearn::hc" function, 
    # which learns the structure of a Bayesian network using a hill-climbing algorithm,
    # and the black list of forbiden directed arcs, if any.
    
    # If all the features are factor, we use the score "loglik" and no black list.
    # I all the features are numeric, we use the score "loglik-g" and no black list.
    # Otherwise (hybrid case), we use the score "loglik-cg" but we must ensure that 
    # no numeric variable is a parent in the DAG we are going to learn of any 
    # factor variable (then, the black list is "my_black_list").
    
    my_black_list=NULL
    
    if(length(numer)==0)
    {used_score<-"loglik"} else {
      if(length(categ)==0)
      {used_score<-"loglik-g"} else {
        my_black_list <- as.data.frame(expand.grid(from = numer, to = categ))
        used_score<-"loglik-cg"
      }
    }
    
## Wrapper to learn the Bayesian network "net" optimizing the hyper-parameters "restart" and "perturb", 
    ## which are arguments of the function "bnlearn::hc".
    ## "restart" is an integer, the number of random restarts. It is initialized to r0, by default 0
    r0<-0
    rest<-r0
    ## and increases by rest.inc, which is 2 by default
    rest.inc<-2
  
    ## For any value of "restart", "perturb", which is an integer meaning the number of attempts to randomly insert/remove/reverse
    ## a directed arc on every random restart, is initialized to 1 and increases by 1 up to the value of "restart".
    
    ## The loop to learn the Bayesian network "net" optimizing "restart" and "perturb" repeats until either the improvement 
    ## is less than the fixed threshold "thr", or until the maximum number of iterations "max.iterations" is reached, 
    ## whichever comes first.

    ## Initializing the maximum number of iterations
    iter<-1 
    
    # Initializing the Bayesian network "net"
    net.0 <- suppressWarnings(bnlearn::hc(dataset_min[,-variable_num],score=used_score,blacklist=my_black_list,
                               restart=r0, perturb=r0))   # net.0 is an object of class bn
    
    net.fit.0 = bnlearn::bn.fit(net.0, dataset_min[,-variable_num])  # net.fit.0 is an object of clas bn.fit
    
    logLik.0<-logLik(net.fit.0,dataset_min[,-variable_num])  # the loglik associated to net.fit.0 and the dataset_min (without the class variable)
                                                                         
    
    # Initializing the difference in the loglik of the successive Bayesian networks
    dif<-0 
    
    # Initializing the loglik of the successive Bayesian networks
    logver.0<-logLik.0
    
    net<-net.0
    logver<-logver.0
    
    # Initializing "rbest", which is the value of "perturb", from 1 to "restart", that maximizes the improvement of the loglik, 
    # fixed "restar"
    rbest<-1   
    
      while(dif<thr & iter<max.iterations)   # while the difference between the loglik of the new Bayesian network
                                             # and the previous be < thr (we still are improving)
                                             # and we do not surpase max.iterations, we continue. 
             # when finish, if it is because we no longer improve, and not because we reached the maximum of iterations, 
             # we choose the result of the previous iteration (the last just before to start to get worse)
        {final.net<-net
         final.loglik<-logver
         final.restart<-rest
         final.perturbation<-rbest
  
         rest<-rest+rest.inc  # the "restart" value in this iteration
      
         difer<-vector()   # the diferences in the loglik, fixed "rest", for "perturb" from 1 to "rest"
         for (r in 1:rest)
            {net <- suppressWarnings(bnlearn::hc(dataset_min[,-variable_num],score=used_score,blacklist=my_black_list,
                                restart=rest, perturb=r)) 
       
             net.fit = bnlearn::bn.fit(net, dataset_min[,-variable_num])
        
             logver<-logLik(net.fit,dataset_min[,-variable_num])
             difer[r]=logver.0-logver
             }  # end for

        rbest<-which.min(difer) 
        
        #
        
        net <- suppressWarnings(hc(dataset_min[,-variable_num],score=used_score,blacklist=my_black_list,
                                   restart=rest, perturb=rbest))  # fixed "rest", with the best value for "perturb", which is "rbest"
        
        net.fit = bn.fit(net, dataset_min[,-variable_num])
        
        logver<-logLik(net.fit,dataset_min[,-variable_num])
        
        dif<-logver.0-logver
        
        ## Updates for the next iteration: the previous value of loglik, which is logver.0, 
        ## and the iteration "iter"
 
        logver.0<-logver
        iter<-iter+1
        
        ## 
        
        if (dif<thr & iter==max.iterations) 
          # When reached the maximum of iterations but we kept improving, 
          # we finish and choose the result of the last iteration. 
          {final.net<-net      
           final.loglik<-logver
           final.restart<-rest
           final.perturbation<-rbest
           } # end if 
      
        }  # end while 
 
## Finish the wrapper with a Bayesian network "final.net", that is used to artificially generate 
## as instances as needed of the minority class
    
   # n is the number of instances to be generate to reach the percentage in the enlarged dataset
   # with the new (artificially generated) instances of the minority class  
    n<- round((percentage*M-100*num_min)/(100-percentage)) 
   
   #  with the Bayesian network "final.net" obtained with the wrapper, 
  #   we generate n new instances and store them in "sample"
    sample<- suppressWarnings(bnlearn::rbn(final.net, n, dataset_min[,-variable_num],replace.unidentifiable=TRUE))
  
   # add a column with the class=classmin to the sample  
    sample[,variable]<-as.factor(rep(classmin,length(sample[,1])))
  
   # the enlarged dataset, adding the generated sample is "dataset_plus"
    dataset_plus<-rbind(dataset_min, sample, dataset_max)
  
  ### output: the enlarged dataset with the artificially generated new cases corresponding to the minority class
    dataset_plus
  } 
     else {print("The minority class already meets or exceeds the percentage we want to reach")}

  }   # end if 

#### END BOSME  #####
