# This script creates a series of vectors for commonly-needed values when
# working with NRA datasets.

# Maintained by: Mohamed Ali Bah (MRP), Jordan Imahori (ODI Fellow)
# Contact: mahbah@nra.gov.sl; jordan.imahori@gmail.com


# DECTYPE Codes from Asycuda
DECTYPE_CODES = c("EX1", "EX2", "EX3", "EX8", "IM4", "IM5", "IM6", "IM7", "IM8",
                  "IM9", "COM1", "COM4", "COM7", "SD4", "AU4", "PB4", "PP4",
                  "SG4", "SG7")

# Tax Office Codes from ITAS
TAX_OFFICE_CODES <- c("BOSTO", "FTWSTO3", "FTESTO", "KESTO", "SLMTO", "SLLTO",
                      "MSTO", "CIB", "EIRU", "KNSTO", "FTCSTO", "WITO")


# Document Type Options from ITAS
ITAS_RETURN_TYPES <- c("PITReturnFinal", "PITReturnProvisional", "GSTReturn",
                       "WHTReturn", "FTTReturn", "CITReturnProvisional",
                       "CITReturnFinal", "PAYEReturn", "PTReturn", "ETReturn")

# Tax Type Options from ITAS
ITAS_TAX_TYPES <- c("Excise Tax", "Foreign Travel Tax", "Rental Income Tax",
                    "Personal Income Tax", "Suspense Account", "Goods and Services",
                    "Pay As You Earn", "Withholding Tax", "Payroll Tax",
                    "Capital Gains Tax", "Company Income Tax")


# Export this data to make it available to users
usethis::use_data(DECTYPE_CODES, TAX_OFFICE_CODES, ITAS_RETURN_TYPES, ITAS_TAX_TYPES, overwrite = TRUE)
