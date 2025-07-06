###
### name  : דוד בורג
### ID    : [מספר תעודת זהות]
### course: אפידמיולוגיה (HIT.ac.il)
### lesson: סטטיסטיקה תאורית וניתות בסיסי 02-03   
### date  : 03/07/2025
###  
###  נלמד לבצע ניתוח סטטיסטי פשוט
###
### source: https://epirhandbook.com/en/
###         https://github.com/appliedepi/epirhandbook_eng


## Reset memory
```{r setup-packages, include = FALSE}
rm(list = ls(all.names = TRUE))
lapply(paste("package:", names(sessionInfo()$otherPkgs), sep = ""), detach, character.only = TRUE, unload = TRUE, force = TRUE)
gc()
dev.off()
```

## Load required packages
```{r load-packages, include = FALSE}  
options("install.lock" = FALSE)
if (!require("pacman")) install.packages("pacman")
library(pacman)
pacman::p_load(
  rio,                    # File import
  tidyverse,              # data management + ggplot2 graphics,
  broom,                  # For tidying model outputs
  dplyr,                  # For data manipulation
  gt,                     # Nice beuatiful tables
  nortest,                # Anderson-Darling test for normality
  ggplot2,                # For creating plots
  DescTools,              # For statistical functions like skewness and kurtosis
  psych                   # to get a table of all summary statistics
              )
```

## Access the data
```{r read-data, echo = FALSE}
# file <- "./EpiData/linelist_cleaned.rds"     # 👈 use this if the file is on your computer
file <- "https://github.com/appliedepi/epirhandbook_eng/raw/master/data/case_linelists/linelist_cleaned.rds"
df1 <- import(file, trust = TRUE)
summary(df1)
glimpse(df1)
```

## Replace bmi with calculation
```{r read-data, echo = FALSE}
## read the data in a file online
df1 <- df1 %>%
  mutate(bmi = wt_kg / (ht_cm / 100)^2)
summary(df1)
glimpse(df1)
```

## Select numerical variable for analysis
```{r descriptives, echo = TRUE}
# Select variables from the df to calculate summary statistics
variables <- c("age", "bmi", "temp")

# Calculate summary statistics
summary_stats <- describe(df1[, variables])           # this is using psych package
iqr <- sapply(df1[, variables], IQR, na.rm = TRUE)
summary_stats$IQR <- iqr # Add IQR

# Switch around the table
summary_stats <- as.data.frame(t(summary_stats))      # transpose df direction
summary_stats <- summary_stats %>%                    # convert into a real df
  as.data.frame() %>%
  rownames_to_column(var = "Variable")
summary_stats <- summary_stats[-c(1, 2), ]            # remove 1st two uneeded rows

# Convert to nice table
summary_stats_tbl <- summary_stats %>%
  gt() %>%
  tab_header(title = "Descriptive Statistics⠀⠀⠀⠀סטטיסטיקה תאורית") %>%
  fmt_number(
    columns = where(is.numeric),
    decimals = 2
  )
summary_stats_tbl # Display the table
```


## The old way to do descriptives
```{r descriptives-old, echo = TRUE}
desc_result <- Desc(df1[variable], plotit = TRUE)
desc_result

mean1 <- Mean(df1[[variable]], na.rm = TRUE)
sd1 <- sd(df1[[variable]], na.rm = TRUE)
CI1 <- MeanCI(df1[[variable]], na.rm = TRUE)
lower_meanci_1 <- as.numeric((CI1["lwr.ci"]))
upper_meanci_1 <- as.numeric((CI1["upr.ci"]))
mode1 <- as.numeric(Mode(df1[[variable]], na.rm = TRUE))
median1 <- Median(df1[[variable]], na.rm = TRUE)
q25_1 <- as.numeric(Quantile(df1[[variable]], probs = 0.25, na.rm = TRUE))
q75_1 <- as.numeric(Quantile(df1[[variable]], probs = 0.75, na.rm = TRUE))
IQR1 <- IQR(df1[[variable]], na.rm = TRUE)
min1 <- min(df1[[variable]], na.rm = TRUE)
max1 <- max(df1[[variable]], na.rm = TRUE)
skew1 <- Skew(df1[[variable]], na.rm = TRUE) # Skewness
kurt1 <- Kurt(df1[[variable]], na.rm = TRUE) # Kurtosis
norm1 <- ad.test(df1[[variable]][!is.na(df1[[variable]])])$p.value # Anderson-Darling test for normality

# Create a data frame to neatly display the statistics
stats_df <- data.frame(
  Statistic = c("Mean", "SD", "⠀⠀CI₉₅ low", "⠀⠀CI₉₅ high", "Mode", "Median", "⠀⠀Q1", "⠀⠀Q3", "⠀⠀IQR", "Minimum", "Maximum", "Skewness", "Kurtosis", "Normality test"),
  Value = c(mean1, sd1, lower_meanci_1, upper_meanci_1, mode1, median1, q25_1, q75_1, IQR1, min1, max1, skew1, kurt1, norm1),
  סטטיסטי = c("ממוצע", "ס'ת", "⠀⠀רווח סמך", "⠀⠀רווח סמך", "שכיח", "חציון", "⠀⠀רבעון 1", "⠀⠀רבעון 3", "⠀⠀מרווח בין רבועני", "מינימום", "מקסימום", "צידוד", "גבנוניות", "נורמליות")
)

# Clean, simple table
summary_stats <- stats_df %>%
  gt() %>%
  tab_header(title = "Summary Statistics⠀⠀⠀⠀סטטיסטקה תאורית") %>%
  fmt_number(columns = Value, decimals = 1)

summary_stats # Show the table
```


