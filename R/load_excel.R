load_excel <- function(path, sheets = "all", ...) {
    # Reads and appends specified sheets in an Excel file. Use 'sheets' to set
    # which sheets to use. Accepts a vector of indexes, sheet names, or "all".
    # Use ... to pass additional arguments to read_excel().

    require(readr)

    stopifnot("file does not exist" = file.exists(path))
    stopifnot("'sheets' must be a character vector of names or numeric vector of indices" = is.character(sheets) | is.numeric(sheets))

    readr::type_convert(concat_excel_sheets(path = path, sheets = sheets, ...))
}
