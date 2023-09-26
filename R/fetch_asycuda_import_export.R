#' Get ASYCUDA Import-Export Data
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
#' # Establish database connection
#' NRADWH <- establish_db_connection(database = "NRADWH")
#'
#' # Fetch Import-Export results for 2022
#' fetch_asycuda_import_export(db_con = NRADWH, reg_date = c("2022-01-01", "2022-12-31"))
#'
#' # Fetch results for IM4 and IM7, and only the CIF Value and Registration Date
#' fetch_asycuda_import_export(db_con = NRADWH, cols = c("CIFVALUE", "REGDATE"), dec_type = c("IM4", "IM7"))
#'
#' # Fetch all results since the beginning of time
#' fetch_asycuda_import_export(db_con = NRADWH)
#'
fetch_asycuda_import_export <- function(db_con, cols = NULL, reg_date = NULL, dec_type = NULL) {

    # Validate database object
    stopifnot("Object supplied as db_con is not an active connection" = DBI::dbIsValid(db_con))

    # Set cols to a default value (defined in 'data-raw') if none are supplied
    if (is.null(cols)) {
        cols <- IE_INCLUDE
    }

    if (!is.null(reg_date)) {
        # Confirm only two values supplied. Take the first as start and second as end.
        stopifnot("reg_date must be a vector of length 2" = length(reg_date) == 2)
        start_date <- lubridate::date(reg_date[1])
        end_date <- lubridate::date(reg_date[2])
    }

    # Construct our query based on user-supplied arguments
    if (!is.null(reg_date)) {
        ie_query <- glue::glue_sql('SELECT {`cols`*}
                                   FROM "NRADWH"."ASY_IMP_EXP_STATS"
                                   WHERE "REGDATE" BETWEEN {start_date} AND {end_date}
                                   AND "DECTYPE" IN ({dec_type*})',
                                   .con = db_con
        )
    } else if (!is.null(dec_type)) {
        ie_query <- glue::glue_sql('SELECT {`cols`*}
                                   FROM "NRADWH"."ASY_IMP_EXP_STATS"
                                   WHERE "DECTYPE" IN ({dec_type*})',
                                   .con = db_con
        )
    } else if (!is.null(reg_date)) {
        ie_query <- glue::glue_sql('SELECT {`cols`*}
                                   FROM "NRADWH"."ASY_IMP_EXP_STATS"
                                   WHERE "REGDATE" BETWEEN {start_date} AND {end_date}',
                                   .con = db_con
        )
    } else {
        ie_query <- glue::glue_sql('SELECT {`cols`*}
                                   FROM "NRADWH"."ASY_IMP_EXP_STATS"',
                                   .con = db_con
        )
    }

    import_export <- DBI::dbGetQuery(db_con, statement = ie_query)

}
