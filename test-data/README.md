# Test data

Each test in this directory is an nmm document `X.nmm` together with
its expected outputs:

| File    | Contents                                                          |
|---------|-------------------------------------------------------------------|
| `X.nmm` | the nmm document                                                  |
| `X.xml` | expected output of `nmm nmm2xml`; must conform to the XML schema  |
| `X.txt` | expected output of `nmm nmm2txt --margin 0`                       |

The test scripts [`test-nmm2xml.sh`](../test-nmm2xml.sh) and
[`test-nmm2txt.sh`](../test-nmm2txt.sh) run every `*.nmm` file in this
directory through both parser backends, Mercury and OCaml, and compare
the output with `X.xml` and `X.txt` respectively. `test-nmm2xml.sh`
also checks that the outputs of the two backends normalize to the same
XML. The scripts only look for `*.nmm` files, so other files here (like
this README) are not treated as tests.

## Excluding a test from a parser backend

A test can be excluded from one or both parser backends by adding a
prefix to the names of all its files:

| Name of the `.nmm` file | Skipped                                                                      | Expected outputs                                                                 |
|-------------------------|------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| `exclude-mercury_X.nmm` | every test with the Mercury backend, and the comparison of the two backends | must exist, and the `.xml` must conform to the schema: the OCaml backend is still tested  |
| `exclude-ocaml_X.nmm`   | every test with the OCaml backend, and the comparison of the two backends   | must exist, and the `.xml` must conform to the schema: the Mercury backend is still tested |
| `exclude-all_X.nmm`     | every test, including the schema check of the `.xml`                         | may be missing                                                                   |

Things to keep in mind:

- The prefix is part of the file name, so the expected outputs of
  `exclude-ocaml_X.nmm` are `exclude-ocaml_X.xml` and
  `exclude-ocaml_X.txt`.
- The prefix must match exactly, including the underscore:
  `exclude-mercuryX.nmm` is not excluded from anything.
- The prefixes apply to both test scripts. A test can't be excluded
  from a backend for only one of the output formats.
- Each skipped test prints a warning on stderr. Skipped tests are not
  failures: they don't affect the exit status of the scripts.

## Excluding and including a test again

Rename all of the test's files together, using `git mv` so that their
history is kept. For example, to exclude the test `X` from the OCaml
backend, run this in this directory:

```sh
for ext in nmm xml txt; do git mv "X.$ext" "exclude-ocaml_X.$ext"; done
```

To include the test again, rename the files back. An `exclude-all_`
test may be missing its expected outputs; add them before including
the test again.

## Why a test is excluded

Every exclusion should have a GitHub issue that explains why the test
is excluded and what is needed to include it again, and the commit
that adds the prefix should refer to that issue.

This README deliberately doesn't list the excluded tests, since such a
list would go out of date. To see the current ones, run:

```sh
ls exclude-*.nmm
```

## Files used by name

Besides going through all `*.nmm` files, `test-nmm2xml.sh` uses
`simple.xml` and `tagged_itm.xml` by name, to check that
`nmm normalize-xml` gives different output for two different
documents. Don't rename these two files (for example by adding an
exclusion prefix), or that check breaks.
