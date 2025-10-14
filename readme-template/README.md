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
-	bullet block 1

-	bullet block 2

-	bullet block 3
```

<details>
  <summary><b>raw text semantics:</b></summary>

```
─     bullet block 1

─     bullet block 2

─     bullet block 3
```
</details>

### Text marked to be emphasized by the semantics

```
*Lorem ipsum dolor sit amet.*
```

<details>
  <summary><b>raw text semantics</b></summary>

```
L̲o̲r̲e̲m̲ ̲i̲p̲s̲u̲m̲ ̲d̲o̲l̲o̲r̲ ̲s̲i̲t̲ ̲a̲m̲e̲t̲.̲
```
</details>

### Bullet blocks

```
-	bullet block 1

-	bullet block 2

-	bullet block 3
```

<details>
  <summary><b>raw text semantics</b></summary>

```
─     bullet block 1

─     bullet block 2

─     bullet block 3
```
</details>

### Automatically labeled item blocks

```
[]	item block 1

[]	item block 2
```

<details>
  <summary><b>raw text semantics</b></summary>

```
(1)   item block 1

(2)   item block 2
```
</details>

### Manually labeled item blocks

```
[!]	item block 1

[?]	item block 2
```

<details>
  <summary><b>raw text semantics</b></summary>

```
(!)   item block 1

(?)   item block 2
```
</details>

### Unlabeled displayed blocks

```
By Pythagoras we have:

	a²+b² = c²
```

<details>
  <summary><b>raw text semantics</b></summary>

```
By Pythagoras we have:

      a²+b² = c²
```
</details>

### Automatically labeled displayed blocks

```
By Pythagoras we have:

()	a²+b² = c²
```

<details>
  <summary><b>raw text semantics</b></summary>

```
By Pythagoras we have:

(1)   a²+b² = c²
```
</details>

### Manually labeled displayed blocks

```
By Pythagoras we have:

(P)	a²+b² = c²
```

<details>
  <summary><b>raw text semantics</b></summary>

```
By Pythagoras we have:

(P)   a²+b² = c²
```
</details>

### Displayed block spanning more than one row

```
()	1+(1+1)
	  = 1+1
	  = 2
```

<details>
  <summary><b>raw text semantics</b></summary>

```
(1)   1+(1+1)
        = 1+1
        = 2
```
</details>

### Nested blocks

```
[]	Pythagoras:

	()	a²+b² = c²

	What a remarkable discovery that was!

[]	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
	tempor incididunt ut labore et dolore magna aliqua.

	-	a bullet

	-	another bullet
```

<details>
  <summary><b>raw text semantics</b></summary>

```
(1)   Pythagoras:

      (a)   a²+b² = c²

      What a remarkable discovery that was!

(2)   Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
      do eiusmod tempor incididunt ut labore et dolore magna aliqua.

      ─     a bullet

      ─     another bullet
```
</details>

### Tags, names, IDs and cross-references

```
[]	ITM:name
	This item block has the tag ‘ITM’ and the name ‘name’ and the ID
	‘ITM:name’.

[]	DEF
	This item block has the tag ‘DEF’. It has no name, and thus
	neither an ID.

[]	Names need not be unique but IDs must be.

[]	Neither tags nor names may include whitespace, which together
	with where they must be placed removes virtually any practical
	need for escaping valid tags or IDs.

[]	Tags allow the semantics to have special treatment of blocks
	with certain tags.

This is a reference to the item block with ID ‘ITM:name’: [ITM:name].
The following displayed block has the ID ‘DSP:Q5’.

()	x+Sy = S(x+y)	DSP:Q5
```

<details>
  <summary><b>raw text semantics</b></summary>

```
(1)   This item block has the tag ‘ITM’ and the name ‘name’ and the
      ID ‘ITM:name’.

(2)   DEF This item block has the tag ‘DEF’. It has no name, and
      thus neither an ID.

(3)   Names need not be unique but IDs must be.

