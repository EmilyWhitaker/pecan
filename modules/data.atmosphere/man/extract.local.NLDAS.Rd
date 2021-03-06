% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_local_NLDAS.R
\name{extract.local.NLDAS}
\alias{extract.local.NLDAS}
\title{extract.local.NLDAS}
\usage{
extract.local.NLDAS(outfolder, in.path, start_date, end_date, site_id, lat.in,
  lon.in, overwrite = FALSE, verbose = FALSE, ...)
}
\arguments{
\item{outfolder}{- directory where output files will be stored}

\item{in.path}{- path to the raw full grids}

\item{start_date}{- first day for which you want to extract met (yyyy-mm-dd)}

\item{end_date}{- last day for which you want to extract met (yyyy-mm-dd)}

\item{site_id}{name to associate with extracted files}

\item{lat.in}{site latitude in decimal degrees}

\item{lon.in}{site longitude in decimal degrees}

\item{overwrite}{logical. Download a fresh version even if a local file with the same name already exists?}

\item{verbose}{logical. Passed on to \code{\link[ncdf4]{ncvar_def}} and \code{\link[ncdf4]{nc_create}}
to control printing of debug info}

\item{...}{Other arguments, currently ignored}
}
\description{
This function extracts NLDAS data from grids that have been downloaded and stored locally.
             Once upon a time, you could query these files directly from the internet, but now they're 
             behind a tricky authentication wall. Files are saved as a netCDF file in CF conventions. 
             These files are ready to be used in the general PEcAn workflow or fed into the downscalign 
             workflow.
}
\details{
Extract NLDAS from local download
Extract NLDAS meteorology for a poimt from a local download of the full grid
}
\author{
Christy Rollinson,
}
