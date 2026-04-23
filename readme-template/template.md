# The No-Markup-Markup markup language

No-Markup-Markup (nmm) is a heavily opinionated markup language. Its intended
use is for writing scientific manuscripts. It is opinionated in at least the
following senses:

- nmm is intended to be as what-you-see-is-what-you-get (WYSIWYG) as possible,
  only deviating from this goal for necessities such as cross-references.

- In line with the WYSIWYG goal, available markup options are very few. Users
  are expected to make heavy use of the quite generous Unicode coverage of
  symbols used in scientific writing. For example, instead of LaTeX's `$\alpha$`
  users are expected to simply write `α` (U+03B1), or even `𝛼` (U+1D6FC
  “Mathematical Italic Small Alpha”).

- Currently, nmm has two semantics: raw text and HTML. The raw text semantics is
  not flexible at all: it reflects a specific approach to manuscript
  organization and layout that the nmm creators like. The HTML semantics is
  flexible only in the sense that one might override the default CSS. (One may
  of course also do some JavaScript magic—please do not!) Of course, one may
  write one's own semantics. nmm is capable of generating an XML representation
  of the abstract syntax tree of an nmm source. Thus using these XML
  representations, one may implement one's own semantics—though doing so most
  likely would be a non-trivial amount of work.

## Project status

Heavily work-in-progress:

- currently very unpolished;

- not user friendly—unforgiving grammar, uninformative error messages and
  inadequate documentation.

## Why design another markup language for scientific writing? What is wrong with, for example, Markdown?

- While Markdown is indeed quite WYSIWYG, the designer of the language wanted
  even more WYSIWYG—in particular, WYSIWYG with respect to the intended
  semantics.

- The designer of the language wanted a particular semantics—for example,
  sections and paragraphs numbered using the section symbol (‘§’) respectively
  the paragraph symbol (‘¶’). To the best of the language designer's knowledge,
  no close-to-WYSIWYG language provided this semantics out of the box.

- For the language creators, it has so far been a fun and educational project!

## Examples

Do note that the nmm source below include tabs. These tabs cannot be turned into
spaces. When working with nmm sources, a tab width of 6 spaces corresponds to
the raw text semantics.

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/example.nmm
```
</details>

<details>
  <summary><b>default raw text semantics:</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/example.txt
```
</details>

More examples below.

## Try it out

- With a flake-enabled* install of the [Nix package manager](https://nixos.org):

  ```
  nix run --refresh github:no-markup-markup/nmm
  ```

  (The `--refresh` flag may be omitted once a first version is released.)

  * This one should work-out-of-the box:

  <https://github.com/DeterminateSystems/nix-installer>

- Without a flake-enabled install of the Nix package manager: sorry, but
  currently you are on your own.† The following might work:

  - Check `flake.nix` for `buildInputs` and make sure you have these installed.

  - Clone this repo and run `make bin`.

  - Run `./bin/nmm`.

  † Help with how to package for other systems very much appreciated! The
  creators of nmm has no packaging experience outside of the nix ecosystem.

## Features

Do note that many of the nmm sources below include tabs. These tabs cannot be
turned into spaces.

### Text blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/text-blocks.nmm
```
</details>

<details>
  <summary><b>default raw text semantics:</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/text-blocks.txt
```
</details>

### Text marked to be emphasized by the semantics

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/emphasized-text.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/emphasized-text.txt
```
</details>

### Bullet blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/bullet-blocks.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/bullet-blocks.txt
```
</details>

### Automatically labeled item blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/item-blocks-auto.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/item-blocks-auto.txt
```
</details>

### Manually labeled item blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/item-blocks-manual.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/item-blocks-manual.txt
```
</details>

### Unlabeled displayed blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-unlabeled.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-unlabeled.txt
```
</details>

### Automatically labeled displayed blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-auto.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-auto.txt
```
</details>

### Manually labeled displayed blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-manual.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-manual.txt
```
</details>

### Displayed block spanning more than one row

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-multple-lines.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-multple-lines.txt
```
</details>

### Verbatim blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/vrb-block.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/vrb-block.txt
```
</details>

### Nested blocks

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/nested-blocks.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/nested-blocks.txt
```
</details>

### Tags, names, IDs and cross-references

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/tags-names-c-refs.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/tags-names-c-refs.txt
```
</details>

### Chapters, sections, appendices and paragraphs

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/chapters-sections-appendices-paragraphs.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/chapters-sections-appendices-paragraphs.txt
```
</details>

### Title, authors, abstract, references

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/title-author-date-abstract-references.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/title-author-date-abstract-references.txt
```
</details>

### Restating paragraphs

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/restating_paragraphs.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/restating_paragraphs.txt
```
</details>

### Footnotes/endnotes

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/notes.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/notes.txt
```
</details>

### Under typical circumstances, no need for escape sequences

Even under most atypical circumstances there is no need:

<details>
  <summary><b>nmm source:</b></summary>

```
INCLUDE-FILE ./nmm-sources/escaping.nmm
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/escaping.txt
```
</details>

## Help out

TODO
