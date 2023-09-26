#' Retrieve ITAS Payments from the Data Warehouse
#'
#' This helper function constructs and executes a query of the DAILY_PAYMENT_REPORT table joined with REGISTERED_TAXPAYERS_VW to obtain the office code table.
#'
#' @param db_con An active DBIConnection object, often created by 'establish_db_connection()'
#' @param payment_date (Optional) A vector or list where the first element is the start-date and second element the end-date
#' @param office_code (Optional) A vector or list of Office Codes to filter on. Options are: c("BOSTO", "FTWSTO3", "FTESTO", "KESTO", "SLMTO", "SLLTO", "MSTO", "CIB", "EIRU", "KNSTO", "FTCSTO", "WITO")
#'
#' @return A data.frame containing all the matching observations in the Data Warehouse
#' @export
#'
#' @examples
#'
#' # Connect to NRA's data warehouse
#' NRADWH <- establish_db_connection("NRADWH")
#'
#' # Retrieve All Payments to Extractive Industries Revenue Unit in 2022
#' eiru_2022 <- get_itas_payments(NRADWH, payment_date = c("2022-01-01", "2022-12-31"), office_code = "EIRU")
#'
get_itas_payments <- function(db_con, payment_date = NULL, office_code = NULL) {

    # Try to check validity of user-supplied parameters
    stopifnot("Database connection is invalid." = DBI::dbIsValid(db_con))
    if (!is.null(office_code)) {
        stopifnot("Some office codes are invalid" = all(office_code %in% MRPtools::TAX_OFFICE_CODES))
    }
    if (!is.null(payment_date)) {
        stopifnot("payment_date must be a vector or list in the form c(start_date, end_date)" =
                      length(payment_date) == 2)
    }

    # NOTE:
    # - Until 'DAILY_PAYMENT..." is updated, need to merge to get 'OFFICE' code
    # - OFFICE can be NA

    # If payment_date is supplied, filter accordingly
    if (!is.null(payment_date)) {

        start_date <- lubridate::date(payment_date[[1]])
        end_date <- lubridate::date(payment_date[[2]])

        # If office_code is supplied, additionally filter for these
        if (!is.null(office_code)) {

            payments_query <- glue::glue_sql('SELECT "office"."TIN", "office"."OFFICE", "payments".*
                                         FROM "NRADWH"."DAILY_PAYMENT_REPORT_VW" AS payments
                                         INNER JOIN
                                            (SELECT "TIN", "OFFICE" FROM "NRADWH"."REGISTERED_TAXPAYERS_VW"
                                            WHERE "OFFICE" IN ({office_code})) AS office
                                            ON "payments"."TIN" = "office"."TIN"
                                         WHERE "payments"."PAYMENT_DATE" BETWEEN {start_date} AND {end_date};',
                                             .con = db_con
            )

            # Only filter for payment_date
        } else {
            payments_query <- glue::glue_sql('SELECT "office"."TIN", "office"."OFFICE", "payments".*
                                             FROM "NRADWH"."DAILY_PAYMENT_REPORT_VW" AS payments
                                             INNER JOIN
                                                 (SELECT "TIN", "OFFICE" FROM "NRADWH"."REGISTERED_TAXPAYERS_VW") AS office
                                                 ON "payments"."TIN" = "office"."TIN"
                                             WHERE "payments"."PAYMENT_DATE" BETWEEN {start_date} AND {end_date};',
                                             .con = db_con
            )

        }

        # No payment_date is supplied so we only filter on office code
    } else if (!is.null(office_code)) {
        payments_query <- glue::glue_sql('SELECT "office"."TIN", "office"."OFFICE", "payments".*
                                         FROM "NRADWH"."DAILY_PAYMENT_REPORT_VW" AS payments
                                         INNER JOIN
                                            (SELECT "TIN", "OFFICE" FROM "NRADWH"."REGISTERED_TAXPAYERS_VW"
                                            WHERE "OFFICE" IN ({office_code})) AS office
                                            ON "payments"."TIN" = "office"."TIN";',
                                         .con = db_con
        )

        # No office code is supplied so we do not filter
    } else {
        payments_query <- glue::glue_sql('SELECT "office"."TIN", "office"."OFFICE", "payments".*
                                         FROM "NRADWH"."DAILY_PAYMENT_REPORT_VW" AS payments
                                         LEFT JOIN
                                            (SELECT "TIN", "OFFICE" FROM "NRADWH"."REGISTERED_TAXPAYERS_VW") AS office
                                            ON "payments"."TIN" = "office"."TIN";',
                                         .con = db_con
        )
    }

    payments <- DBI::dbGetQuery(conn = db_con, statement = payments_query)

}
