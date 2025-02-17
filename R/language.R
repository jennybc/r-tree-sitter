#' Language name
#'
#' Extract a language object's language name.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @export
language_name <- function(x) {
  check_language(x)
  x$name
}

#' Language version
#'
#' Get the ABI version for this language object.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @returns
#' A scalar double value.
language_version <- function(x) {
  check_language(x)
  .Call(ffi_language_version, language_pointer(x))
}

#' Language symbols
#'
#' Get the integer symbol ID for a particular node name. Can be useful
#' for exploring the grammar.
#'
#' @inheritParams rlang::args_dots_empty
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @param name `[character]`
#'
#'   The names to look up symbols for.
#'
#' @param named `[logical]`
#'
#'   Should named or anonymous nodes be looked up? Recycled to the
#'   size of `name`.
#'
#' @returns
#' An integer vector the same size as `name` containing either:
#' - The integer symbol ID of the node name, if known.
#' - `NA` if the node name was not known.
#'
#' @export
#' @seealso [language_symbol_name()]
language_symbol_for_name <- function(x, name, ..., named = TRUE) {
  check_dots_empty0(...)
  check_language(x)

  name <- vec_cast(name, character())
  named <- vec_cast(named, logical())

  size <- vec_size(name)
  named <- vec_recycle(named, size, x_arg = "named")

  .Call(ffi_language_symbol_for_name, language_pointer(x), name, named)
}

#' Language symbol names
#'
#' Get the name for a particular language symbol ID. Can be useful for
#' exploring a grammar.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @param symbol `[positive integer]`
#'
#'   The language symbols to look up names for.
#'
#' @export
#' @seealso [language_symbol_for_name()]
#' @returns
#' A character vector the same length as `symbol` containing:
#' - The name of the symbol, if known.
#' - `NA`, if the symbol was not known.
language_symbol_name <- function(x, symbol) {
  check_language(x)
  symbol <- vec_cast(symbol, integer())
  .Call(ffi_language_symbol_name, language_pointer(x), symbol)
}

#' Language field identifiers
#'
#' Get the integer field identifier for a field name. If you are going to be
#' using a field name repeatedly, it is often a little faster to use the
#' corresponding field identifier instead.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @param name `[character]`
#'
#'   The language field names to look up field identifiers for.
#'
#' @export
#' @seealso [language_field_name_for_id()]
#' @returns
#' An integer vector the same length as `name` containing:
#' - The field identifier for the field name, if known.
#' - `NA`, if the field name was not known.
language_field_id_for_name <- function(x, name) {
  check_language(x)

  name <- vec_cast(name, character())
  check_no_missing(name)

  .Call(ffi_language_field_id_for_name, language_pointer(x), name)
}

#' Language field names
#'
#' Get the field name for a field identifier.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @param id `[integer]`
#'
#'   The language field identifiers to look up field names for.
#'
#' @export
#' @seealso [language_field_id_for_name()]
#' @returns
#' A character vector the same length as `id` containing:
#' - The field name for the field identifier, if known.
#' - `NA`, if the field identifier was not known.
language_field_name_for_id <- function(x, id) {
  check_language(x)

  id <- vec_cast(id, integer())
  check_no_missing(id)

  .Call(ffi_language_field_name_for_id, language_pointer(x), id)
}

#' Language symbol count
#'
#' Get the number of symbols contained within a language.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @export
#' @returns
#' A single double value.
language_symbol_count <- function(x) {
  check_language(x)
  .Call(ffi_language_symbol_count, language_pointer(x))
}

#' Language state count
#'
#' Get the number of states traversable within a language.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @export
#' @returns
#' A single double value.
language_state_count <- function(x) {
  check_language(x)
  .Call(ffi_language_state_count, language_pointer(x))
}

#' Language field count
#'
#' Get the number of fields contained within a language.
#'
#' @param x `[tree_sitter_language]`
#'
#'   A tree-sitter language object.
#'
#' @export
#' @returns
#' A single double value.
language_field_count <- function(x) {
  check_language(x)
  .Call(ffi_language_field_count, language_pointer(x))
}

#' @export
language_next_state <- function(x, state, symbol) {
  check_language(x)

  state <- vec_cast(state, integer())
  check_no_missing(state)

  symbol <- vec_cast(symbol, integer())
  check_no_missing(symbol)

  args <- vec_recycle_common(state = state, symbol = symbol)
  state <- args$state
  symbol <- args$symbol

  .Call(ffi_language_next_state, language_pointer(x), state, symbol)
}

#' Is `x` a language?
#'
#' Use `is_language()` to determine if an object has a class of
#' `"tree_sitter_language"`.
#'
#' @param x `[object]`
#'
#'   An object.
#'
#' @export
#' @returns
#' - `TRUE` if `x` is a `"tree_sitter_language"`.
#' - `FALSE` otherwise.
is_language <- function(x) {
  inherits(x, "tree_sitter_language")
}

#' @export
print.tree_sitter_language <- function(x, ...) {
  name <- language_name(x)
  cat(sprintf("language<%s>", name))
  invisible(x)
}

language_pointer <- function(x) {
  x$pointer
}

check_language <- function(
  x,
  ...,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (is_language(x)) {
    return(invisible(NULL))
  }

  stop_input_type(
    x,
    "a <tree_sitter_language>",
    ...,
    arg = arg,
    call = call
  )
}
