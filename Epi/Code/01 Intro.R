###
### name: דוד בורג
### ID  : [מספר תעודת זהות]
### course: אפידמיולוגיה (HIT.ac.il)
### lesson: מבוא 01   
### date  : 03/07/2025
###  
###  נכיר כאן פעולות בסיסיות ממש


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
