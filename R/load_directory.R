#' Load All Files in a Directory
#'
#' @description
#' Read and append all files of type 'excel', 'csv', or 'delim'. It uses readr::read_csv() or readxl::read_excel() under the hood. Optionally, if 'type' is "Excel", you can specify which sheets should be loaded. Use ... to pass additional arguments to 'readr' or 'readxl'. Type 'csv' is a convenience wrapper and calls the same readr::read_delim() as does type 'delim'. Using type 'delim' requires that you additionally specify a value for delim. When specifying the type as 'delim', any file format that can be parsed by readr::read_delim() is accepted. See also MRPtools::load_excel() and MRPtools::load_delim_directory().
#'
#' @param dir The directory to load.
#' @param type Type of files within the supplied directory. Either "excel" or "csv".
#' @param quiet (Optional) Silences printing progress to the console.
#' @param sheets (Optional) A numeric vector of indices or a character vector of names for the sheets to use.
#' @param delim (Optional) Required if type is 'delim'. Single character used to separate fields within a record.
#' @param ... (Optional) To pass additional arguments to read_excel().
#'
#' @return A tibble containing the merged observations from the selected files and sheets.
#' @export
#'
#' @examples
#' # Load all csv files in a directory
#' exports <- load_directory("path/to/csv_files/", type = "csv")
#'
#' # Load all Excel files in a directory
#' exports <- load_directory("path/to/excel_files/", type = "excel")
#'
load_directory <- function(dir, type, quiet = FALSE, sheets = NULL, delim = NULL, ...) {

    stopifnot("only types 'excel', 'csv', and 'delim' are supported" = type == "excel" | type == "csv" | type == "delim")

    filepaths <- list.files(dir, full.names = TRUE)

    if (type == "excel") {
        stopifnot("all files in dir must be '.xsl' or '.xlsx' when type is 'excel'" = grepl(pattern = "\\.xls[x]?$", x = filepaths))
    } else if (type == "csv") {
        stopifnot("all files in dir must be '.csv' when type is 'csv'" = grepl(pattern = "\\.csv$", x = filepaths))
    }

    # split and take last entry, then assert all are of type type

    if (type == "excel") {
        load_excel_directory(dir, sheets = sheets, quiet = quiet, ...)
    } else if (type == "csv") {
        load_delim_directory(dir, delim = ",", quiet = quiet, ...)
    } else {
        load_delim_directory(dir, delim = delim, quiet = quiet, ...)
    }
}
