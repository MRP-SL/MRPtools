% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_excel.R
\name{load_excel}
\alias{load_excel}
\title{load_excel}
\usage{
load_excel(path, sheets = NULL, quiet = FALSE, ...)
}
\arguments{
\item{path}{The Excel file to load.}

\item{sheets}{A numeric or character vector of indices for sheets, or "all".}

\item{quiet}{Silences printing progress to the console.}

\item{...}{(Optional) To pass additional arguments to read_excel().}
}
\value{
A tibble containing the merged observations from the selected sheets.
}
\description{
Read and append sheets within an Excel file. Optionally, you can specify which sheets should be loaded using a vector of indices of sheet names. Use ... to pass additional arguments to readxl::read_excel(), which is used under the hood.
}
\examples{
# Load all sheets
qa_2022 <- load_excel("queries_amendments_2022.xlsx")

# Load only the sheet titled 'January' or 'February'
qa_2022 <- load_excel("queries_amendments_2022.xlsx", sheets = c("January", "February"))

# Load only the 4rd to 6th sheet, passing the 'guess_max' argument to readxl
qa_q2_2022 <- load_excel("queries_amendments_2022.xlsx", sheets = 4:6, guess_max = 100000)

}
