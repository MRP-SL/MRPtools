#' Retrieve ASYCUDA Queries & Amendments Records from Data Warehouse
#'
#' This helper function constructs and executes a query of the ASY_QAA_MODIFIED_DECLARATIONS table in the Data Warehouse based on the supplied arguments.
#'
#' @param db_con An active DBIConnection object, often created by 'establish_db_connection()'
#' @param cols (Optional) A vector or list of columns to include in the subset.
#' @param reg_date (Optional) A vector or list where the first element is the start-date and second element the end-date.
#'
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
#' # Establish database connection
#' # NRADWH <- establish_db_connection(database = "NRADWH")
#'
#' # Fetch Import-Export results for 2022
#' # fetch_asycuda_qa(db_con = NRADWH, reg_date = c("2022-01-01", "2022-12-31"))
#'
#' # Fetch results for IM4 and IM7, and only the Office Code and Fraud Name 1
#' # fetch_asycuda_qa(db_con = NRADWH, cols = c("OFFICECODE", "FRAUDNAME1"), dec_type = c("IM4", "IM7"))
#'
#' # Fetch all results since the beginning of time
#' # fetch_asycuda_qa(db_con = NRADWH)
#'
fetch_asycuda_qa <- function(db_con, cols = NULL, reg_date = NULL) {

    # Validate database object
    stopifnot("Object supplied as db_con is not an active connection" = DBI::dbIsValid(db_con))

    # Set cols to a default value (defined in 'data-raw') if none are supplied
    if (is.null(cols)) {
        cols <- QA_INCLUDE
    }

    if (!is.null(reg_date)) {
        stopifnot("reg_date must be a vector of length 2" = length(reg_date) == 2)

        start_date <- lubridate::date(reg_date[1])
        end_date <- lubridate::date(reg_date[2])
    }


    # Build Queries & Amendments Query Based on Parameters
    if (!is.null(reg_date)) {
        qa_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_QAA_MODIFIED_DECLARATIONS"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}',
            .con = db_con
        )
    } else {
        qa_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_QAA_MODIFIED_DECLARATIONS"',
            .con = db_con
        )
    }

    # Retrieve Records Matching Q&A Query
    qa <- DBI::dbGetQuery(db_con, statement = qa_query)

}
