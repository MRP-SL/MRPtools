load_directory <- function(dir, file_type = "excel", sheets = "all", ...) {
    # Read and append all Excel files in a directory using readr::read_excel().
    # Sheets specifies which sheets in each of the Excel files within the
    # directory should be used. Use ... to pass additional arguments to read_excel.

    require(dplyr)

    stopifnot("the supplied directory does not exist" = dir.exists(dir))
    stopifnot("'sheets' must be a character vector of names or numeric vector of indices" = is.character(sheets) | is.numeric(sheets))

    filepaths <- list.files(dir, full.names = TRUE)

    for (file in filepaths) {
        if (exists("output")) {
            output <- dplyr::bind_rows(
                output,
                concat_excel_sheets(file, sheets = sheets, ...)
            )
        } else {
            output <- concat_excel_sheets(file, sheets = sheets, ...)
        }
    }

    readr::type_convert(output)

}
