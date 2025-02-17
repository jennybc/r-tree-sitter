#' @export
TreeCursor <- R6::R6Class(
  "tree_sitter_tree_cursor",
  cloneable = FALSE,
  private = list(
    .tree = NULL,
    .raw = NULL,

    finalize = function() {
      tree_cursor_finalize(self, private)
    }
  ),
  public = list(
    initialize = function(node) {
      tree_cursor_initialize(self, private, node)
    },
    reset = function(node) {
      tree_cursor_reset(self, private, node)
    },
    node = function() {
      tree_cursor_node(self, private)
    },
    field_name = function() {
      tree_cursor_field_name(self, private)
    },
    field_id = function() {
      tree_cursor_field_id(self, private)
    },
    descendant_index = function() {
      tree_cursor_descendant_index(self, private)
    },
    goto_parent = function() {
      tree_cursor_goto_parent(self, private)
    },
    goto_next_sibling = function() {
      tree_cursor_goto_next_sibling(self, private)
    },
    goto_previous_sibling = function() {
      tree_cursor_goto_previous_sibling(self, private)
    },
    goto_first_child = function() {
      tree_cursor_goto_first_child(self, private)
    },
    goto_last_child = function() {
      tree_cursor_goto_last_child(self, private)
    },
    depth = function() {
      tree_cursor_depth(self, private)
    },
    goto_first_child_for_byte = function(byte) {
      tree_cursor_goto_first_child_for_byte(self, private, byte)
    },
    goto_first_child_for_point = function(point) {
      tree_cursor_goto_first_child_for_point(self, private, point)
    }
  )
)

tree_cursor_initialize <- function(self, private, node) {
  check_node(node)

  tree <- node_tree(node)
  node <- node_raw(node)

  private$.tree <- tree
  private$.raw <- .Call(ffi_tree_cursor_initialize, node)

  self
}

tree_cursor_reset <- function(self, private, node) {
  check_node(node)

  tree <- node_tree(node)
  node <- node_raw(node)

  .Call(ffi_tree_cursor_reset, private$.raw, node)

  private$.tree <- tree

  self
}

tree_cursor_node <- function(self, private) {
  tree <- private$.tree
  raw <- .Call(ffi_tree_cursor_node, private$.raw)
  new_node(raw, tree)
}

tree_cursor_field_name <- function(self, private) {
  .Call(ffi_tree_cursor_field_name, private$.raw)
}

tree_cursor_field_id <- function(self, private) {
  .Call(ffi_tree_cursor_field_id, private$.raw)
}

tree_cursor_descendant_index <- function(self, private) {
  .Call(ffi_tree_cursor_descendant_index, private$.raw)
}

tree_cursor_goto_parent <- function(self, private) {
  .Call(ffi_tree_cursor_goto_parent, private$.raw)
}

tree_cursor_goto_next_sibling <- function(self, private) {
  .Call(ffi_tree_cursor_goto_next_sibling, private$.raw)
}

tree_cursor_goto_previous_sibling <- function(self, private) {
  .Call(ffi_tree_cursor_goto_previous_sibling, private$.raw)
}

tree_cursor_goto_first_child <- function(self, private) {
  .Call(ffi_tree_cursor_goto_first_child, private$.raw)
}

tree_cursor_goto_last_child <- function(self, private) {
  .Call(ffi_tree_cursor_goto_last_child, private$.raw)
}

tree_cursor_depth <- function(self, private) {
  .Call(ffi_tree_cursor_depth, private$.raw)
}

tree_cursor_goto_first_child_for_byte <- function(self, private, byte) {
  byte <- coerce_byte(byte)
  .Call(ffi_tree_cursor_goto_first_child_for_byte, private$.raw, byte)
}

tree_cursor_goto_first_child_for_point <- function(self, private, point) {
  check_point(point)

  row <- point_row0(point)
  column <- point_column0(point)

  .Call(ffi_tree_cursor_goto_first_child_for_point, private$.raw, row, column)
}

tree_cursor_finalize <- function(self, private) {
  .Call(ffi_tree_cursor_finalize, private$.raw)
  invisible(NULL)
}
