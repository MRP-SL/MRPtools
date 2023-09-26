add_country_names <- function(x, country_code_column) {

    join_col <- rlang::enquo(country_code_column)

    output <- x |>
        dplyr::left_join(MRPtools::COUNTRY_CODES,
                        by = dplyr::join_by("join_col" == "CODE")) |>
        dplyr::relocate("COUNTRY", .after = "join_col")
}
