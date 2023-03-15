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

## Terms of use

The package is available under a [GPL-3 license](https://github.com/PiotrTymoszuk/trafo/blob/main/LICENSE).

## Contact

The package maintainer is [Piotr Tymoszuk](mailto:piotr.s.tymoszuk@gmail.com).

## Acknowledgements

`trafo` uses tools provided by the [rlang](https://rlang.r-lib.org/), [tidyverse](https://www.tidyverse.org/) and [stringi](https://stringi.gagolewski.com/)
