#' fetch_asycuda_pca
#'
#' @param db_con An active DBIConnection object, often created by 'establish_db_connection()'
#' @param cols (Optional) A vector or list of columns to include in the subset.
#' @param reg_date (Optional) A vector or list where the first element is the start-date and second element the end-date
#' @param dec_type (Optional) A vector or list of Tax Types to filter on. Options are:
#'
#' @return A data.frame containing all the matching observations in the Data Warehouse.
#' @export
#'
#' @examples
fetch_asycuda_pca <- function(db_con, cols = NULL, reg_date = NULL, dec_type = NULL) {

    # Validate database object
    stopifnot("Object supplied as db_con is not an active connection" = DBI::dbIsValid(db_con))

    # Validate user-supplied cols, otherwise set 'cols' to a default value
    if (!is.null(cols)) {
        stopifnot(all(cols %in% ASYCUDA_COLS["PCA_COLS"]))
    } else {
        cols <- ASYCUDA_INCLUDE["PCA_INCLUDE"]
    }

    # Validate user-supplied dec_types, otherwise use all options.
    if (!is.null(dec_type)) {
        stopifnot(all(dec_type %in% DECTYPE_CODES))
    } else {
        dec_type <- DECTYPE_CODES
    }

    if (!is.null(reg_date)) {
        # Confirm only two values supplied. Take the first as start and second as end.
        stopifnot("reg_date must be a vector of length 2" = length(reg_date) == 2)
        start_date <- lubridate::date(reg_date[1])
        end_date <- lubridate::date(reg_date[2])
    }

    # Build Post-Clearance Audit Query Based on Parameters
    if (!is.null(reg_date)) {
        pca_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_POST_CLEARANCE_AUDIT"
            WHERE "REGDATE" BETWEEN {start_date} AND {end_date}
            AND "DECTYPE" IN ({dec_type*})',
            .con = db_con
        )
    } else {
        pca_query <- glue::glue_sql(
            'SELECT {`cols`*}
            FROM "NRADWH"."ASY_POST_CLEARANCE_AUDIT"
            WHERE "DECTYPE" IN ({dec_type})',
            .con = db_con
        )
    }

    # Retrieve Records Matching PCA Query
    pca <- DBI::dbGetQuery(db_con, statement = pca_query)

}
