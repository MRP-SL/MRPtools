add_country_names <- function(x, country_code_column) {

    join_col <- rlang::enquo(country_code_column)

    output <- x |>
        dplyr::left_join(MRPtools::country_codes,
                        by = dplyr::join_by("join_col" == "country_code")) |>
        dplyr::relocate("country_name", .after = "join_col")
}
