#' Retrieve ITAS Returns from Data Warehouse
#'
#' This helper function constructs and executes a query of the `NON_COMPLIANT_TAXPAYERS_VW` table in the Data Warehouse based on the supplied arguments.
#'
#' @param db_con An active `DBIConnection` object created by `establish_db_connection()` or `DBI::dbConnect`
#' @param document_type A vector or list of Document Types to filter on. Options are given by `MRPtools::ITAS_RETURN_TYPES`.
#' @param tax_period (Optional) A vector or list where the first element is the start-date and second element the end-date
#' @param due_date (Optional) A vector or list where the first element is the start-date and second element the end-date
#' @return A data.frame containing all the matching observations in the Data Warehouse
#' @export
#'
#' @examples
#' # Establish a database connection
#' NRADWH <- establish_db_connection("NRADWH")
#'
#' # Retrieve all PIT Returns
#' pit_returns <- fetch_itas_returns(NRADWH, document_type = c("PITReturnProvisional", "PITReturnFinal"))
#'
#'# Retrieve GST returns for Q3 2023
#' gst_returns_q3 <- fetch_itas_returns(NRADWH, document_type = "Goods and Services", tax_period = c("2023-07-01", "2023-09-30"))
#'
fetch_itas_returns <- function(db_con, document_type = NULL, tax_period = NULL, due_date = NULL) {

    # Stop if invalid inputs
    stopifnot("Database connection is invalid." = DBI::dbIsValid(db_con))
    stopifnot("At most one of 'tax_period' or 'due_date' can be specified" =
                  sum(!is.null(tax_period), !is.null(due_date)) < 2)


    # Set 'document_type' to all permitted values if user supplies none
    if (!is.null(document_type)) {
        stopifnot("Some Document Types invalid. Run '?get_itas_returns' for a list of valid types." =
                      all(document_type %in% MRPtools::ITAS_RETURN_TYPES))
    } else {
        document_type <- MRPtools::ITAS_RETURN_TYPES
    }

    # Filter query by user supplied date, if one is provided
    if (!is.null(tax_period)) {

        # Verify tax_period only contains a start and end value
        stopifnot("tax_period must be a vector or list in the form c(start_date, end_date)" =
                      length(tax_period) == 2)

        tax_period_start <- lubridate::date(tax_period[[1]])
        tax_period_end <- lubridate::date(tax_period[[2]])

        returns_query <- glue::glue_sql('SELECT *
                                    FROM "NRADWH"."NON_COMPLIANT_TAXPAYERS_VW"
                                    WHERE "PERIOD_START_DATE" >= {tax_period_start}
                                        AND "PERIOD_END_DATE" <= {tax_period_end}
                                        AND "DOCUMENT_TYPE" IN ({document_type*})',
                                        .con = db_con)
        # Otherwise do not filter by date
    } else if (!is.null(due_date)) {

        # Verify due_date only contains a start and end value
        stopifnot("due_date must be a vector or list in the form c(start_date, end_date)" =
                      length(due_date) == 2)

        due_date_start <- lubridate::date(due_date[[1]])
        due_date_end <- lubridate::date(due_date[[2]])

        returns_query <- glue::glue_sql('SELECT * FROM "NRADWH"."NON_COMPLIANT_TAXPAYERS_VW"
                                        WHERE "PAYMENT_DUE_DATE" BETWEEN {due_date_start} AND {due_date_end}
                                        AND "DOCUMENT_TYPE" IN ({document_type*})',
                                        .con = db_con)

    } else {

        returns_query <- glue::glue_sql('SELECT * FROM "NRADWH"."NON_COMPLIANT_TAXPAYERS_VW"
                                        WHERE "DOCUMENT_TYPE" IN ({document_type*})',
                                        .con = db_con)

    }

    # Function returns the result of executing the query
    returns <- DBI::dbGetQuery(conn = db_con, statement = returns_query)

}
