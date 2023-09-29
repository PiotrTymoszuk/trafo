# tools -----

  library(trafo)
  library(plyr)
  library(tidyverse)

# Example data ------

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

  my_mtx <- matrix(rnorm(100),
                   nrow = 20,
                   ncol = 5)

  my_mtx2 <- matrix(rnorm(100),
                    nrow = 5,
                    ncol = 20)


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


# Exchanging -------

  exchange(my_cars,
           variable = cyl,
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab')

  exchange(sample(1:8, 4),
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab')

  exchange(my_cyl_list,
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab',
           variable = cyl)

  exchange(my_cyl_mtx,
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab')

# Row and column names -------

  set_rownames(my_cars,
               paste0('row_', 1:nrow(my_cars)))

  my_mtx <- set_rownames(my_mtx,
                         paste0('observation_', 1:nrow(my_mtx)))

  my_mtx <- set_colnames(my_mtx,
                         paste0('Variable_', 1:ncol(my_mtx)))

  my_mtx2 <- set_rownames(my_mtx2,
                         paste0('record_', 1:nrow(my_mtx2)))

  my_mtx2 <- set_colnames(my_mtx2,
                          paste0('Variable_', 1:ncol(my_mtx2)))

# Compression -------

  compress(exchange(sample(1:10, 12, replace = TRUE),
                    dict = cyl_reco,
                    key = 'cyl',
                    value = 'cyl_lab'))

  compress(my_cyl_list,
           names_to = 'lst_names',
           values_to = 'lst_elements',
           simplify = TRUE)

    my_cars %>%
      dlply('cyl') %>%
      compress(names_to = 'cyl') %>%
      as_tibble

    c('4' = '4-cylinder',
      '6' = '6-cylinder',
      '8' = '6+ cylinder',
      '10' = '6+-cylinder',
      '12' = '6+-cylinder') %>%
      compress(names_to = 'cyclinder_number',
               values_to = 'cylinder_category')


# Binding ----

  ## full

  full_rbind(my_cars, my_cars2)

  full_rbind(my_cars[1:3], my_cars[6:7])

  full_rbind(my_mtx, my_mtx2)

  full_rbind(my_mtx[, 1:2], my_mtx[, 4:5])

  full_rbind(my_mtx[1:9, 1], my_mtx[6:12, 1])

  full_rbind(my_mtx,
             set_colnames(matrix(LETTERS[1:20],
                                 ncol = 10),
                          paste0('Variable_', 1:10)))

  ## inner

  inner_rbind(my_cars, my_cars2)

  inner_rbind(my_cars[1:3], my_cars[6:7])

  inner_rbind(my_mtx, my_mtx2)

  inner_rbind(my_mtx[, 1:2], my_mtx[, 4:5])

  inner_rbind(my_mtx[1:9, 1], my_mtx[6:12, 1])

  inner_rbind(my_mtx[1:9, 1], my_mtx[11:12, 1])

  inner_rbind(my_mtx,
              set_colnames(matrix(LETTERS[1:20],
                                  ncol = 10),
                           paste0('Variable_', 1:10)))

# Splitting ---------

  my_cars %>%
    blast(all_of(c('cyl', 'gear')),
          carb)

  blast(my_cars, c('cyl', 'gear'))

  blast.data.frame(my_cars, cyl, carb, .skip = TRUE)

# Regular expression search -----

  reglook(my_cars,
          regex = '^(Merc|Honda)')

  reglook(my_cars,
          regex = '4|6',
          keys = 'cyl')

# Complete observation series ------

  complete_cases(my_cars2, 'cyl')

  complete_cases(my_cars2, gear, .skip = TRUE)

# END -------
