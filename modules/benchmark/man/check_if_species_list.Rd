% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_if_species_list.R
\name{check_if_species_list}
\alias{check_if_species_list}
\title{check_if_species_list}
\usage{
check_if_species_list(vars, custom_table = NULL)
}
\arguments{
\item{custom_table}{a table that either maps two pft's to one anouther or maps custom species codes to bety id codes. 
In the second case, must be passable to match_species_id.}

\item{observation_one}{a vector of plant functional types, or species}

\item{observation_two}{another vector of plant functional types, or species}
}
\value{
\code{boolean}
}
\details{
Checks if format contains a species list in a known format, or a declared custom format.
}
\author{
Tempest McCabe
}
