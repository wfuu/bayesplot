# Check for suggested package (requireNamespace)
#
# @param pkg Package name as a string
#
suggested_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop(
      "Please install the ", pkg, " package to use this function.",
      call. = FALSE
    )
}

# Explicit and/or regex parameter selection
#
# @param explicit Character vector of selected parameter names.
# @param patterns Character vector of regular expressions.
# @param complete Character vector of all possible parameter names.
# @return Characeter vector of combined explicit and matched (via regex)
#   parameter names, unless an error is thrown.
#
select_parameters <-
  function(explicit = character(),
           patterns = character(),
           complete = character()) {

    stopifnot(is.character(explicit),
              is.character(patterns),
              is.character(complete))

    if (!length(explicit) && !length(patterns))
      return(complete)

    if (length(explicit)) {
      if (!all(explicit %in% complete)) {
        not_found <- which(!explicit %in% complete)
        stop(
          "Some 'pars' don't match parameter names: ",
          paste(explicit[not_found], collapse = ", ")
        )
      }
    }

    if (!length(patterns)) {
      return(unique(explicit))
    } else {
      regex_pars <-
        unlist(lapply(seq_along(patterns), function(j) {
          grep(patterns[j], complete, value = TRUE)
        }))
      if (!length(regex_pars))
        stop("No matches for 'regex_pars'.", call. = FALSE)
    }

    unique(c(explicit, regex_pars))
  }
