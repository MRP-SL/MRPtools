#' load_excel
#'
#' @description
#' Read and append sheets within an Excel file. Optionally, you can specify which sheets should be loaded using a vector of indices of sheet names. Use ... to pass additional arguments to readxl::read_excel(), which is used under the hood.
#'
#' @param path The Excel file to load.
#' @param sheets (Optional) A numeric vector of indices or a character vector of names for the sheets to use.
#' @param ... (Optional) To pass additional arguments to read_excel().
#'
#' @return A tibble containing the merged observations from the selected sheets.
#' @export
#'
#' @examples
#' df <- concat_excel_sheets("data/example.xlsx, sheets = "all")
#' df <- readr::type_convert(df)
load_excel <- function(path, sheets = "all", ...) {
    # Reads and appends specified sheets in an Excel file. Use 'sheets' to set
    # which sheets to use. Accepts a vector of indexes, sheet names, or "all".
    # Use ... to pass additional arguments to read_excel().

    require(readr, quietly = TRUE)

    stopifnot("file does not exist" = file.exists(path))
    stopifnot("'sheets' must be a character vector of names or numeric vector of indices" = is.character(sheets) | is.numeric(sheets))

    readr::type_convert(concat_excel_sheets(path = path, sheets = sheets, ...))
}
