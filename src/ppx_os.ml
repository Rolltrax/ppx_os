open Ppxlib

let name = "operating_system"


let os = match Sys.backend_type with
  | Other(str) -> str
  | Native
  | Bytecode -> match Sys.os_type with
    | "Win32" -> "Windows"
    | _ ->
      let otpt = Unix.open_process_in("uname") in
      let uname = input_line(otpt) in
      let _ = close_in(otpt) in
      match uname with
        | "Darwin" -> "macOS"
        | str -> str

let expand ~loc ~path:_ =
  [%expr [%e Ast_builder.Default.estring os ~loc]]

let ext =
  Extension.declare
    name
    Extension.Context.expression
    Ast_pattern.(pstr nil)
    expand

let () = Ppxlib.Driver.register_transformation name ~extensions:[ext]