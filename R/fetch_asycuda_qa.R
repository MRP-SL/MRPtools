#' Get ASYCUDA Queries & Amendments Data
#'
#' @param db_con An active DBIConnection object, often created by 'establish_db_connection()'
#' @param cols (Optional) A vector or list of columns to include in the subset.
#' @param reg_date (Optional) A vector or list where the first element is the start-date and second element the end-date.
#'
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
fetch_asycuda_qa <- function(db_con, cols = NULL, reg_date = NULL) {

    # Validate database object
    stopifnot("Object supplied as db_con is not an active connection" = DBI::dbIsValid(db_con))

    if (!is.null(cols)) {
        stopifnot("Some cols are not found in RMU table" = all(cols %in% ASYCUDA_COLS["QA_COLS"]))
    } else {
        cols <- ASYCUDA_INCLUDE["QA_INCLUDE"]
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
