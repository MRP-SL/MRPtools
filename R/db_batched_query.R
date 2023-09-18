db_batched_query <- function(db_con, query, batch_size) {
    request <- DBI::dbSendQuery(db_con, statement = query)
    on.exit(DBI::dbClearResult(request))

    i <- 1

    while(!DBI::dbHasCompleted(request)) {
        if (exists("result", inherits = FALSE)) {
            result <- rbind(result, DBI::dbFetch(request, n = batch_size))
        } else {
            result <- DBI::dbFetch(request, n = batch_size)
        }
        print(paste("Retrieved Batch:", i))
        i <- i + 1
    }
}
