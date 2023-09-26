#' Retrieve ITAS Account Statements from Data Warehouse
#'
#' This helper function constructs and executes a query of the `ACCOUNT_STATEMENT_VW` table in the Data Warehouse based on the supplied arguments.
#'
#' @param db_con An active `DBIConnection` object created by `establish_db_connection()` or `DBI::dbConnect`
#' @param tax_type (Optional) A vector or list of Tax Types to filter on. Options are given by `MRPtools::ITAS_TAX_TYPES`
#' @param transaction_date (Optional) A vector or list where the first element is the start-date and second element the end-date
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
#' # Establish database connection
#' NRADWH <- establish_db_connection("NRADWH")
#'
#' # Retrieve records for July 2022
#' acc_july <- fetch_itas_account_statement(NRADWH, transaction_date = c("2022-07-01", "2022-07-31"))
#'
#' # Retrieve GST Payments
#' acc_gst <- fetch_itas_account_statement(NRADWH, tax_type = "Goods and Services")
#'
fetch_itas_account_statement <- function(db_con, tax_type = NULL, transaction_date = NULL) {

    # Verify database connection is valid
    stopifnot("Database connection is invalid." = DBI::dbIsValid(db_con))

    # Warn the user that at least one tax type is invalid
    if (!is.null(tax_type) & !all(tax_type %in% MRPtools::ITAS_TAX_TYPES)) {
        warning("At least one tax type is invalid and will be ignored.")
    }

    # Extract start_date and end_date from user-supplied range
    if (!is.null(transaction_date)) {
        # Verify transaction_date only has a start and end value
        stopifnot("transaction_date must be a length 2 vector or list of form c(start_date, end_date)" =
                      length(transaction_date) == 2)

        start_date <- lubridate::date(transaction_date[[1]])
        end_date <- lubridate::date(transaction_date[[2]])
    }
    # CASE A: Transaction and Tax Type supplied
    if (!is.null(transaction_date) & !is.null(tax_type)) {

        account_query <- glue::glue_sql('SELECT * FROM "NRADWH"."ACCOUNT_STATEMENT_VW"
                                        WHERE "TRANSACTION_DATE" BETWEEN {start_date} AND {end_date}
                                            AND "TAX_TYPE_ACCOUNT" IN ({tax_type*})',
                                        .con = db_con
                                        )
    # CASE B: Only Tax Type Supplied
    } else if (!is.null(tax_type)) {

        account_query <- glue::glue_sql('SELECT * FROM "NRADWH"."ACCOUNT_STATEMENT_VW"
                                        WHERE "TAX_TYPE_ACCOUNT" IN ({tax_type*})',
                                        .con = db_con
                                        )
    # CASE C: Only Transaction Supplied
    } else if (!is.null(transaction_date)) {

        account_query <- glue::glue_sql('SELECT * FROM "NRADWH"."ACCOUNT_STATEMENT_VW"
                                        WHERE "TRANSACTION_DATE" BETWEEN {start_date} AND {end_date}',
                                        .con = db_con
        )
    # CASE D: Neither is supplied
    } else {
        account_query <- glue::glue_sql('SELECT * FROM "NRADWH"."ACCOUNT_STATEMENT_VW"',
                                        .con = db_con
        )
    }

    account_statement <- DBI::dbGetQuery(conn = db_con, statement = account_query)

}
