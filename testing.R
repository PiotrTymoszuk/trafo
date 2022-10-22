
# Example data ------

  my_cars <- tibble::rownames_to_column(mtcars, 'cars')

  my_cars2 <-
    dplyr::mutate(mtcars,
                  ncap = sample(c(1:10, NA), nrow(mtcars), replace = TRUE))

  my_cars <- dplyr::select(my_cars2, -vs, -am)

  my_cyl_mtx <- matrix(sample(1:8, 20, replace = TRUE), nrow = 2, ncol = 10)

  cyl_reco <- tibble::tibble(cyl = c(4, 6, 8, 10, 12),
                             cyl_lab = c('4-cylinder',
                                         '6-cylinder',
                                         '6+ cylinder',
                                         '6+-cylinder',
                                         '6+-cylinder'))

  my_cyl_list <- list('A' = sample(1:8, 20, replace = TRUE),
                      'B' = sample(1:8, 20, replace = TRUE),
                      'C' = matrix(c(12, 4, 8, 10),
                                   c(6, 4, 8, 10),
                                   ncol = 2),
                      'D' = my_cars)

# Exchanging -------

  exchange(my_cars,
           variable = 'cyl',
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
           variable = 'cyl')

  exchange(my_cyl_mtx,
           dict = cyl_reco,
           key = 'cyl',
           value = 'cyl_lab')

# Row names -------

  set_rownames(my_cars,
               paste0('row_', 1:nrow(my_cars)))

# Compression -------

  compress(exchange(sample(1:10, 12, replace = TRUE),
                    dict = cyl_reco,
                    key = 'cyl',
                    value = 'cyl_lab'))

  compress(my_cyl_list,
           names_to = 'lst_names',
           values_to = 'lst_elements',
           simplify = TRUE)

  compress(plyr::dlply(mtcars,
                       'cyl',
                       tibble::rownames_to_column,
                       'car'))

# Binding ----

  full_rbind(my_cars, my_cars2)

  inner_rbind(my_cars, my_cars2)

# Complete observation series ------

  complete_cases(my_cars2, id_variable = 'cyl')
