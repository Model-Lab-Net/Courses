###
### name: דוד בורג
### ID  : [מספר תעודת זהות]
### course: אפידמיולוגיה (HIT.ac.il)
### lesson: מבוא 01   
### date  : 19/06/2025
###  
###  נכיר כאן פעולות בסיסיות


height = 172
height 

weight = 70
weight
bmi = 70/(height/100)^2
bmi

### Variable classes- Atomic classes
### • Numeric class (integer / double classes)
### • Character class (string)
### • Logical class (Boolean)

## ---= Numeric =---
x1 <- 23
class(x1)

x2 <- x 1/4.5
x2
x2 <- round(x2,2)
x2
ס2 <- as.integer(x2)

## ---= Character =---
c1 <- "R workshop"
class(c1)
c1
c2 <- as.character(x2)
c2
x3 <- as.numeric(c1)      # This will return NA since "R workshop" cannot be converted to numeric
x2 <- as.numeric(c2)
x2

## ---= Logical =---
x1
l1 <- (x1==23)            # The == operator checks if something is equal to something else
l1
class(l1)

l1 <- (x1==50)            # The == operator checks if something is equal to something else
l1

l1 <- (x1 < 50)            # The < operator checks if something is xmaller to something else
l1


### ---= Factors (nominal variables) =---
cities = c(1,2,5,4,2,4,3,4,3,5)          # c() is the combine function. 
cities
## now label each city with their names
Fcities=factor(cities,labels=c("Ashdod","Beer-Sheva","Tel-Aviv","Jerusalem","Haifa"))
Fcities
## now convert the factor to a character vector
levels(Fcities) = c("first","second","third","fourth","fifth")
Fcities
levels(cities) = c("first","second","third","fourth","fifth")
cities
Fcities
Fcities[3]

### ---= Vectors (a list of numbers) =---
## Numerical vector
v1 <- c(1,2,3,4,5)     # this combines the numbers into a vector
v1

v2 <- 1:5              # this creates a vector with numbers from 1 to 5
v2

# Replicating vectors
r1 = rep(1,15)           # this replicates the number 1 fifteen times
r1

r2 <- rep(c(1,2,3),4)   # this replicates the numbers 1,2,3 four times
r2

## Character vector
c1 = c('a','b','c','d','e')
c1

# Boolean vector
d1 = c(TRUE,FALSE,FALSE,FALSE,FALSE)     # this creates a vector with TRUE and FALSE values
d1

e1 = (r2==2)                             # this creates a boolean vector that checks if each element in v2 is equal to 2
e1

# generate a random normal distribution
n2 <- rnorm(15, 3, 2)       # this generates 15 random numbers from a normal distribution with mean=3 and standard deviation=2
n2

### ---= Matrices (a table of numbers) =---
mat1 <- matrix(1:9, nrow=3 , ncol=3)
mat1
# Nottice the row and column designation

### ---= Dataframe (similar to matrices but stores any kind of variable) =---
df1 <- data.frame("norm1" = rnorm(5,1,0.5), "rep1" = rep(1,5),
               "city" = c("Ashdod","Beer-Sheva","Tel-Aviv","Jerusalem",
                          "Haifa"))
df1

## Rename column titles
colnames(df1) = c("normal","replication","cities")
df1
## Rename column titles
rownames(df1) = c("one","two","three","four","five")
df1

## Retrieving a column (as a vector)
df1[, 3]              # this retrieves the third column as a vector
df1[, "cities"]       # this retrieves the "cities" column as a vector
df1$cities            # this also retrieves the "cities" column as a vector (simpler)

## Add a column to the end of the dataframe
df1 = cbind(df1,"population"=c(47242,117500,43818,82652,279591))
df1

## Lists
list1=list(v2,mat1,df1)    # create an output showing  vector v2,  matrix mat1, and dataframe df1
list1
names(l1)=c("vector","matrix","dataframe")    # give each one a name in the ouptput
list1

# Retrive elements in a list of different classes
l1[[3]]             # retrieves the third element in the list, which is the dataframe df1
l1[[3]][, 3]        # retrieves the 4th column in df1       
l1[[3]][4,]         # retrieves the 4th row in df1


## ---= If statement (for logical loops) =---
x <- 42
y <- 50

if (y>x){           # check if y is greater than x
  print(TRUE)       # if true, print TRUE
}

# Ifelse statement (for vectorized logical loops)
v3 <- c(12,34,56,1,4,45)                    # create a vector v3
condition <- ifelse(v3 > 10 ,'yes','no')    # ifelse function checks each element in v3, if it's greater than 10, it returns 'yes', otherwise 'no'
condition
