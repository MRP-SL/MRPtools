#' Get ASYCUDA Risk Management Unit Data
#'
#' @param db_con An active DBIConnection object, often created by 'establish_db_connection()'
#' @param cols (Optional) A vector or list of columns to include in the subset.
#' @param reg_date (Optional) A vector or list where the first element is the start-date and second element the end-date.
#' @param dec_type (Optional) A vector or list of Tax Types to filter on. Options are:
#'
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
fetch_asycuda_rmu <- function(db_con, cols = NULL, reg_date = NULL, dec_type = NULL) {

    # Validate database object
    stopifnot("Object supplied as db_col is not an active connection" = DBI::dbIsValid(db_col))

    if (!is.null(cols)) {
        # Validate the cols supplied by the user
        stopifnot("Some supplied columns are invalid" = (cols %in% ASYCUDA_COLS["RMU_COLS"]))
    } else {
        # ...otherwise set the cols to a pre-defined list
        cols <- ASYCUDA_INCLUDE["RMU_INCLUDE"]
    }

    if (!is.null(reg_date)) {
        # Validate reg_date
        stopifnot("reg_date must be a vector of length 2" = length(reg_date) == 2)

        start_date <- lubridate::date(reg_date[1])
        end_date <- lubridate::date(reg_date[2])
    }

    # Validate user-supplied dec types, otherwise set it to all options.
    if (!is.null(dec_types)) {
        stopifnot("Some columns in dec_type are invalid" = all(dec_type %in% DECTYPE_CODES))
    } else {
        dec_type <- DECTYPE_CODES
    }

    # Build Risk Management Unit Query Based on Parameters
    if (!is.null(reg_date)) {
        rmu_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_RMU_IMPORT_EXPORT_STATS"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}
            AND "DECTYPE" = ({dec_type*})',
            .con = db_con
        )
    } else {
        rmu_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_RMU_IMPORT_EXPORT_STATS"
            WHERE "DECTYPE" IN ({dec_type*})',
            .con = db_con
        )
    }

    # Retrieve Records Matching RMU Query
    rmu <- dbGetQuery(db_con, statement = rmu_query)

}
