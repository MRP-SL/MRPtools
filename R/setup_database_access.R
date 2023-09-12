#' setup_database_access
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
