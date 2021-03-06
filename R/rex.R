#' @include escape.R
#' @include utils.R
NULL

#' @export
#' @family rex
capture <- . <- function(...) {
  p( "(", p(escape_dots(...)), ")" )
}

#' @export
#' @family rex
named_capture <- .. <- function(name, ... ) {
  p( "(?<", name, ">", p(escape_dots(...)), ")" )
}

#' @export
#' @family rex
group <- function(...) {
  p( "(?:", p(escape_dots(...)), ")" )
}

#' @export
#' @family rex
rex <- function(..., env = parent.frame()) {
  args <- lazyeval::lazy_dots(...)
  rex_(args, env)
}

#' @export
#' @family rex
any_of <- function(...) {
  p( "[", p(escape_dots(...)), "]" )
}

#' @export
#' @family rex
any_except <- none_of <- function(...) {
  p( "[^", p(escape_dots(...)), "]" )
}

#' @export
#' @family rex
range <- function(x, y) {
  p(escape(x), '-', escape(y))
}

#' @export
rex_ <- function(args, env = parent.frame()) {

  args <- lazyeval::as.lazy_dots(args, env)

  output <- regex(p(escape(lazyeval::lazy_eval(args, shortcuts))))

  return(output)
}

#' @export
print.regex <- function(x, ...){
  cat(paste(strwrap(x), collapse="\n"), "\n", sep="")
}

shortcuts <- list(

  ## Paste / repeater
  "*" = function(x, y) {
    paste( rep(x, times=y), collapse="" )
  },

  ## Character class shortcuts
  alnum = regex("[[:alnum:]]"),
  alpha = letter <- regex("[[:alpha:]]"),
  blank = regex("[[:blank:]]"),
  cntrl = regex("[[:cntrl:]]"),
  digit = regex("[[:digit:]]"),
  graph = regex("[[:graph:]]"),
  lower = regex("[[:lower:]]"),
  print = regex("[[:print:]]"),
  punct = regex("[[:punct:]]"),
  space = regex("[[:space:]]"),
  upper = regex("[[:upper:]]"),
  xdigit = regex("[[:xdigit:]]"),

  space = regex("\\s"),
  spaces = regex("\\s+"),
  non_space = regex("\\S"),
  non_spaces = regex("\\S+"),

  number = regex("\\d"),
  numbers = regex("\\d+"),
  non_number = non_digit <- regex("\\D"),

  letter = regex("[a-zA-Z]"),
  letters = regex("[a-zA-Z]+"),
  non_letter = regex("[^a-zA-Z]"),

  start = regex("^"),
  end = regex("$"),

  dot = escape("."),

  any = any_char <- regex("."),
  any_chars = regex(".+"),
  anything = regex(".*")
)

#' @export
regex <- function(x) structure(x, class='regex')
