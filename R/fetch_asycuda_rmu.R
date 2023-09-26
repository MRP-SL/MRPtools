#' Retrieve ASYCUDA Risk Management Unit Records from the Data Warehouse
#'
#' This helper function constructs and executes a query of the `ASY_RMU_IMPORT_EXPORT_STATS` table in the Data Warehouse based on the supplied arguments.
#'
#' @param db_con An active `DBIConnection` object created by `MRPtools::establish_db_connection()` or `DBI::dbConnect`
#' @param cols (Optional) A vector or list of columns to include in the subset.
#' @param reg_date (Optional) A vector or list where the first element is the start-date and second element the end-date.
#' @param dec_type (Optional) A vector or list of Tax Types to filter on. Options are:
#'
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
#' # Establish database connection
#' # NRADWH <- establish_db_connection(database = "NRADWH")
#'
#' # Fetch RMU results for 2022
#' # fetch_asycuda_rmu(db_con = NRADWH, reg_date = c("2022-01-01", "2022-12-31"))
#'
#' # Fetch results for IM4 and IM7, and only the CIF Value and Registration Date
#' # fetch_asycuda_rmu(db_con = NRADWH, cols = c("CIF", "REGDATE"), dec_type = c("IM4", "IM7"))
#'
#' # Fetch all results since the beginning of time
#' # fetch_asycuda_rmu(db_con = NRADWH)
#'
fetch_asycuda_rmu <- function(db_con, cols = NULL, reg_date = NULL, dec_type = NULL) {

    # DECTYPE_CODES and RMU_INCLUDE are defined in 'data-raw'

    # Validate user-supplied objects
    stopifnot("Object supplied as db_con is not an active connection" = DBI::dbIsValid(db_con))

    # Currently, there is a typo in DECTYPE for RMU
    # if(!(all(dec_type %in% MRPtools::DECTYPE_CODES))) {
    #     warning("Some DECTYPE codes are invalid and will be ignored.")
    # }

    if (!is.null(reg_date)) {
        # Confirm only two values supplied. Take the first as start and second as end.
        stopifnot("reg_date must be a vector of length 2" = length(reg_date) == 2)

        start_date <- lubridate::date(reg_date[1])
        end_date <- lubridate::date(reg_date[2])
    }

    # Set cols to a default value if none are supplied
    if (is.null(cols)) {
        cols <- RMU_INCLUDE
    }

    # Build Risk Management Unit Query Based on Parameters
    if (!is.null(reg_date) & !is.null(dec_type)) {
        rmu_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_RMU_IMPORT_EXPORT_STATS"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}
            AND "DECTYPE" IN ({dec_type*})',
            .con = db_con
        )
    } else if (!is.null(dec_type)) {
        rmu_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_RMU_IMPORT_EXPORT_STATS"
            WHERE "DECTYPE" IN ({dec_type*})',
            .con = db_con
        )
    } else if (!is.null(reg_date)) {
        rmu_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_RMU_IMPORT_EXPORT_STATS"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}',
            .con = db_con
        )
    } else {
        rmu_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_RMU_IMPORT_EXPORT_STATS"',
            .con = db_con
        )
    }

    # Retrieve Records Matching RMU Query
    rmu <- DBI::dbGetQuery(db_con, statement = rmu_query)

}
