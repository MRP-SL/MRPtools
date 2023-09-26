#' load_excel
#'
#' @description
#' Read and append sheets within an Excel file. Optionally, you can specify which sheets should be loaded using a vector of indices of sheet names. Use ... to pass additional arguments to readxl::read_excel(), which is used under the hood.
#'
#' @param path The Excel file to load.
#' @param sheets A numeric or character vector of indices for sheets, or "all".
#' @param quiet Silences printing progress to the console.
#' @param ... (Optional) To pass additional arguments to read_excel().
#'
#' @return A tibble containing the merged observations from the selected sheets.
#' @export
#'
#' @examples
#' # Load all sheets
#' qa_2022 <- load_excel("queries_amendments_2022.xlsx")
#'
#' # Load only the sheet titled 'January' or 'February'
#' qa_2022 <- load_excel("queries_amendments_2022.xlsx", sheets = c("January", "February"))
#'
#' # Load only the 4rd to 6th sheet, passing the 'guess_max' argument to readxl
#' qa_q2_2022 <- load_excel("queries_amendments_2022.xlsx", sheets = 4:6, guess_max = 100000)
#'
load_excel <- function(path, sheets = NULL, quiet = FALSE, ...) {

    if (quiet) {
        withr::with_options(
          new = list(readr.show_col_types = FALSE),
          readr::type_convert(concat_excel_sheets(path = path, sheets = sheets, quiet = quiet, ...))
        )
    } else {
        readr::type_convert(concat_excel_sheets(path = path, sheets = sheets, quiet = quiet, ...))
    }

}
