
concat_excel_sheets <- function(path, sheets = "all", ...) {

    # Concatenates specified sheets within a Excel file. It does not infer
    # data-types to facilitate binding sheets Use readr::type_convert() to
    # guess column types. Use ... to pass additional arguments to read_excel().

    require(readxl)
    require(dplyr)

    # Check if user-supplied sheets exist in the Excel file
    if (sheets != "all" & is.character(sheets)) {
        file_sheets = readxl::excel_sheets(path)
        stopifnot("at least one supplied sheet name not found in Excel file" =
                      all(sheets %in% file_sheets))
    } else if (is.numeric(sheets)) {
        stopifnot("numeric index contains value large than highest-numbered Excel sheet" =
                      max(sheets) <= length(readxl::excel_sheets(path)))
    }

    # We loop over all sheets if user specifies "all"
    if (sheets == "all") {
        sheets <- readxl::excel_sheets(path)
    }

    i = 2
    print(paste("Loading:", path))

    for (sheet in sheets) {
        if (exists("output")) {
            print(paste("...Sheet", i))
            i = i + 1
            output <- dplyr::bind_rows(
                output,
                readxl::read_excel(path = path, sheet = sheet, col_types = "text", ...)
            )
        } else {
            print("...Sheet 1")
            output <- readxl::read_excel(path = path, sheet = sheet, col_types = "text", ...)
        }
    }
    return(output)
}