(4)   Neither tags nor names may include whitespace, which together
      with where they must be placed removes virtually any practical
      need for escaping valid tags or IDs.

(5)   Tags allow the semantics to have special treatment of blocks
      with certain tags.

This is a reference to the item block with ID ‘ITM:name’: (1). The
following displayed block has the ID ‘DSP:Q5’.

(6)   x+Sy = S(x+y)
```
</details>

### Chapters, sections, appendices and paragraphs

```
CH
This is this chapter's (optional) header

§
This is this section's (optional) header

¶
This is this paragraph's (optional) header

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua:

	a²+b² = c²

¶

This is another paragraph. It has no header. As mentioned above, section headers
may also be omitted. This results in poor layout however, as the following
section demonstrates.

§

This is a section without a header.

§ APP
An appendix

This is an appendix. Neither a section nor an appendix must consist of
paragraphs, as this text block demonstrates.

An nmm source is made up of the following, in that order:

-	an optional *preamble part*,

-	an optional *title part*,

-	an optional *author part*,

-	an optional *abstract part*,

-	a non-optional *main part*, and

-	an optional *references part*.

-	The main part must consist of either of:

	-	chapters;

	-	sections (appendices count as sections);

	-	paragraphs;

	-	blocks.

-	*The main part of a chapter* must consist of either of:

	-	sections (appendices count as sections);

	-	paragraphs;

	-	blocks.

-	*The main part of a section*, or *of an appendix*, must consist of
	either of:

	-	paragraphs;

	-	blocks.

-	*The main part of a paragraph* must consist of blocks.

CH

¶

This chapter's header is omitted.
```

<details>
  <summary><b>raw text semantics</b></summary>

```
            CHAPTER 1
            This is this chapter's (optional) header
            ════════════════════════════════════════

§ 1.1       This is this section's (optional) header
            ────────────────────────────────────────

¶ 1.1.1     This is this paragraph's (optional) header  Lorem ipsum dolor sit
            amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
            ut labore et dolore magna aliqua:

                  a²+b² = c²


¶ 1.1.2     This is another paragraph. It has no header. As mentioned above,
            section headers may also be omitted. This results in poor layout
            however, as the following section demonstrates.



§ 1.2

            This is a section without a header.



§ 1.A       An appendix
            ───────────

            This is an appendix. Neither a section nor an appendix must consist
            of paragraphs, as this text block demonstrates.

            An nmm source is made up of the following, in that order:

            ─     an optional p̲r̲e̲a̲m̲b̲l̲e̲ ̲p̲a̲r̲t̲,

            ─     an optional t̲i̲t̲l̲e̲ ̲p̲a̲r̲t̲,

            ─     an optional a̲u̲t̲h̲o̲r̲ ̲p̲a̲r̲t̲,

            ─     an optional a̲b̲s̲t̲r̲a̲c̲t̲ ̲p̲a̲r̲t̲,

            ─     a non-optional m̲a̲i̲n̲ ̲p̲a̲r̲t̲, and

            ─     an optional r̲e̲f̲e̲r̲e̲n̲c̲e̲s̲ ̲p̲a̲r̲t̲.

            ─     The main part must consist of either of:

                  ─     chapters;

                  ─     sections (appendices count as sections);

                  ─     paragraphs;

                  ─     blocks.

            ─     T̲h̲e̲ ̲m̲a̲i̲n̲ ̲p̲a̲r̲t̲ ̲o̲f̲ ̲a̲ ̲c̲h̲a̲p̲t̲e̲r̲ must consist of either of:

                  ─     sections (appendices count as sections);

                  ─     paragraphs;

                  ─     blocks.

            ─     T̲h̲e̲ ̲m̲a̲i̲n̲ ̲p̲a̲r̲t̲ ̲o̲f̲ ̲a̲ ̲s̲e̲c̲t̲i̲o̲n̲, or o̲f̲ ̲a̲n̲ ̲a̲p̲p̲e̲n̲d̲i̲x̲, must consist of
                  either of:

                  ─     paragraphs;

                  ─     blocks.

            ─     T̲h̲e̲ ̲m̲a̲i̲n̲ ̲p̲a̲r̲t̲ ̲o̲f̲ ̲a̲ ̲p̲a̲r̲a̲g̲r̲a̲p̲h̲ must consist of blocks.




            CHAPTER 2
            ═════════

