module Outputs = struct
  type t =
    | Stdout
    | Stderr
    | Outputs (** Both Stdout and Stderr *)
end

module type Ast = sig
  type path
  type string

  type t =
    | Run            of path * string list
    | Chdir          of path * t
    | Setenv         of string * string * t
    | Redirect       of Outputs.t * path * t
    | Ignore         of Outputs.t * t
    | Progn          of t list
    | Echo           of string
    | Create_file    of path
    | Cat            of path
    | Copy           of path * path
    | Symlink        of path * path
    | Copy_and_add_line_directive of path * path
    | System         of string
    | Bash           of string
    | Update_file    of path * string
    | Rename         of path * path
    | Remove_tree    of path
    | Try_run        of path * string list * t
    | Located_error  of path * int * int * int * string
end

