#' fetch_itas_account_statement
#'
#' @param db_con An active DBIConnection object, often created by 'establish_db_connection()'
#' @param tax_type (Optional) A vector or list of Tax Types to filter on. Options are: c("Excise Tax", "Foreign Travel Tax", "Rental Income Tax", "Personal Income Tax", "Suspense Account", "Goods and Services", "Pay As You Earn", "Withholding Tax", "Payroll Tax", "Capital Gains Tax", "Company Income Tax")
#' @param transaction_date (Optional) A vector or list where the first element is the start-date and second element the end-date
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
fetch_itas_account_statement <- function(db_con, tax_type = NULL, transaction_date = NULL) {

    # Permitted values for 'tax_type'
    tax_type_options <- c("Excise Tax", "Foreign Travel Tax", "Rental Income Tax",
                          "Personal Income Tax", "Suspense Account", "Goods and Services",
                          "Pay As You Earn", "Withholding Tax", "Payroll Tax",
                          "Capital Gains Tax", "Company Income Tax")

    # Verify database connection is valid
    stopifnot("Database connection is invalid." = DBI::dbIsValid(db_con))


    if (is.null(tax_type)) {

        # Verify user-supplied Tax Types are valid
        stopifnot("Some Tax Types invalid. Run '?get_itas_account_statement' for a list of valid types." =
                      all(tax_type %in% tax_type_options))

        tax_type <- tax_type_options
    }

    # If a transaction date range is specified, filter accordingly
    if (!is.null(transaction_date)) {

        # Verify transaction_date only has a start and end value
        stopifnot("transaction_date must be a length 2 vector or list of form c(start_date, end_date)" =
                      length(transaction_date) == 2)


        start_date <- lubridate::date(transaction_date[[1]])
        end_date <- lubridate::date(transaction_date[[2]])

        account_query <- glue::glue_sql('SELECT * FROM "NRADWH"."ACCOUNT_STATEMENT_VW"
                                        WHERE "TRANSACTION_DATE" BETWEEN {start_date} AND {end_date}
                                            AND "TAX_TYPE_ACCOUNT" IN ({tax_type*})',
                                        .con = db_con)

        # Otherwise return all the results
    } else {

        account_query <- glue::glue_sql('SELECT * FROM "NRADWH"."ACCOUNT_STATEMENT_VW"
                                        WHERE "TAX_TYPE_ACCOUNT" IN ({tax_type*})',
                                        .con = db_con)
    }

    account_statement <- DBI::dbGetQuery(conn = db_con, statement = account_query)

}
