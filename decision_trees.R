# -----------------------------------------------------------------------

# -------------       BAGGING - RANDOM FORESTS       --------------------

# -----------------------------------------------------------------------


rm(list = ls())

# --- Libraries ---

library(data.table)
library(caret)
library(ggplot2)
library(rpart.plot)
library(randomForest)
library(ipred)


# --- Read data sets and preprocessing---

data("iris")

iris[["setosa_binary"]] <- ifelse(iris[["Species"]]=="setosa",1,0)

# --- Partition dataset

current_dataset_train <- data.table(iris[1:100,])
current_dataset_test <- data.table(iris[101:150,])
current_response_var <- "setosa_binary"

current_dataset_train[[current_response_var]] <- as.factor(current_dataset_train[[current_response_var]])
current_dataset_test[[current_response_var]] <- as.factor(current_dataset_test[[current_response_var]])

yvar <- current_dataset_train[[current_response_var]]
yvar_test <- current_dataset_test[[current_response_var]]


# --------------------------------- Formula models --------------------------


my_formula <- as.formula(paste0(current_response_var, " ~ ."))

# --------------------------------- CART MODEL TRAINING --------------------------


# --- Model 0: This model corresponds to library rpart. The tuning parameter is the complexity 
# parameter (cp). The closer to 0, the more complex or deep the tree. The higher, the less complex the tree.
# In this particular example, even with a cp of 5e-10 the three would not improve (see cp table)

# - CV

my_cart0 <- caret::train(my_formula, current_dataset_train, method = "rpart",model=TRUE,
                         trControl = trainControl(
                           method = "cv", number = 10, verboseIter = TRUE),
                         tuneGrid=expand.grid(cp=0.005)
)

# - Plot the tree
rpart.plot(my_cart0$finalModel)

# - CP table
my_cart0$finalModel$cptable

# - Prediction on test set
my_cart0_pred <-predict(my_cart0,current_dataset_test)



# ------------------- BAGGED CART -----------------------------------

# --- Model 1: In this model we use procedure treebag. For more information on this procedure
# see https://cran.r-project.org/web/packages/ipred/ipred.pdf/ 
# The parameter nbagg controls the number of trees to be grown. The subsamples are by default with replacement
# and of the same size as the original training dataset. 

my_cart1 <- caret::train(my_formula, current_dataset_train, method = "treebag",
                         trControl = trainControl(
                           method = "cv", number = 10, verboseIter = TRUE),
                         nbagg = 4
)

# - Retrive actual final forest
my_cart1_model<- my_cart1$finalModel
# - Visualize one particular tree of the forest
rpart.plot(my_cart1_model$mtrees[[1]]$btree)
# - Predict on test set
my_cart1_pred <-predict(my_cart1,current_dataset_test, type = "raw")


