test_that("Load sample ASYCUDA data.", {
  expect_equal(readRDS("../data/example-data-full.rds"),
               load_excel("../data/example-data-full.xlsx"))
})


test_that("Loading sample ASYCUDA data, silently, integer index subset.", {
    expect_equal(readRDS("../data/example-data-subset.rds"),
                 load_excel("../data/example-data-full.xlsx", quiet = TRUE, sheets = c(2:4, 7)))
})


test_that("Loading sample ASYCUDA data, name index subset.", {
    expect_equal(readRDS("../data/example-data-subset.rds"),
                 load_excel("../data/example-data-full.xlsx", sheets = c("February", "March", "April", "July")))
})

