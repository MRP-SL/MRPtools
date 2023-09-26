#' Retrieve ASYCUDA Post-Clearance Audit Records from Data Warehouse
#'
#' This helper function constructs and executes a query of the `ASY_POST_CLEARANCE_AUDIT` table in the Data Warehouse based on the supplied arguments.
#'
#' @param db_con An active `DBIConnection` object created by `MRPtools::establish_db_connection()` or `DBI::dbConnect`
#' @param cols (Optional) A vector or list of columns to include in the subset.
#' @param reg_date (Optional) A vector or list where the first element is the start-date and second element the end-date
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
#' fetch_asycuda_pca(db_con = NRADWH, reg_date = c("2022-01-01", "2022-12-31"))
#'
#' # Fetch results for IM4 and IM7, and only the Office Code and Registration Date
#' fetch_asycuda_pca(db_con = NRADWH, cols = c("OFFICECODE", "REGDATE"), dec_type = c("IM4", "IM7"))
#'
#' # Fetch all results since the beginning of time
#' fetch_asycuda_pca(db_con = NRADWH)
#'
fetch_asycuda_pca <- function(db_con, cols = NULL, reg_date = NULL, dec_type = NULL) {

    # Note: DECTYPE_CODES and PCA_INCLUDE are defined in 'data-raw'

    # Validate user-supplied objects
    stopifnot("Object supplied as db_con is not an active connection" = DBI::dbIsValid(db_con))

    if(!(all(dec_type %in% MRPtools::DECTYPE_CODES))) {
        warning("Some DECTYPE codes are invalid and will be ignored.")
    }

    if (!is.null(reg_date)) {
        # Confirm only two values supplied. Take the first as start and second as end.
        stopifnot("reg_date must be a vector of length 2" = length(reg_date) == 2)
        start_date <- lubridate::date(reg_date[1])
        end_date <- lubridate::date(reg_date[2])
    }

    # Set cols to a default value if none are supplied
    if (is.null(cols)) {
        cols <- PCA_INCLUDE
    }

    # Build Post-Clearance Audit Query Based on Parameters
    if (!is.null(reg_date) & !is.null(dec_type)) {
        pca_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_POST_CLEARANCE_AUDIT"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}
            AND "DECTYPE" IN ({dec_type*})',
            .con = db_con
        )
    } else if (!is.null(reg_date)) {
        pca_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_POST_CLEARANCE_AUDIT"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}',
            .con = db_con
        )
    } else if (!is.null(dec_type)) {
        pca_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_POST_CLEARANCE_AUDIT"
            WHERE "DECTYPE" IN ({dec_type*})',
            .con = db_con
        )
    } else {
        pca_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_POST_CLEARANCE_AUDIT"',
            .con = db_con
        )
    }

    # Retrieve Records Matching PCA Query
    pca <- DBI::dbGetQuery(db_con, statement = pca_query)

}