## Pie Chart 
```{r pie, echo = TRUE}
pie_var <- "age_cat" # Change this to the categorial variable
ggplot(df1, aes(x = "", fill = .data[[pie_var]])) +
  geom_bar(width = 1, stat = "count") +
  coord_polar(theta = "y") +
  theme_void() +
  # scale_fill_manual(values = c("lightblue", "lightgreen", "lightcoral", "lightgoldenrodyellow", "lightpink")) +
  labs(
    title = "Chart of age_cat",
  )
```

## Histogram
```{r histogram, echo = TRUE}
hist_var <- variable
ggplot(df1, aes(x = get(hist_var))) +
  geom_histogram(binwidth = 5, fill = "grey", color = "black") +
  theme_minimal() +
  labs(
    title = "Histogram of Age",
    x = "Age (years)",
    y = "Count"
  )
```


## Boxplot
```{r boxplot, echo = TRUE}
x_var <- "cough" # Change this to a categorial variable
y_var <- "temp" # Change this to a numerical variable
ggplot(df1, aes(x = get(x_var), y = get(y_var), fill = get(x_var))) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.25, size = 0.25, color = "grey") +
  theme_minimal() +
  scale_fill_manual(values = c("yes" = "lightblue", "no" = "lightgreen", "unknown" = "lightgray")) +
  labs(
    title = "Boxplot of Temperature by Cough Status",
    x = "Cough",
    y = "°C",
    fill = "Cough"
  )
```





### -------------------------------------------------




### Question1

## 
```{r question1}

library(ggplot2)


ggplot(data, aes(x = height0, y = weight0)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +  # Adding the trend line with linear model
  labs(title = "Scatter Plot of Weight vs Height",
       x = " Height (cm)",
       y = "Weight (kg)")



##pearson
test_result <- cor.test(data$weight0, data$height0, method = "pearson", use = "complete.obs")
print(test_result)



#spearman
spearman_test_result <- cor.test(data$weight0, data$height0, method = "spearman", use = "complete.obs")

# Print the test result
print(spearman_test_result)
```
##chi square
```{r pressure, echo=FALSE}

 
data$pacifier_dich <- factor(data$pacifier_dich, levels = c(0, 1), labels = c("no", "yes"))
data$newborn_gender <- factor(data$newborn_gender, levels = c(0, 1), labels = c("male", "female"))
# Create a contingency table
table_data <- table(data$pacifier_dich, data$newborn_gender)
table_data

# Calculate and print the percentage table
percent_table <- prop.table(table_data, margin = 1) * 100  # Row percentages
print(percent_table)
print(column_percentages)
column_percentages <- prop.table(table_data, margin = 2) * 100 #column percentages
print(column_percentages)

# Perform the chi-square test
chi_test <- chisq.test(table_data)

# Print the results of the chi-square test
print(chi_test)


expected_counts <- chi_test$expected
expected_counts
count_violations <- sum(expected_counts < 5)
total_counts <- length(expected_counts)
percentage_violations <- (count_violations / total_counts) * 100
percentage_violations


cat("Percentage of expected counts less than 5:", percentage_violations, "%\n")
if (percentage_violations > 20) {
  cat("Warning: More than 20% of expected counts are less than 5, which violates chi-square test assumptions.\n")
}

```


## OR and RR for 2*2
```{r question1}
install.packages("epitools")
library(epitools)

# Create a contingency table
contingency_table <- table(data$newborn_gender ,data$pacifier_dich)

# Compute Odds Ratio (OR) and Relative Risk (RR)
OR_result <- epitab(contingency_table, method = "oddsratio")
print(OR_result)

RR_result <- epitab(contingency_table, method = "riskratio")
print(RR_result)
```


##fisher
```{r pressure, echo=FALSE}
contingency_table <- table(data$newborn_gender, data$pacifier_dich)

# Perform Fisher's exact test
fisher_result <- fisher.test(contingency_table)

# Print the result
print(fisher_result)
```
