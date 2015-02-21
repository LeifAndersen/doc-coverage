#lang scribble/manual

@(require scribble/eval
          (for-label doc-coverage
                     racket/base))

@title{Documentation Coverage}

@(define the-eval (make-base-eval))
@(the-eval '(require "main.rkt"))

@defmodule[doc-coverage]

@author[@author+email["Jack Firth" "jackhfirth@gmail.com"]]

This library provides functions for inspecting the number of 
bindings a module exports with and without corresponding
Scribble documentation, as well as Rackunit tests based on
this information. This allows a module author to enforce in
a test suite that their modules provide no undocumented
bindings.

source code: @url["https://github.com/jackfirth/doc-coverage"]

@section{Basic Module Documentation Reflection}

These primitives for examining module documentation information
allow the construction of tests and reflection tools. They are
implemented with Racket's native module reflection functions
combined with Scribble's @racket[xref?] tables.

@defproc[(has-docs? [mod symbol?] [binding symbol?]) boolean?]{
  Returns @racket[#t] if the module @racket[mod] provides
  @racket[binding] with documentation, and @racket[#f]
  otherwise.
  @examples[#:eval the-eval
    (has-docs? 'racket/list 'second)
    (has-docs? 'racket/match 'match-...-nesting)
]}

@defproc[(module->all-exported-names [mod symbol?]) (list/c symbol?)]{
  Returns a list of all bindings exported by @racket[mod].
  Similar to @racket[module->exports], but provides no
  phase level information and lists both value bindings
  and syntax bindings.
  @examples[#:eval the-eval
    (module->all-exported-names 'racket/match)
]}

@defproc[(module->documented-exported-names [mod symbol?]) (list/c symbol?)]{
  Returns a list of only the bindings exported by @racket[mod]
  with Scribble documentation.
  @examples[#:eval the-eval
    (module->documented-exported-names 'racket/match)
]}

@defproc[(module->undocumented-exported-names [mod symbol?]) (list/c symbol?)]{
  Returns a list of only the bindings exported by @racket[mod]
  without Scribble documentation.
  @examples[#:eval the-eval
    (module->undocumented-exported-names 'racket/match)
]}

@section{Module Documentation Statistics}

These procedures are simple numeric tools built on the core
module documentation reflection functions.

@defproc[(module-num-exports [mod symbol?]) exact-nonnegative-integer?]{
  Returns the number of bindings exported by @racket[mod], as
  determined by @racket[module->all-exported-names].
  @examples[#:eval the-eval
    (module-num-exports 'racket/match)
    (module-num-exports 'racket/list)
]}

@defproc[(module-num-documented-exports [mod symbol?]) exact-nonnegative-integer?]{
  Similar to @racket[module-num-exports], but only for documented
  exports.
  @examples[#:eval the-eval
    (module-num-documented-exports 'racket/match)
]}

@defproc[(module-num-undocumented-exports [mod symbol?]) exact-nonnegative-integer?]{
  Similar to @racket[module-num-exports], but only for undocumented
  exports.
  @examples[#:eval the-eval
    (module-num-undocumented-exports 'racket/match)
]}

@defproc[(module-documentation-ratio [mod symbol?]) exact-nonnegative-number?]{
  Returns the percentage of bindings in @racket[mod] that are
  documented.
  @examples[#:eval the-eval
    (module-documentation-ratio 'racket/match)
]}

