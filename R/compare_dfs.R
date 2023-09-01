
compare_dfs <- function(df1, df2, metric) {
    # Compares two data.frames using a function that when applied to each row,
    # returns a value that can be compared.

    stopifnot("df1 and df2 must be data.frames" = is.data.frame(df1) & is.data.frame(df2))

    test_value_1 <- map(df1, metric)
    test_value_2 <- map(df2, metric)

    shared_cols = names(df1)[names(df1) %in% names(df2)]
    df1_unique_cols = names(df1)[!(names(df1) %in% names(df2))]
    df2_unique_cols = names(df2)[!(names(df2) %in% names(df1))]

    print(paste("Unique Columns in df1:", df1_unique_cols))
    print(paste("Unique Columns in df2:", df2_unique_cols))

    for (col in shared_cols) {
        print(test_value_1[[col]] == test_value_2[[col]])
    }
}
