# tools -----

  library(trafo)

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

  my_mtx <- matrix(rnorm(100),
                   nrow = 20,
                   ncol = 5)

  my_mtx2 <- matrix(rnorm(100),
                    nrow = 5,
                    ncol = 20)

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

  compress(plyr::dlply(mtcars,
                       'cyl',
                       tibble::rownames_to_column,
                       'car'))

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

  inner_rbind(tibble::as_tibble(my_cars),
              tibble::as_tibble(my_cars2))

  inner_rbind(my_cars[1:3], my_cars[5:8])

  inner_rbind(my_mtx, my_mtx2)

  inner_rbind(my_mtx[, 1:2], my_mtx[, 4:5])

  inner_rbind(my_mtx[1:9, 1], my_mtx[6:12, 1])

  inner_rbind(my_mtx[1:9, 1], my_mtx[11:12, 1])

  inner_rbind(my_mtx,
              set_colnames(matrix(LETTERS[1:20],
                                  ncol = 10),
                           paste0('Variable_', 1:10)))

# Splitting ---------

  blast(tibble::as_tibble(my_cars),
        dplyr::all_of(c('cyl', 'gear')),
        carb)

  blast(my_cars, c('cyl', 'gear'))

# Regular expression search -----

  reglook(tibble::rownames_to_column(my_cars, 'model'),
          regex = '^(Merc|Honda)')

# Complete observation series ------

  complete_cases(my_cars2, id_variable = 'cyl')

# END -------
