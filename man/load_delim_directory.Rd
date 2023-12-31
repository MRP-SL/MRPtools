% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_delim_directory.R
\name{load_delim_directory}
\alias{load_delim_directory}
\title{load_delim_directory}
\usage{
load_delim_directory(dir, delim, quiet = FALSE, ...)
}
\arguments{
\item{dir}{The directory in which to load all files.}

\item{delim}{Single character used to separate fields within a record.}

\item{quiet}{Silences printing progress to the console.}

\item{...}{(Optional) To pass additional arguments to read_excel().}
}
\value{
A tibble containing the merged observations from the selected sheets.
}
\description{
Read and append all delimited files in a directory. Use ... to pass additional arguments to readr::read_delim(), which is used under the hood.
}
\examples{
# Load a directory of csv files
ecr <- load_delim_directory("path/to/csvs/", delim = ",")

# Load a directory of tab-delimited files
ecr <- load_delim_directory("path/to/tsv/", delim = "\t")

}
