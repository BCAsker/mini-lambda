(* Compiler Construction - Minimal Lambda Language
 *
 * This file defines the lexer of the language: a list of
 * regexes which produce tokens defined by and consumed by
 * the parser.
 *)

{
  open Parser
  open Lexing
  exception Error of int * int * char
}

rule token = parse
  | ['\n'] { Lexing.new_line lexbuf; token lexbuf }
  | [' ' '\t'] { token lexbuf }
  | eof { EOF }
  | '+' { PLUS }
  | '-' { MINUS }
  | "==" { EQUAL }
  | "!=" { NEQUAL }
  | "&&" { AND }
  | "||" { OR }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | '{' { LBRACE }
  | '}' { RBRACE }
  | ',' { COMMA }
  | ";" { SEMI }
  | "\\" { LAMBDA }
  | "->" { ARROW }
  | "func" { FUNC }
  | "return" { RETURN }
  | "<-" { BIND }
  | "if" { IF }
  | "then" { THEN }
  | "true" { BOOL(bool_of_string "true") }
  | "false" { BOOL(bool_of_string "false") }
  | ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '_' '0'-'9']* {IDENT (Lexing.lexeme lexbuf)}
  | ['0' - '9']+ as str { INT(int_of_string str) }
  | _ as c {
    let { pos_lnum; pos_cnum; pos_bol; _} = Lexing.lexeme_start_p lexbuf in
    raise (Error(pos_lnum, pos_cnum - pos_bol + 1, c))
  }
