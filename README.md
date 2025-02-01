[![R](https://github.com/PiotrTymoszuk/trafo/actions/workflows/r.yml/badge.svg)](https://github.com/PiotrTymoszuk/trafo/actions/workflows/r.yml)

<img src="https://user-images.githubusercontent.com/80723424/226478184-cca8eea0-b9eb-444f-973a-6711ce2a61cf.png" width="10%" height="10%" align = "right">

# trafo
Transformation Toolset for Vectors, Matrices, Lists and Data Frames

## Purpose

The package provides tools for transformation and inter-conversion of vectors, matrices, lists and data frames, which expand the `tidyverse` environment. Such extra tools include functions for translation of a variable using a dictionary table, reduction of lists and vectors into low-dimensional data structures, and expansion of data frames.

Additonal features making the life of a data scientist easier are e.g. a swiss army knife row binding function family, functions for setting row names and identification of individuals with complete record of consecutive data.

## Installation

You may install the package and its dependency 'figur' using `devtools`:

```r

devtools::install_github('PiotrTymoszuk/figur')

devtools::install_github('PiotrTymoszuk/trafo')

```
## Basic usage

<details>
   <summary>Exchanging values with a dictionary</summary>
   
   ### Exchanging values with a dictionary
   
   This operation is done for a range of data structures with the `exchange()` function. In any case you'll need a dictionary in a data frame format: 
   
   ```r
   
   library(trafo)
   library(tibble)
   library(tidyverse)
   
  ## example data: tibble, data frame and matrix

  my_cars <- mtcars %>%
    rownames_to_column('cars') %>%
    select(- vs, - am) %>%
    as_tibble

  my_cars2 <- mtcars %>%
    mutate(mtcars,
           ncap = sample(c(1:10, NA),
                         nrow(mtcars),
                         replace = TRUE))
                                               
  my_cyl_mtx <- matrix(sample(1:8, 20, replace = TRUE),
                       nrow = 2,
                       ncol = 10)                 
                    
  my_cyl_list <- list('A' = sample(1:8, 20, replace = TRUE),
                      'B' = sample(1:8, 20, replace = TRUE),
                      'C' = matrix(c(12, 4, 8, 10),
                                   c(6, 4, 8, 10),
                                   ncol = 2),
                      'D' = my_cars)
                      
  ## and a dictionary mapping the cylinder number to a text label

  cyl_reco <- tibble::tibble(cyl = c(4, 6, 8, 10, 12),
                             cyl_lab = c('4-cylinder',
                                         '6-cylinder',
                                         '6+ cylinder',
                                         '6+-cylinder',
                                         '6+-cylinder')) 
      
   ```
   
   Translation of the cylinder number to its text value with `exchange()` is straightforward:
   
   ```r
   
   ## for data frame/tibble
   
   exchange(my_cars,
           variable = 'cyl',
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab')

# A tibble: 32 × 10
   cars                mpg cyl          disp    hp  drat    wt  qsec  gear  carb
   <chr>             <dbl> <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1 Mazda RX4          21   6-cylinder   160    110  3.9   2.62  16.5     4     4
 2 Mazda RX4 Wag      21   6-cylinder   160    110  3.9   2.88  17.0     4     4
 3 Datsun 710         22.8 4-cylinder   108     93  3.85  2.32  18.6     4     1
 4 Hornet 4 Drive     21.4 6-cylinder   258    110  3.08  3.22  19.4     3     1
 5 Hornet Sportabout  18.7 6+ cylinder  360    175  3.15  3.44  17.0     3     2
 6 Valiant            18.1 6-cylinder   225    105  2.76  3.46  20.2     3     1
 7 Duster 360         14.3 6+ cylinder  360    245  3.21  3.57  15.8     3     4
 8 Merc 240D          24.4 4-cylinder   147.    62  3.69  3.19  20       4     2
 9 Merc 230           22.8 4-cylinder   141.    95  3.92  3.15  22.9     4     2
10 Merc 280           19.2 6-cylinder   168.   123  3.92  3.44  18.3     4     4
# … with 22 more rows
# ℹ Use `print(n = ...)` to see more rows
  
  ## for a matrix:
  
  exchange(my_cyl_mtx,
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab')
           
       [,1]          [,2] [,3]         [,4]          [,5]         [,6]          [,7]         [,8]          [,9]          [,10]
[1,] "6+ cylinder" NA   "4-cylinder" "6-cylinder"  "6-cylinder" "6-cylinder"  "4-cylinder" "6-cylinder"  NA            NA   
[2,] "6-cylinder"  NA   "4-cylinder" "6+ cylinder" NA           "6+ cylinder" NA           "6+ cylinder" "6+ cylinder" NA  
  
  ## for a list:
  
  exchange(my_cyl_list,
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab',
           variable = 'cyl')
           
  $A
         <NA>             6          <NA>             8             4             4             8             6             8 
           NA  "6-cylinder"            NA "6+ cylinder"  "4-cylinder"  "4-cylinder" "6+ cylinder"  "6-cylinder" "6+ cylinder" 
         <NA>          <NA>          <NA>          <NA>          <NA>          <NA>          <NA>          <NA>          <NA> 
           NA            NA            NA            NA            NA            NA            NA            NA            NA 
            8             8 
"6+ cylinder" "6+ cylinder" 

$B
         <NA>          <NA>          <NA>          <NA>             6          <NA>          <NA>          <NA>             8 
           NA            NA            NA            NA  "6-cylinder"            NA            NA            NA "6+ cylinder" 
            8          <NA>             8             4             4             6          <NA>             6          <NA> 
"6+ cylinder"            NA "6+ cylinder"  "4-cylinder"  "4-cylinder"  "6-cylinder"            NA  "6-cylinder"            NA 
         <NA>          <NA> 
           NA            NA 

$C
     [,1]          [,2]         
[1,] "6+-cylinder" "6+ cylinder"
[2,] "4-cylinder"  "6+-cylinder"
[3,] "6+ cylinder" "6+-cylinder"
[4,] "6+-cylinder" "4-cylinder" 
[5,] "6+-cylinder" "6+ cylinder"
[6,] "4-cylinder"  "6+-cylinder"

$D
# A tibble: 32 × 10
   cars                mpg cyl          disp    hp  drat    wt  qsec  gear  carb
   <chr>             <dbl> <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1 Mazda RX4          21   6-cylinder   160    110  3.9   2.62  16.5     4     4
 2 Mazda RX4 Wag      21   6-cylinder   160    110  3.9   2.88  17.0     4     4
 3 Datsun 710         22.8 4-cylinder   108     93  3.85  2.32  18.6     4     1
 4 Hornet 4 Drive     21.4 6-cylinder   258    110  3.08  3.22  19.4     3     1
 5 Hornet Sportabout  18.7 6+ cylinder  360    175  3.15  3.44  17.0     3     2
 6 Valiant            18.1 6-cylinder   225    105  2.76  3.46  20.2     3     1
 7 Duster 360         14.3 6+ cylinder  360    245  3.21  3.57  15.8     3     4
 8 Merc 240D          24.4 4-cylinder   147.    62  3.69  3.19  20       4     2
 9 Merc 230           22.8 4-cylinder   141.    95  3.92  3.15  22.9     4     2
10 Merc 280           19.2 6-cylinder   168.   123  3.92  3.44  18.3     4     4
# … with 22 more rows
# ℹ Use `print(n = ...)` to see more rows
   
   ```
   
</details>

<details>
   <summary>Compressing lists and vectors to data frames</summary>
   
   ### Compressing lists and vectors to data frames
   
   `compress()` allows for reduction of multi-dimensional list to a simple data frame:
   
   ```r
   
   ## the input list storing data of various types
   
   my_cyl_list
   
   $A
 [1] 2 1 8 4 7 1 3 7 8 3 8 1 4 6 8 8 1 1 5 2

$B
 [1] 8 7 2 7 8 2 8 5 5 1 3 3 1 4 1 3 6 6 4 3

$C
     [,1] [,2]
[1,]   12    8
[2,]    4   10
[3,]    8   12
[4,]   10    4
[5,]   12    8
[6,]    4   10

$D
# A tibble: 32 × 10
   cars                mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
   <chr>             <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1 Mazda RX4          21       6  160    110  3.9   2.62  16.5     4     4
 2 Mazda RX4 Wag      21       6  160    110  3.9   2.88  17.0     4     4
 3 Datsun 710         22.8     4  108     93  3.85  2.32  18.6     4     1
 4 Hornet 4 Drive     21.4     6  258    110  3.08  3.22  19.4     3     1
 5 Hornet Sportabout  18.7     8  360    175  3.15  3.44  17.0     3     2
 6 Valiant            18.1     6  225    105  2.76  3.46  20.2     3     1
 7 Duster 360         14.3     8  360    245  3.21  3.57  15.8     3     4
 8 Merc 240D          24.4     4  147.    62  3.69  3.19  20       4     2
 9 Merc 230           22.8     4  141.    95  3.92  3.15  22.9     4     2
10 Merc 280           19.2     6  168.   123  3.92  3.44  18.3     4     4
# … with 22 more rows
# ℹ Use `print(n = ...)` to see more rows

  ## gets compacted to a simple data frame
  
   compress(my_cyl_list,
           names_to = 'lst_names',
           values_to = 'lst_elements',
           simplify = TRUE)
           
   # A tibble: 4 × 2
  lst_names lst_elements      
  <chr>     <named list>      
1 A         <int [20]>        
2 B         <int [20]>        
3 C         <dbl [6 × 2]>     
4 D         <tibble [32 × 10]>
   
   ```
  The `compress()` function reverts the effects of e.g. `plyr::dlply()` or `split()` functions using for conversin of data frames to lists:
  
  ```r
  
  ## split the 'cars' data frame by cyclinder count
  
  my_cars %>%
    dlply('cyl')
    
  $`4`
             cars  mpg cyl  disp  hp drat    wt  qsec gear carb
1      Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61    4    1
2       Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00    4    2
3        Merc 230 22.8   4 140.8  95 3.92 3.150 22.90    4    2
4        Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47    4    1
5     Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52    4    2
6  Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90    4    1
7   Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01    3    1
8       Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90    4    1
9   Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70    5    2
10   Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90    5    2
11     Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60    4    2

$`6`
            cars  mpg cyl  disp  hp drat    wt  qsec gear carb
1      Mazda RX4 21.0   6 160.0 110 3.90 2.620 16.46    4    4
2  Mazda RX4 Wag 21.0   6 160.0 110 3.90 2.875 17.02    4    4
3 Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44    3    1
4        Valiant 18.1   6 225.0 105 2.76 3.460 20.22    3    1
5       Merc 280 19.2   6 167.6 123 3.92 3.440 18.30    4    4
6      Merc 280C 17.8   6 167.6 123 3.92 3.440 18.90    4    4
7   Ferrari Dino 19.7   6 145.0 175 3.62 2.770 15.50    5    6

$`8`
                  cars  mpg cyl  disp  hp drat    wt  qsec gear carb
1    Hornet Sportabout 18.7   8 360.0 175 3.15 3.440 17.02    3    2
2           Duster 360 14.3   8 360.0 245 3.21 3.570 15.84    3    4
3           Merc 450SE 16.4   8 275.8 180 3.07 4.070 17.40    3    3
4           Merc 450SL 17.3   8 275.8 180 3.07 3.730 17.60    3    3
5          Merc 450SLC 15.2   8 275.8 180 3.07 3.780 18.00    3    3
6   Cadillac Fleetwood 10.4   8 472.0 205 2.93 5.250 17.98    3    4
7  Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82    3    4
8    Chrysler Imperial 14.7   8 440.0 230 3.23 5.345 17.42    3    4
9     Dodge Challenger 15.5   8 318.0 150 2.76 3.520 16.87    3    2
10         AMC Javelin 15.2   8 304.0 150 3.15 3.435 17.30    3    2
11          Camaro Z28 13.3   8 350.0 245 3.73 3.840 15.41    3    4
12    Pontiac Firebird 19.2   8 400.0 175 3.08 3.845 17.05    3    2
13      Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50    5    4
14       Maserati Bora 15.0   8 301.0 335 3.54 3.570 14.60    5    8

  ## and stitch the list back to a data frame with 'compress()'
  
  my_cars %>%
    dlply('cyl') %>%
    compress(names_to = 'cyl') %>% 
    as_tibble
    
    # A tibble: 32 × 10
   cars             mpg cyl    disp    hp  drat    wt  qsec  gear  carb
   <chr>          <dbl> <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1 Datsun 710      22.8 4     108      93  3.85  2.32  18.6     4     1
 2 Merc 240D       24.4 4     147.     62  3.69  3.19  20       4     2
 3 Merc 230        22.8 4     141.     95  3.92  3.15  22.9     4     2
 4 Fiat 128        32.4 4      78.7    66  4.08  2.2   19.5     4     1
 5 Honda Civic     30.4 4      75.7    52  4.93  1.62  18.5     4     2
 6 Toyota Corolla  33.9 4      71.1    65  4.22  1.84  19.9     4     1
 7 Toyota Corona   21.5 4     120.     97  3.7   2.46  20.0     3     1
 8 Fiat X1-9       27.3 4      79      66  4.08  1.94  18.9     4     1
 9 Porsche 914-2   26   4     120.     91  4.43  2.14  16.7     5     2
10 Lotus Europa    30.4 4      95.1   113  3.77  1.51  16.9     5     2
# … with 22 more rows
# ℹ Use `print(n = ...)` to see more rows
  
  ```
Of practical importance, 'compress()' may be employed to create data frame from named vectors:

```r

c('4' = '4-cylinder',
  '6' = '6-cylinder',
  '8' = '6+ cylinder',
  '10' = '6+-cylinder',
  '12' = '6+-cylinder') %>% 
      compress(names_to = 'cyclinder_number', 
               values_to = 'cylinder_category')
               
# A tibble: 5 × 2
  cyclinder_number cylinder_category
  <chr>            <chr>            
1 4                4-cylinder       
2 6                6-cylinder       
3 8                6+ cylinder      
4 10               6+-cylinder      
5 12               6+-cylinder 

```
</details>

<details>
   <summary>Binding by rows</summary>
   
   ### Binding by rows
   
   The old R's `rbind()` is a true workhorse of tabular data manipulation. Yet, on occasions, `rbind()` is too strict: what about stitching two data frames with non-overlapping or partially overlapping variable sets? There are also situations when, `rbind()` is not strict enough, i.e. you intend to include in the result only the variables shared by both input data frames. For such tasks, `full_rbind()` and `inner_rbind()` are implemented, which take a broad range of arguments: vectors, matrices and data frames:
   
   ```r
   
   ## overlapping variable sets
   
   full_rbind(my_cars, my_cars2)
   
   # A tibble: 64 × 13
   cars                mpg   cyl  disp    hp  drat    wt  qsec  gear  carb    vs    am  ncap
 * <chr>             <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int>
 1 Mazda RX4          21       6  160    110  3.9   2.62  16.5     4     4    NA    NA    NA
 2 Mazda RX4 Wag      21       6  160    110  3.9   2.88  17.0     4     4    NA    NA    NA
 3 Datsun 710         22.8     4  108     93  3.85  2.32  18.6     4     1    NA    NA    NA
 4 Hornet 4 Drive     21.4     6  258    110  3.08  3.22  19.4     3     1    NA    NA    NA
 5 Hornet Sportabout  18.7     8  360    175  3.15  3.44  17.0     3     2    NA    NA    NA
 6 Valiant            18.1     6  225    105  2.76  3.46  20.2     3     1    NA    NA    NA
 7 Duster 360         14.3     8  360    245  3.21  3.57  15.8     3     4    NA    NA    NA
 8 Merc 240D          24.4     4  147.    62  3.69  3.19  20       4     2    NA    NA    NA
 9 Merc 230           22.8     4  141.    95  3.92  3.15  22.9     4     2    NA    NA    NA
10 Merc 280           19.2     6  168.   123  3.92  3.44  18.3     4     4    NA    NA    NA
# … with 54 more rows
# ℹ Use `print(n = ...)` to see more rows

inner_rbind(my_cars, my_cars2)

# A tibble: 64 × 9
     mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
 * <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1  21       6  160    110  3.9   2.62  16.5     4     4
 2  21       6  160    110  3.9   2.88  17.0     4     4
 3  22.8     4  108     93  3.85  2.32  18.6     4     1
 4  21.4     6  258    110  3.08  3.22  19.4     3     1
 5  18.7     8  360    175  3.15  3.44  17.0     3     2
 6  18.1     6  225    105  2.76  3.46  20.2     3     1
 7  14.3     8  360    245  3.21  3.57  15.8     3     4
 8  24.4     4  147.    62  3.69  3.19  20       4     2
 9  22.8     4  141.    95  3.92  3.15  22.9     4     2
10  19.2     6  168.   123  3.92  3.44  18.3     4     4
# … with 54 more rows
# ℹ Use `print(n = ...)` to see more rows

## non-overlapping variable sets

full_rbind(my_cars[1:3], my_cars[6:7])

# A tibble: 64 × 5
   cars                mpg   cyl  drat    wt
   <chr>             <dbl> <dbl> <dbl> <dbl>
 1 Mazda RX4          21       6    NA    NA
 2 Mazda RX4 Wag      21       6    NA    NA
 3 Datsun 710         22.8     4    NA    NA
 4 Hornet 4 Drive     21.4     6    NA    NA
 5 Hornet Sportabout  18.7     8    NA    NA
 6 Valiant            18.1     6    NA    NA
 7 Duster 360         14.3     8    NA    NA
 8 Merc 240D          24.4     4    NA    NA
 9 Merc 230           22.8     4    NA    NA
10 Merc 280           19.2     6    NA    NA
# … with 54 more rows
# ℹ Use `print(n = ...)` to see more rows

inner_rbind(my_cars[1:3], my_cars[6:7])

data frame with 0 columns and 0 rows
   
   ```
   
</details>

<details>
   <summary>Splitting by a factor</summary>
   
   ### Splitting by a factor
   
   Splitting of a data frame is accomplished by `blast()`, which takes one or more splitting variables in a quoted or unquoted form:
   
   ```r
   
   ## splitting: a variable name vector and an unquoted argument
   
   my_cars %>% 
    blast(all_of(c('cyl', 'gear')),
          carb)
          
   $`4.3.1`
# A tibble: 1 × 10
  cars            mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Toyota Corona  21.5     4  120.    97   3.7  2.46  20.0     3     1

$`6.3.1`
# A tibble: 2 × 10
  cars             mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>          <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Hornet 4 Drive  21.4     6   258   110  3.08  3.22  19.4     3     1
2 Valiant         18.1     6   225   105  2.76  3.46  20.2     3     1

$`4.4.1`
# A tibble: 4 × 10
  cars             mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>          <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Datsun 710      22.8     4 108      93  3.85  2.32  18.6     4     1
2 Fiat 128        32.4     4  78.7    66  4.08  2.2   19.5     4     1
3 Toyota Corolla  33.9     4  71.1    65  4.22  1.84  19.9     4     1
4 Fiat X1-9       27.3     4  79      66  4.08  1.94  18.9     4     1

$`8.3.2`
# A tibble: 4 × 10
  cars                mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>             <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Hornet Sportabout  18.7     8   360   175  3.15  3.44  17.0     3     2
2 Dodge Challenger   15.5     8   318   150  2.76  3.52  16.9     3     2
3 AMC Javelin        15.2     8   304   150  3.15  3.44  17.3     3     2
4 Pontiac Firebird   19.2     8   400   175  3.08  3.84  17.0     3     2

$`4.4.2`
# A tibble: 4 × 10
  cars          mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Merc 240D    24.4     4 147.     62  3.69  3.19  20       4     2
2 Merc 230     22.8     4 141.     95  3.92  3.15  22.9     4     2
3 Honda Civic  30.4     4  75.7    52  4.93  1.62  18.5     4     2
4 Volvo 142E   21.4     4 121     109  4.11  2.78  18.6     4     2

$`4.5.2`
# A tibble: 2 × 10
  cars            mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Porsche 914-2  26       4 120.     91  4.43  2.14  16.7     5     2
2 Lotus Europa   30.4     4  95.1   113  3.77  1.51  16.9     5     2

$`8.3.3`
# A tibble: 3 × 10
  cars          mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Merc 450SE   16.4     8  276.   180  3.07  4.07  17.4     3     3
2 Merc 450SL   17.3     8  276.   180  3.07  3.73  17.6     3     3
3 Merc 450SLC  15.2     8  276.   180  3.07  3.78  18       3     3

$`8.3.4`
# A tibble: 5 × 10
  cars                  mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>               <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Duster 360           14.3     8   360   245  3.21  3.57  15.8     3     4
2 Cadillac Fleetwood   10.4     8   472   205  2.93  5.25  18.0     3     4
3 Lincoln Continental  10.4     8   460   215  3     5.42  17.8     3     4
4 Chrysler Imperial    14.7     8   440   230  3.23  5.34  17.4     3     4
5 Camaro Z28           13.3     8   350   245  3.73  3.84  15.4     3     4

$`6.4.4`
# A tibble: 4 × 10
  cars            mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Mazda RX4      21       6  160    110  3.9   2.62  16.5     4     4
2 Mazda RX4 Wag  21       6  160    110  3.9   2.88  17.0     4     4
3 Merc 280       19.2     6  168.   123  3.92  3.44  18.3     4     4
4 Merc 280C      17.8     6  168.   123  3.92  3.44  18.9     4     4

$`8.5.4`
# A tibble: 1 × 10
  cars             mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>          <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Ford Pantera L  15.8     8   351   264  4.22  3.17  14.5     5     4

$`6.5.6`
# A tibble: 1 × 10
  cars           mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Ferrari Dino  19.7     6   145   175  3.62  2.77  15.5     5     6

$`8.5.8`
# A tibble: 1 × 10
  cars            mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Maserati Bora    15     8   301   335  3.54  3.57  14.6     5     8
   
   ```
      
</details>

<details>
   <summary>Regular expression search</summary>
   
   ### Regular expression search
   
   The `reglook()` function enables for selecting data frame records with a regular expression match. All or user-specified variables may be searched:
   
   ```r
   
   ## let's select all Hondas and Mercedes from the 'cars' data set:
   
   reglook(my_cars,
          regex = '^(Merc|Honda)')
          
   # A tibble: 8 × 10
  cars          mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
  <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1 Merc 240D    24.4     4 147.     62  3.69  3.19  20       4     2
2 Merc 230     22.8     4 141.     95  3.92  3.15  22.9     4     2
3 Merc 280     19.2     6 168.    123  3.92  3.44  18.3     4     4
4 Merc 280C    17.8     6 168.    123  3.92  3.44  18.9     4     4
5 Merc 450SE   16.4     8 276.    180  3.07  4.07  17.4     3     3
6 Merc 450SL   17.3     8 276.    180  3.07  3.73  17.6     3     3
7 Merc 450SLC  15.2     8 276.    180  3.07  3.78  18       3     3
8 Honda Civic  30.4     4  75.7    52  4.93  1.62  18.5     4     2

  ## or all cars with 4- or 6-cylinder engines
  
   reglook(my_cars,
          regex = '4|6', 
          keys = 'cyl')
          
   # A tibble: 18 × 10
   cars             mpg   cyl  disp    hp  drat    wt  qsec  gear  carb
   <chr>          <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1 Mazda RX4       21       6 160     110  3.9   2.62  16.5     4     4
 2 Mazda RX4 Wag   21       6 160     110  3.9   2.88  17.0     4     4
 3 Datsun 710      22.8     4 108      93  3.85  2.32  18.6     4     1
 4 Hornet 4 Drive  21.4     6 258     110  3.08  3.22  19.4     3     1
 5 Valiant         18.1     6 225     105  2.76  3.46  20.2     3     1
 6 Merc 240D       24.4     4 147.     62  3.69  3.19  20       4     2
 7 Merc 230        22.8     4 141.     95  3.92  3.15  22.9     4     2
 8 Merc 280        19.2     6 168.    123  3.92  3.44  18.3     4     4
 9 Merc 280C       17.8     6 168.    123  3.92  3.44  18.9     4     4
10 Fiat 128        32.4     4  78.7    66  4.08  2.2   19.5     4     1
11 Honda Civic     30.4     4  75.7    52  4.93  1.62  18.5     4     2
12 Toyota Corolla  33.9     4  71.1    65  4.22  1.84  19.9     4     1
13 Toyota Corona   21.5     4 120.     97  3.7   2.46  20.0     3     1
14 Fiat X1-9       27.3     4  79      66  4.08  1.94  18.9     4     1
15 Porsche 914-2   26       4 120.     91  4.43  2.14  16.7     5     2
16 Lotus Europa    30.4     4  95.1   113  3.77  1.51  16.9     5     2
17 Ferrari Dino    19.7     6 145     175  3.62  2.77  15.5     5     6
18 Volvo 142E      21.4     4 121     109  4.11  2.78  18.6     4     2
   
   ```
   
</details>

<details>
   <summary>Shifting elements and observations to object's head or tail</summary>

   ### Shifting elements and observations to object's head or tail

   Selected elements of a vector or list, or rows (observations) of a matrix or a data frame can be placed at the start or end of the object by `to_head()` and `to_tail()` functions. The elements of interest are specified by their names or numeric 
   indexes provided as argument `idx`. Of note, for `tibble`-type data frames, the rows can be selected only be their numeric indexes, because no proper row names are specified.

   ```r
   >  to_head(LETTERS, 3:1)
   [1] "C" "B" "A" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"

   > LETTERS %>%
   +     set_names(letters) %>%
   +     as.list %>%
   +     to_tail(c('a', 'e', 'f'))
   $b
   [1] "B"
   
   $c
   [1] "C"
   
   $d
   [1] "D"
   
   $g
   [1] "G"
   ...

   ```

   ```r
   >  my_mtx %>%
   +     to_head(c(18:20))
                   Variable_1   Variable_2  Variable_3  Variable_4  Variable_5
   observation_18  0.54144139  0.188512771 -0.15845579 -0.59379910  0.58726920
   observation_19  0.99747435  0.852079146  0.56223328  0.34464871  0.59095188
   observation_20  0.01338146 -1.300079990 -1.03736588  0.73172475 -0.78438382
   observation_1   1.74917342  1.841585213 -0.72855502 -0.15791366 -0.25368660
   observation_2   0.34125006  2.304558957  0.13467292 -0.59610794 -1.04144678
   observation_3   1.25744053 -0.134402690 -0.44930696 -0.37991677 -0.20558190
   observation_4  -0.20171298 -1.129932197 -0.45361832 -0.25222060  0.05913106
   observation_5  -0.11859044 -0.161595255  0.36501183  0.84225715  0.55960379
   observation_6  -0.09186492  0.630664452 -0.04490899  0.67862906  0.22213782
   observation_7  -0.71574783 -0.361036632  0.75234665 -0.90272197 -0.72557420
   observation_8  -0.52140859 -0.029994349 -0.29700052  0.06922502  0.65082628
   observation_9   1.70093482  1.965273873  0.62394243 -0.74644210 -0.47977351
   observation_10 -1.05957384 -0.601316916 -0.46642284 -0.08729120 -0.48048921
   observation_11 -1.51988417  0.179123522 -0.50917556  0.54617818  0.64149694
   observation_12 -0.40467420 -0.001024131  0.20711946  0.35630623 -0.10139631
   observation_13  0.51779940  0.777677045 -0.36602947  0.10311450  0.69803339
   observation_14  1.29022596 -1.045945193 -0.38414965 -0.35493968  0.72429803
   observation_15  2.08695849  2.005975783  0.04081810  0.17941365  0.23014337
   observation_16  0.97935507  1.770274234 -0.94615862 -0.74258929 -1.33298849
   observation_17  1.60565852 -1.455057386  3.52074159 -0.23761748  0.45604834
   ```

   ```r
      > my_mtx %>%
   +     to_tail(paste0('observation_', 1:5))
                   Variable_1   Variable_2  Variable_3  Variable_4  Variable_5
   observation_6  -0.09186492  0.630664452 -0.04490899  0.67862906  0.22213782
   observation_7  -0.71574783 -0.361036632  0.75234665 -0.90272197 -0.72557420
   observation_8  -0.52140859 -0.029994349 -0.29700052  0.06922502  0.65082628
   observation_9   1.70093482  1.965273873  0.62394243 -0.74644210 -0.47977351
   observation_10 -1.05957384 -0.601316916 -0.46642284 -0.08729120 -0.48048921
   observation_11 -1.51988417  0.179123522 -0.50917556  0.54617818  0.64149694
   observation_12 -0.40467420 -0.001024131  0.20711946  0.35630623 -0.10139631
   observation_13  0.51779940  0.777677045 -0.36602947  0.10311450  0.69803339
   observation_14  1.29022596 -1.045945193 -0.38414965 -0.35493968  0.72429803
   observation_15  2.08695849  2.005975783  0.04081810  0.17941365  0.23014337
   observation_16  0.97935507  1.770274234 -0.94615862 -0.74258929 -1.33298849
   observation_17  1.60565852 -1.455057386  3.52074159 -0.23761748  0.45604834
   observation_18  0.54144139  0.188512771 -0.15845579 -0.59379910  0.58726920
   observation_19  0.99747435  0.852079146  0.56223328  0.34464871  0.59095188
   observation_20  0.01338146 -1.300079990 -1.03736588  0.73172475 -0.78438382
   observation_1   1.74917342  1.841585213 -0.72855502 -0.15791366 -0.25368660
   observation_2   0.34125006  2.304558957  0.13467292 -0.59610794 -1.04144678
   observation_3   1.25744053 -0.134402690 -0.44930696 -0.37991677 -0.20558190
   observation_4  -0.20171298 -1.129932197 -0.45361832 -0.25222060  0.05913106
   observation_5  -0.11859044 -0.161595255  0.36501183  0.84225715  0.55960379

   ```

   ```r
    >  my_cars2 %>%
   +     to_head(8:14)
                        mpg cyl  disp  hp drat    wt  qsec vs am gear carb ncap
   Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2    9
   Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2    4
   Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4    4
   Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4    8
   Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3    8
   Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3    2
   Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3    6
   Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4    8
   Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4    1
   Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1   NA
   Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1   NA
   Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2    9
   Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1    6
   Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4    2
   Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4    6
   Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4    4
   Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4    4
   Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1    8
   Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2    6
   Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1    5
   Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1    2
   Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2    1
   AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2    3
   Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4    5
   Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2   NA
   Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1    2
   Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2   10
   Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2    4
   Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4    1
   Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6    6
   Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8    5
   Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2    3
   ```
   ```r
   > my_cars2 %>%
   +     to_tail(c('Merc 240D', 'Chrysler Imperial'))
                        mpg cyl  disp  hp drat    wt  qsec vs am gear carb ncap
   Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4    8
   Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4    1
   Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1   NA
   Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1   NA
   Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2    9
   Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1    6
   Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4    2
   Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2    4
   Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4    4
   Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4    8
   Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3    8
   Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3    2
   Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3    6
   Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4    6
   Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4    4
   Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1    8
   Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2    6
   Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1    5
   Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1    2
   Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2    1
   AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2    3
   Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4    5
   Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2   NA
   Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1    2
   Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2   10
   Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2    4
   Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4    1
   Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6    6
   Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8    5
   Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2    3
   Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2    9
   Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4    4
   ``` 

</details>

## Terms of use

The package is available under a [GPL-3 license](https://github.com/PiotrTymoszuk/trafo/blob/main/LICENSE).

## Contact

The package maintainer is [Piotr Tymoszuk](mailto:piotr.s.tymoszuk@gmail.com).

## Acknowledgements

`trafo` uses tools provided by the [rlang](https://rlang.r-lib.org/), [tidyverse](https://www.tidyverse.org/) and [stringi](https://stringi.gagolewski.com/)
