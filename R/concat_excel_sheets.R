#' concat_excel_sheets
#' @description
#' Concatenates selected sheets within an Excel file. It does not infer data-types to facilitate binding sheets Use readr::type_convert() to guess column types. Use ... to pass additional arguments to read_excel().
#'
#' @param path Path to the .xls or .xlsx document.
#' @param sheets A numeric vector of indices or a character vector of names for the sheets to use.
#' @param quiet Silences printing progress to the console.
#' @param ... (Optional) To pass additional arguments to read_excel().
#'
#' @return A tibble containing the merged observations from the selected sheets. All column data types are left as 'character' to facilitate when binding multiple Excel files.
#'
concat_excel_sheets <- function(path, sheets = NULL, quiet = FALSE, ...) {

    # Check if file exists and sheets param is permissible
    stopifnot("file does not exist" = file.exists(path))

    # Get names of every sheet in the file
    file_sheets <- readxl::excel_sheets(path)

    # Check if user-supplied sheets exist in the Excel file
    if (is.null(sheets)) {
        # We use all sheets by default
        sheets <- file_sheets
    } else if (is.character(sheets)) {
        # Ensure that all names in 'sheets' appear in Excel file
        stopifnot("at least one supplied sheet name not found in Excel file" =
                      all(sheets %in% file_sheets))
    } else if (is.numeric(sheets)) {
        # Replace numeric values with character names of sheets
        stopifnot("numeric index contains value large than highest-numbered Excel sheet" =
                      max(sheets) <= length(file_sheets))
        sheets <- file_sheets[sheets]
    } else {
        # If none of the above, the supplied value for sheets is not supported
        stop("Unsupported value for 'sheets'")
    }


    if (!quiet) {print(paste("Loading:", path))}

    for (sheet in sheets) {
        if (exists("output", inherits = FALSE)) {
            if(!quiet) {print(paste("...", sheet, sep = ""))}
            output <- dplyr::bind_rows(
                output,
                # Set to character for ease of joining.
                # Reading directly as character means dates interpreted weirdly.
                purrr::map_df(readxl::read_excel(path = path, sheet = sheet, ...), as.character)
            )
        } else {
            if (!quiet) {print(paste("...", sheet, sep = ""))}
            output <- purrr::map_df(readxl::read_excel(path = path, sheet = sheet, ...), as.character)
        }
    }

    return(output)
}
