# This script creates a series of vectors for commonly-needed values when
# working with NRA datasets.

# Maintained by: Mohamed Ali Bah (MRP), Jordan Imahori (ODI Fellow)
# Contact: mahbah@nra.gov.sl; jordan.imahori@gmail.com


# List of codes for every DECTYPE used in ASYCUDA (as of July 2023)
DECTYPE_CODES = c("EX1", "EX2", "EX3", "EX8", "IM4", "IM5", "IM6", "IM7", "IM8",
                  "IM9", "COM1", "COM4", "COM7", "SD4", "AU4", "PB4", "PP4",
                  "SG4", "SG7")


# Export this data to make it available to users
usethis::use_data(DECTYPE_CODES, overwrite = TRUE)
