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

## Examples

TODO

## Features

All code blocks below are valid nmm sources. Do note that they include tabs,
which cannot be replaced by spaces.

### Text blocks

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore
eu fugiat nulla pariatur.
```

### Text marked to be emphasized by the semantics

```
*Lorem ipsum dolor sit amet.*
```

### Bullet blocks

```
-	bullet block 1

-	bullet block 2

-	bullet block 3
```

### Automatically labeled item blocks

```
[]	item block 1

[]	item block 2
```

### Manually labeled item blocks

```
[!]	item block 1

[?]	item block 2
```

### Unlabeled displayed blocks

```
By Pythagoras we have:

	a²+b² = c²
```

### Automatically labeled displayed blocks

```
By Pythagoras we have:

()	a²+b² = c²
```

### Manually labeled displayed blocks

```
By Pythagoras we have:

(P)	a²+b² = c²
```

### Displayed block spanning more than one row

```
	1+(1+1)
	  = 1+1
	  = 2
```

### Nested blocks

```
[]	Pythagoras:

	()	a²+b² = c²

	What a remarkable discovery that was!

[]	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
	tempor incididunt ut labore et dolore magna aliqua.

	- a bullet

	- another bullet
```

### Tags, names, IDs and cross-references

```
[]	ITM:name
	This item block has the tag ‘ITM’ and the name ‘name’ and the ID
	‘ITM:name’.

[]	DEF
	This item block has the tag ‘DEF’. It has no name, and thus neither an
	ID.

[]	Names need not be unique but IDs must be.

[]	Neither tags nor names may include whitespace, thus removing virtually
	any need practical need for escaping valid tags or IDs.

[]	Tags allow the semantics to have special treatments for blocks with
	certain tags.

This is a reference to the item block with ID ‘ITM:name’: [ITM:name]. The
following displayed block has the ID ‘DSP:Q5’.

()	x+Sy = S(x+y)	DSP:Q5
```

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

§ APP

This is an appendix. The optional header was omitted. Neither a section nor an
appendix must consist of paragraphs, as this text block demonstrates.

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
```

### Under typical circumstances, no need for escape sequences

Even under most atypical circumstances there is no need:

```
¶ EX:no_escape

¶ ← this is the paragraph symbol.

While a line ‘¶’ (followed by an optional header and an empty line) always
marks the start of a paragraph, ‘¶ ← this’ does not. Thus no need for escaping
in preceeding text block.

\¶ If one wants to, one may still escape any magic---as in used for special
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

## Try it out

TODO

## Help out

TODO

## Introduction to the language

TODO