¶ 2.1       This chapter's header is omitted.
```
</details>

### Under typical circumstances, no need for escape sequences

Even under most atypical circumstances there is no need:

```
¶ EX:no_escape

¶ ← this is the paragraph symbol.

While a line ‘¶’ (optional followed by tag or id, then optionally followed by a
header and one or more empty lines) always marks the start of a paragraph, ‘¶ ←
this’ does not. Thus no need for escaping in the preceeding text block.

\¶ If one wants to, one may still escape any magic---as in used for
markup---character.

¶

One possible exception to the intended no need for escaping is the need for
sometimes escaping the symbol ‘\*’ (by writing ‘\\\*’). The creators of
No-Markup-Markup acknowledges that this is unfortunate. However, they think
that in most scientific writing ‘\*’ should be reserved for footnotes*.

-	Instead of using ‘*’ for multiplication one should use ‘×’. (One should
	not use the abonimation ‘⋅’!)

-	For denoting *the Kleene star operator* as ‘\*’, one may have to resort
	to escaping. As the No-Markup-Markup grammar uses ‘\*’ as the notation
	for this operator, this is somewhat ironic.

-	For including code snippets, which of course may unavoidably include ‘*’,
	support for verbatim input of files is planned.

* No-Markup-Markup support for footnotes is planned.

¶

At least theoretically there are situations where escaping of something other
than ‘\*’ is needed.

-	This is a reference to the first paragraph: [EX:no_escape]. This is the
	markup that was used to produce that reference: ‘\[EX:no_escape]’. (This
	is the markup that was used to produce ‘\[EX:no_escape]’:
	‘‘\\\[EX:no_escape]’’.)

-	But, for example, ‘[x,y,z]’ is not valid syntax for a cross-reference,
	and thus needs no escaping.
```

<details>
  <summary><b>raw text semantics</b></summary>

```
¶ 1         ¶ ← this is the paragraph symbol.

            While a line ‘¶’ (optional followed by tag or id, then optionally
            followed by a header and one or more empty lines) always marks the
            start of a paragraph, ‘¶ ← this’ does not. Thus no need for escaping
            in the preceeding text block.

            ¶ If one wants to, one may still escape any magic---as in used for
            markup---character.


¶ 2         One possible exception to the intended no need for escaping is the
            need for sometimes escaping the symbol ‘*’ (by writing ‘\*’). The
            creators of No-Markup-Markup acknowledges that this is unfortunate.
            However, they think that in most scientific writing ‘*’ should be
            reserved for footnotes*.

            ─     Instead of using ‘*’ for multiplication one should use ‘×’.
                  (One should not use the abonimation ‘⋅’!)

            ─     For denoting t̲h̲e̲ ̲K̲l̲e̲e̲n̲e̲ ̲s̲t̲a̲r̲ ̲o̲p̲e̲r̲a̲t̲o̲r̲ as ‘*’, one may have to
                  resort to escaping. As the No-Markup-Markup grammar uses ‘*’
                  as the notation for this operator, this is somewhat ironic.

            ─     For including code snippets, which of course may unavoidably
                  include ‘*’, support for verbatim input of files is planned.

            * No-Markup-Markup support for footnotes is planned.


¶ 3         At least theoretically there are situations where escaping of
            something other than ‘*’ is needed.

            ─     This is a reference to the first paragraph: 1. This is the
                  markup that was used to produce that reference:
                  ‘[EX:no_escape]’. (This is the markup that was used to produce
                  ‘[EX:no_escape]’: ‘‘\[EX:no_escape]’’.)

            ─     But, for example, ‘[x,y,z]’ is not valid syntax for a
                  cross-reference, and thus needs no escaping.
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
