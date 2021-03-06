#' Convert TRY text file to SQLite database
#'
#' The TRY file is huge and unnecessarily long, which makes it difficult to 
#' work with. The resulting SQLite database is much smaller on disk, and can be 
#' read much faster thanks to lazy evaluation.
#'
#' The resulting TRY SQLite database contains the following tables:
#'  - `values` -- The actual TRY data. Links to all other tables through ID columns.
#'  - `traits` -- Description of trait and data names. Links to `values` through `DataID`. Similar to BETY `variables` table.
#'  - `datasets` -- Description of datasets and references/citations. Links to `values` through `DatasetID` and `ReferenceID`.
#'  - `species` -- Species. Links to `values` through `AccSpeciesID`.
#'
#' @param try_files Character vector of file names containing TRY data.  
#' Multiple files are combined with `data.table::rbindlist`.
#' @param sqlite_file Target SQLite database file name, as character.
#' @export
try2sqlite <- function(try_files, sqlite_file = "try.sqlite") {
  # Read files
  PEcAn.logger::logger.info("Reading in TRY data...")
  raw_data <- Map(data.table::fread, try_files) %>%
    data.table::rbindlist()

  # Create integer reference ID for compact storage
  PEcAn.logger::logger.info("Adding ReferenceID column")
  raw_data[["ReferenceID"]] <- as.integer(factor(raw_data[["Reference"]]))

  # Create tables
  PEcAn.logger::logger.info("Extracting data values table.")
  data_cols <- c(
    "ObsDataID",        # TRY row ID -- unique to each observation of a given trait
    "ObservationID",    # TRY "entity" ID -- identifies a set of trait measurements (e.g. leaf)
    "DataID",           # Links to data ID
    "StdValue",         # Standardized, QA-QC'ed value
    "UnitName",         # Standardized unit
    "AccSpeciesID",     # Link to 'species' table
    "DatasetID",        # Link to 'datasets' table.
    "ReferenceID",      # Link to 'try_references' table.
    "ValueKindName",    # Type of value, e.g. mean, min, max, etc.
    "UncertaintyName",  # Kind of uncertainty
    "Replicates",       # Number of replicates
    "RelUncertaintyPercent",
    "OrigValueStr",         # Original data, as character string (before QA/QC)
    "OrigUnitStr",          # Original unit, as character string (before QA/QC)
    "OrigUncertaintyStr"    # Original uncertainty, as character string (before QA/QC)
  )
  data_values <- unique(raw_data[, data_cols, with = FALSE])

  PEcAn.logger::logger.info("Extrating datasets table...")
  datasets_cols <- c(
    "DatasetID",
    "Dataset",
    "LastName",
    "FirstName",
    "Reference",
    "ReferenceID"
  )
  datasets_values <- unique(raw_data[, datasets_cols, with = FALSE])

  PEcAn.logger::logger.info("Extracting traits table...")
  traits_cols <- c(
    "DataID",
    "DataName",
    "TraitID",
    "TraitName"
  )
  traits_values <- unique(raw_data[, traits_cols, with = FALSE])

  PEcAn.logger::logger.info("Extracting species table...")
  species_cols <- c(
    "AccSpeciesID",
    "AccSpeciesName",
    "SpeciesName"
  )
  species_values <- unique(raw_data[, species_cols, with = FALSE])

  PEcAn.logger::logger.info("Writing tables to SQLite database...")
  con <- DBI::dbConnect(RSQLite::SQLite(), sqlite_file)
  on.exit(DBI::dbDisconnect(con))
  PEcAn.logger::logger.info("Writing values table...")
  DBI::dbWriteTable(con, "values", data_values)
  PEcAn.logger::logger.info("Writing traits table...")
  DBI::dbWriteTable(con, "traits", traits_values)
  PEcAn.logger::logger.info("Writing datasets table...")
  DBI::dbWriteTable(con, "datasets", datasets_values)
  PEcAn.logger::logger.info("Writing species table...")
  DBI::dbWriteTable(con, "species", species_values)

  PEcAn.logger::logger.info("Done creating TRY SQLite database!")

  NULL
}
