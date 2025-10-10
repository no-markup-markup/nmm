# The No-Markup-Markup markup language

No-Markup-Markup (nmm) is a heavily opinionated markup language. Its intended
use is for writing scientific manuscripts. It is opinionated in at least the
following senses:

- nmm is intended to be as what-you-see-is-what-you-get (WYSIWYG) as possible,
  only deviating from this goal for necessities such as cross-references.

- In line with the WYSIWYG goal, available markup options are very few. Users
  are expected to make heavy use of the quite generous Unicode coverage of
  symbols used in scientific writing. For example, instead of LaTeX's `$\alpha$`
  the user is expected to simply write `α` (U+03B1), or even `𝛼` (U+1D6FC
  “Mathematical Italic Small Alpha”).

- Currently, nmm has two semantics: raw text and HTML. These are not
  flexible—they reflect a specific approach to draft organization that the nmm's
  creators likes. (Of course, one may write one's own semantics. nmm is capable
  of generating an XML representation of the abstract syntax tree of an nmm
  source. Thus using these XML representations, one may implement one's own
  semantics—though doing so most likely would be a non-trivial amount of work.)

## Project status

Heavily work-in-progress:

- currently very unpolished;

- not very user friendly—quite uninformative error messages, and inadequate
  documentation.

## Features

- Bullet blocks:

  ```
  -	bullet 1

  -	bullet 2
  ```

- Automatically labeled item blocks:

  ```
  []	item 1

  []	item 2
  ```

- Manually labeled item blocks:

  ```
  [!]	item 1

  [!!]	item 2
  ```

- Automatically labeled displayed blocks:

  ```
  ()	a²+b² = c²
  ```

- Manually labeled displayed blocks:

  ```
  (P)	a²+b² = c²
  ```

- Text blocks:

  ```
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
  incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
  nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore
  eu fugiat nulla pariatur.
  ```

## Try it out

TODO

## Example sources with raw text semantics

See TODO

## Help out

TODO

## Introduction to the language

TODO
