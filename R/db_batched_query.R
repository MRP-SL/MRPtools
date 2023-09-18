db_batched_query <- function(database_obj, query, batch_size) {
    request <- dbSendQuery(database_obj, statement = query)
    on.exit(dbClearResult(request))

    i <- 1

    while(!dbHasCompleted(request)) {
        if (exists("result", inherits = FALSE)) {
            result <- rbind(result, dbFetch(request, n = batch_size))
        } else {
            result <- dbFetch(request, n = batch_size)
        }
        print(paste("Retrieved Batch:", i))
        i <- i + 1
    }
}
