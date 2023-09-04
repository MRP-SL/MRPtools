#' load_delim_directory
#' @description
#' Read and append all delimited files in a directory. Use ... to pass additional arguments to readr::read_delim(), which is used under the hood.
#'
#' @param dir The directory in which to load all files.
#' @param delim Single character used to separate fields within a record.
#' @param quiet Silences printing progress to the console.
#' @param ... (Optional) To pass additional arguments to read_excel().
#'
#' @return A tibble containing the merged observations from the selected sheets.
#' @export
#'
#' @examples
load_delim_directory <- function(dir, delim, quiet = FALSE, ...) {

    stopifnot("the supplied directory does not exist" = dir.exists(dir))
    stopifnot("delim must be a single character" = length(delim) == 1 & nchar(delim) == 1)

    filepaths <- list.files(dir, full.names = TRUE)

    for (file in filepaths) {
        if (exists("output")) {
            if (!quiet) {print(paste("Loading:", file))}
            output <- dplyr::bind_rows(
                output,
                readr::read_delim(file, delim = delim, ...)
            )
        } else {
            if (!quiet) {print(paste("Loading:", file))}
            output <- readr::read_delim(file, delim = delim, ...)
        }
    }

    readr::type_convert(output)

}
