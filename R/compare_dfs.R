
#' compare_dfs
#'
#' @description
#' Compares two data.frames using a function that when applied to each row, returns a value that can be compared.
#'
#'
#' @param df1 First data.frame for comparison
#' @param df2 Second data.frame for comparison
#' @param metric Function name or anonymous function that returns a value that can be compared.
#'
#' @return A named logical vector indicating if the metric evaluated to the same result for each column.
#' @import purrr
#' @export
#'
#' @examples
compare_dfs <- function(df1, df2, metric) {
    # NOTE: May need to use quasiquotation for this to work...

    stopifnot("df1 and df2 must be data.frames" = is.data.frame(df1) & is.data.frame(df2))

    test_values_1 <- purrr::map(df1, metric)
    test_values_2 <- purrr::map(df2, metric)

    shared_cols = names(df1)[names(df1) %in% names(df2)]
    df1_unique_cols = names(df1)[!(names(df1) %in% names(df2))]
    df2_unique_cols = names(df2)[!(names(df2) %in% names(df1))]

    print(paste("Unique Columns in df1:", df1_unique_cols))
    print(paste("Unique Columns in df2:", df2_unique_cols))

    comparison <- test_values_1[shared_cols] == test_values_2[shared_cols]
    names(comparison) <- shared_cols

    return(comparison)

}
