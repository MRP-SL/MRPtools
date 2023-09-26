#' Configure Access to NRA Databases
#'
#' This function allows you to store configurations and credentials for databases using your OS's native secure key storage. When run, it will prompt you to enter your username and password. It also stores details essential for connecting to the database, like the database name, database provider (typically PostgreSQL or MySQL), IP address, and a port number.
#'
#' @param database The name of the database to connect to.
#' @param host The I.P. address of the server hosting the DB.
#' @param driver The database provider. Either 'mysql' or 'postgres'.
#' @param port (Optional) The port number on the server hosting the DB.
#'
#' @return Stores the parameters required for configuring a database connection using keyring::key_set()
#' @export
#'
#' @examples
#' # Store credentials for the NRA Data Warehouse (note the IP address may change -- ask IT)
#' # This only needs to be done once.
#' setup_database_access(database = "NRADWH", host = "10.18.0.22", driver = RPostgres::Postgres())
#' NRADWH <- establish_db_connection("NRADWH")
#'
#' # Subsequently, all you need to do to establish a connection is:
#' NRADWH <- establish_db_connection("NRADWH")
#'
#' # Note: the database name in 'setup_database_acess' and 'establish_db_connection' must be the same
#'
setup_database_access <- function(database, host, driver, port = NULL) {
    stopifnot("A host must be specified" = !exists(host))
    stopifnot("Invalid driver. Options are: 'mysql', 'postgres'" =
                  driver %in% c("mysql", "postgres"))

    # Database Details
    keyring::key_set_with_value('NRAdb-host', username = database, password = host)
    keyring::key_set_with_value('NRAdb-driver', username = database, password = driver)
    if (!is.null(port)) {
        keyring::key_set_with_value('NRAdb-port', username = database, password = port)
    }

    # User Credentials
    keyring::key_set('NRAdb-username', username = database, prompt = "Enter your username:")
    keyring::key_set('NRAdb-password', username = database, prompt = "Enter your password: ")
}
