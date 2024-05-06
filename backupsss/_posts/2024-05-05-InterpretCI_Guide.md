---
layout: post
title: Introduction to the `{interpretCI}` R Package
date: 2024-05-05 11:59:00-0400
description:
tags: formatting toc
categories: sample-posts
giscus_comments: true
related_posts: false
toc:
  beginning: true
---

## Introduction to the `{interpretCI}` R Package

This article introduces an R package called `{interpretCI}`, which is designed for plotting confidence intervals for means and differences between means. It also features automatic documentation generation, further aiding in the interpretation of statistical results. This tool is particularly useful for understanding the core statistical concept of confidence intervals.

### Installation and Loading Packages

First, install and load the necessary R packages:

```R
install.packages("interpretCI")
install.packages("MASS")

library(interpretCI)
library(MASS)
# R packages loaded!
```

### Data Exploration

Explore the `Cars93` dataset from the MASS package:

```R
summary(Cars93)
```

### Calculating Confidence Intervals

Calculate the confidence interval for a mean using the `meanCI` function, focusing on the `MPG.city` variable:

```R
meanCI(Cars93$MPG.city)
```

### Plotting Confidence Intervals

Plot the confidence interval estimation:

```R
meanCI(Cars93$MPG.city) |>
  plot()
```

### Detailed Interpretation

For a detailed interpretation of these statistical results, use:

```R
interpret(meanCI(Cars93$MPG.city))
```

### Comparing Two Means

Examine and compare two means in the `Cars93` dataset:

```R
summary(Cars93)
meanCI(Cars93$MPG.city, Cars93$MPG.highway)
t.test(Cars93$MPG.city, Cars93$MPG.highway)
```

### Visualizations

Visualize the results for clarity:

```R
meanCI(Cars93$MPG.city, Cars93$MPG.highway) |>
  plot(ref = "control", side = FALSE)
```

### Paired Sample Comparison

Consider paired sample mean differences:

```R
data(Cars93)
meanCI(Cars93, Price, Max.Price, paired = TRUE) |>
  plot(ref = "test", side = FALSE)
t.test(Cars93$Price, Cars93$Max.Price, paired = TRUE)
```

### Multiple Paired Samples

Handle comparisons involving multiple paired samples:

```R
meanCI(Cars93,
       idx = list(c("Price", "Max.Price"),
                  c("MPG.city", "MPG.highway")),
       paired = TRUE, mu = 0) |>
  plot()
```

### Handling Multiple Variables

Finally, handle cases involving a categorical variable but multiple continuous variables:

```R
summary(Cars93)
Cars93 |>
  subset(select = c(Type, Price, MPG.city, MPG.highway)) |>
  meanCI(Type, mu = 0) |>
  plot()
```

dataset from the MASS package:

```R
summary(Cars93)
```

### Confidence Interval Calculation

Calculate the confidence interval for a mean using the `meanCI` function, focusing on the `MPG.city` variable:

```R
meanCI(Cars93$MPG.city)
```

The results will display the lower and upper limits of the confidence interval.

### Plotting the Confidence Interval

Then, plot the confidence interval estimation:

```R
meanCI(Cars93$MPG.city) |>
  plot()
```

The left side of the above figure shows the original data scatter for `MPG.city`, and the right side displays the 95% confidence interval for the mean.

### Detailed Interpretation

For a more detailed interpretation of these statistical results, use the following code to view a comprehensive explanation (a great feature!):

```R
interpret(meanCI(Cars93$MPG.city))
```

A detailed document will appear in the right-side Viewer for further learning!

### Comparing Two Means

Next, compare two means using another dataset:

First, examine the `Cars93` dataset:

```R
summary(Cars93)
```

To compare the means of `MPG.city` and `MPG.highway`, use the following code:

```R
meanCI(Cars93$MPG.city, Cars93$MPG.highway)
```

The results are similar to those of an independent samples t-test:

```R
t.test(Cars93$MPG.city, Cars93$MPG.highway)
```

Compare the differences in means and confidence intervals obtained by the two methods; the results are the same.

### Visualization

Further, visualize these results for clarity:

```R
meanCI(Cars93$MPG.city, Cars93$MPG.highway) |>
  plot(ref = "control", side = FALSE)
```

The top part of the image shows data points for both variables in a swarmplot format. The scatter plot on the right shows the respective confidence intervals.

### Paired Sample Comparison

Next, consider the case of paired sample mean differences.

Examine the `Cars93` dataset:

```R
data(Cars93)
summary(Cars93)
```

Compare the means at two time points (`Price` and `Max.Price`) and directly plot them:

```R
meanCI(Cars93, Price, Max.Price, paired = TRUE) |>
  plot(ref = "test", side = FALSE)
```

The visualization of the two time points is very clear and beautiful, as well as practical!

### Further Comparisons

Similarly, perform a paired t-test with R's own function to see if the results match:

```R
t.test(Cars93$Price, Cars93$Max.Price, paired = TRUE)
```

The results are identical!

### Multiple Paired Samples

In another example, the package can also handle comparisons involving multiple paired samples.

Examine the dataset `Cars93` again:

```R
data(Cars93)
Cars93
```

To simultaneously display three paired comparisons (e.g., `Price` vs. `Max.Price`), use this code:

```R
meanCI(Cars93,
       idx = list(c("Price", "Max.Price"),
                  c("MPG.city", "MPG.highway")),
       paired = TRUE, mu = 0) |>
  plot()
```

Beautiful! This type of comparison will be very practical for those who need it!

### Multiple Continuous Variables with a Categorical Group

Finally, this R package can also handle cases involving a categorical variable but multiple continuous variables.

Examine the `Cars93` dataset:

```R
summary(Cars93)
```

Suppose researchers wish to compare the groups `Type` with continuous variables such as `Price`, `MPG.city`, and `MPG.highway`, then proceed as follows:

```R
Cars93 |>
  subset(select = c(Type, Price, MPG.city, MPG.highway)) |>
  meanCI(Type, mu = 0)
```

Directly plot the results:

```R
Cars93 |>
  subset(select = c(Type, Price, MPG.city, MPG.highway)) |>
  meanCI(Type, mu = 0) |>
  plot()
```

The graph is stunning! Although the comparisons show no statistical differences.

That's all for today's content. If you found this helpful, remember to share it with others who might need it!
