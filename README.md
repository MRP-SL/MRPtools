
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MRPtools

<!-- badges: start -->
<!-- badges: end -->

MRPtools provides a set of convenience functions that solve common
challenges when working with data in the Monitoring, Research and
Planning Department. the `load_*` family of functions iterate over a
directory of alike files and append each of the files together. If the
files are Excel files, they also allow the user to specify which sheets
(by default all) should be included. These functions are primarily
designed for loading exports from ASYCUDA/ITAS/ECR systems, although
they will work whenever the supplied sheets have consistently-named
variables.

In the near-future, additional tools for loading data from NRA’s Data
Warehouse will also be added here.

## Installation

You can install MRPtools from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("MRP-SL/MRPtools")
```

## Loading Exports Stored Locally

MRPtools provides several functions to enable quick importing of files
stores locally.

    library(MRPtools)


    # load_directory reads all files of the appropriate type within a directory
    excel_dir <- load_directory("data/excel", type = "excel")
    csv_dir <- load_directory("data/csv", type = "csv")
    csv_dir2 <- load_directory("data/csv", type = "delim", delim = ",")


    # Alternatively, to read a single Excel file: 
    all_sheets <- load_excel("data/examle-data-subset.xlsx")


    # For both directories or single files, you can specify specific sheets to load
    one_two <- load_excel("data/example-data-subset.xlsx", sheets = 1:2)
    jan_feb <- load_excel("data/example-data-subset.xlsx", sheets = c("January", "February"))

    all.equal(own_two, jan_feb)  # Evaluates to TRUE


    # Under the hood, these functions call readxl::read_excel or readr::read_delim
    # You can supply additional arguments to these functions using '...'
    load_directory("data/excel", type = "excel", sheets = 1, skip = 3)

## Connecting to Databases

MRPtools also provides utilities for connecting to databases, including
the NRA’s own Data Warehouse. Currently, these functions have been
tested against the Data Warehouse. Further work is required to ensure
they also work with ITAS/ASYCUDA/ECR production databases, although in
principle they should.

    # Connect to the Data Warehouse

    # The first time, you need to save the db configurations and credentials.
    # This will prompt you to enter your username and password, which is stored in local secure storage.
    setup_database_connection(database = "NRADWH", host = <ip_address>, driver = <driver>)

    # Each time you start R, you'll need to open a connection with the DWH.
    NRADWH <- establish_db_connection(database = "NRADWH")

    # Using this connection object you can then make queries using specific functions with a fetch_ prefix
    returns_q3 <- fetch_itas_returns(NRADWH, tax_period = c("2022-01-01", "2022-12-31"))

    # See the documentation for details 
    ?fetch_itas_returns

    # Under the hood, establish_db_connection uses DBI::dbConnect(). This means that 
    # you can also use functions from DBI to run queries. (See package for details).

    # For example, to execute arbitrary SQL, run:
    example <- DBI::dbGetQuery(NRADWH, "SELECT * FROM <table_name> WHERE <condition> ...)
