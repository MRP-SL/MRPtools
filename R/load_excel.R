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
load_excel <- function(path, sheets = "all", ...) {

    readr::type_convert(concat_excel_sheets(path = path, sheets = sheets, ...))

}
