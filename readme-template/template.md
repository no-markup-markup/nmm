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
  flexible—they reflect a specific approach to manuscript organization and
  layout that the nmm's creators like. (Of course, one may write one's own
  semantics. nmm is capable of generating an XML representation of the abstract
  syntax tree of an nmm source. Thus using these XML representations, one may
  implement one's own semantics—though doing so most likely would be a
  non-trivial amount of work.)

## Project status

Heavily work-in-progress:

- currently very unpolished;

- not user friendly—unforgiving grammar, uninformative error messages and
  inadequate documentation.

## Examples

TODO

## Features

### Text blocks

<b>nmm-source:</b>

```
INCLUDE-FILE ./nmm-sources/bullet-blocks.nmm
```

<details>
  <summary><b>raw text semantics:</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/bullet-blocks.txt
```
</details>

### Text marked to be emphasized by the semantics

```
INCLUDE-FILE ./nmm-sources/emphasized-text.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/emphasized-text.txt
```
</details>

### Bullet blocks

```
INCLUDE-FILE ./nmm-sources/bullet-blocks.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/bullet-blocks.txt
```
</details>

### Automatically labeled item blocks

```
INCLUDE-FILE ./nmm-sources/item-blocks-auto.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/item-blocks-auto.txt
```
</details>

### Manually labeled item blocks

```
INCLUDE-FILE ./nmm-sources/item-blocks-manual.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/item-blocks-manual.txt
```
</details>

### Unlabeled displayed blocks

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-unlabeled.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-unlabeled.txt
```
</details>

### Automatically labeled displayed blocks

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-auto.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-auto.txt
```
</details>

### Manually labeled displayed blocks

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-manual.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-manual.txt
```
</details>

### Displayed block spanning more than one row

```
INCLUDE-FILE ./nmm-sources/displayed-blocks-multple-lines.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/displayed-blocks-multple-lines.txt
```
</details>

### Nested blocks

```
INCLUDE-FILE ./nmm-sources/nested-blocks.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/nested-blocks.txt
```
</details>

### Tags, names, IDs and cross-references

```
INCLUDE-FILE ./nmm-sources/tags-names-c-refs.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/tags-names-c-refs.txt
```
</details>

### Chapters, sections, appendices and paragraphs

```
INCLUDE-FILE ./nmm-sources/chapters-sections-appendices-paragraphs.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/chapters-sections-appendices-paragraphs.txt
```
</details>

### Under typical circumstances, no need for escape sequences

Even under most atypical circumstances there is no need:

```
INCLUDE-FILE ./nmm-sources/escaping.nmm
```

<details>
  <summary><b>raw text semantics</b></summary>

```
INCLUDE-FILE ./raw-text-semantics/escaping.txt
```
</details>

## Why design another markup language for scientific writing? What is wrong with, for example, Markdown?

-	While Markdown is indeed quite WYSIWYG, the inventor of the language wanted
    even more WYSIWYG—in particular, WYSIWYG with respect to the intended
    semantics.

-	It has so far been a fun project!

## Try it out

TODO

## Help out

TODO

## Introduction to the language

TODO
