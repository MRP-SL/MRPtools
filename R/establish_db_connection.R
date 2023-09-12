#' Title
#'
#' @param database The name of the database connection to establish. It must match the name given to 'setup_database_access()'
#'
#' @return An object returned by DBI::dbConnect() which can be used for making subsequent queries against the defined database.
#' @export
#'
#' @examples
establish_db_connection <- function(database = 'NRADWH') {

    stopifnot("Credentials not found. First run 'setup_database_access(...)'" =
                  database %in% keyring::key_list("NRAdb-username")[["username"]] &
                  database %in% keyring::key_list("NRAdb-password")[["username"]])

    stopifnot("Database mis-configured. Please re-run setup_database_access(...)'" =
                  database %in% keyring::key_list("NRAdb-driver")[["username"]] &
                  keyring::key_get("NRAdb-driver", username = database) %in% c("postgres", "mysql"))


    # Choose the right database driver
    drv <- keyring::key_get("NRAdb-driver", username = database)

    if (drv == "postgres") {
        driver <- RPostgres::Postgres()
    } else if (drv == "mysql") {
        driver <- RMariaDB::MariaDB()
    }

    # Get the port number if supplied by the user.
    if (database %in% keyring::key_list("NRAdb-host")[["username"]]) {
        port <- keyring::key_get("NRAdb-port", username = database)
    } else {
        port <- NULL
    }

    con <- DBI::dbConnect(drv = driver,
                          user = keyring::key_get("NRAdb-username", username = database),
                          password = keyring::key_get("NRAdb-password", username = database),
                          host = keyring::key_get("NRAdb-host", username = database),
                          port = port,
                          dbname = database)
}
