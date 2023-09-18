#' load_excel_directory
#'
#'@description
#' Read and append all Excel files in a directory. Optionally, you can specify which sheets should be loaded using a vector of indices of sheet names. Use ... to pass additional arguments to readxl::read_excel(), which is used under the hood.
#'
#' @param dir The directory in which to load all files.
#' @param sheets A numeric vector of indices or a character vector of names for the sheets to use.
#' @param quiet Silences printing progress to the console.
#' @param ... (Optional) To pass additional arguments to read_excel().
#'
#' @return A tibble containing the merged observations from the selected sheets.
#' @export
#'
#' @examples
load_excel_directory <- function(dir, sheets = "all", quiet = FALSE, ...) {

    stopifnot("the supplied directory does not exist" = dir.exists(dir))

    filepaths <- list.files(dir, full.names = TRUE)

    for (file in filepaths) {
        if (exists("output", inherits = FALSE)) {
            output <- dplyr::bind_rows(
                output,
                concat_excel_sheets(file, sheets = sheets, quiet = quiet, ...)
            )
        } else {
            output <- concat_excel_sheets(file, sheets = sheets, quiet = quiet, ...)
        }
    }

    readr::type_convert(output)

}
