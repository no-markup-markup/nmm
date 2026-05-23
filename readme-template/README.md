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
This is a no-markup-markup document, sporting the following features:

[]	Bullet lists:

	-	Here is one bullet item.

	-	Here is another one.

[]	Numbered lists with labels that are either

	[]	automatic, or

	[!]	custom.

	Furthermore, each item can be *named* and *referred to*:

	[]	ITM:x
		The named item can be referred to anywhere in the
		document.

	[]	ITM:y
		When referring to [ITM:x] above, any common initial path
		shared between the location of the referring expression
		and the location of its referent will be omitted. The same
		applies with respect to [ITM:z] below.

	[S]	ITM:z
		Of course, items with custom labels can also be named!

Due to the feature mentioned in [ITM:y], a reference to [ITM:x] or
[ITM:z] occurring elsewhere may appear differently.

[]	Displayed lines of text suitable for mathematical equations,
	which are either

	()	automatically labeled (and named),	DSP:one
	(+)	custom labeled (and named), or,		DSP:two
		unlike [DSP:one] above, unlabeled.
```
</details>

<details>
  <summary><b>default raw text semantics:</b></summary>

```
This is a no-markup-markup document, sporting the following
features:

(a)   Bullet lists:

      ─     Here is one bullet item.

      ─     Here is another one.

(b)   Numbered lists with labels that are either

      (1)   automatic, or

      (!)   custom.

      Furthermore, each item can be n̲a̲m̲e̲d̲ and r̲e̲f̲e̲r̲r̲e̲d̲ t̲o̲:

      (2)   The named item can be referred to anywhere in the
            document.

      (3)   When referring to (2) above, any common initial path
            shared between the location of the referring expression
            and the location of its referent will be omitted. The
            same applies with respect to (S) below.

      (S)   Of course, items with custom labels can also be named!

Due to the feature mentioned in (b)(3), a reference to (b)(2) or
(b)(S) occurring elsewhere may appear differently.

(c)   Displayed lines of text suitable for mathematical equations,
      which are either

      (1)   automatically labeled (and named),
      (+)   custom labeled (and named), or,
            unlike (1) above, unlabeled.
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
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore
eu fugiat nulla pariatur.
```
</details>

<details>
  <summary><b>default raw text semantics:</b></summary>

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
pariatur.
```
</details>

### Text marked to be emphasized by the semantics

<details>
  <summary><b>nmm source:</b></summary>

```
*Lorem ipsum dolor sit amet.*
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
L̲o̲r̲e̲m̲ i̲p̲s̲u̲m̲ d̲o̲l̲o̲r̲ s̲i̲t̲ a̲m̲e̲t̲.̲
```
</details>

### Bullet blocks

<details>
  <summary><b>nmm source:</b></summary>

```
-	bullet block 1

-	bullet block 2

-	bullet block 3
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
─     bullet block 1

─     bullet block 2

─     bullet block 3
```
</details>

### Automatically labeled item blocks

<details>
  <summary><b>nmm source:</b></summary>

```
[]	item block 1

[]	item block 2
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
(a)   item block 1

(b)   item block 2
```
</details>

### Manually labeled item blocks

<details>
  <summary><b>nmm source:</b></summary>

```
[!]	item block 1

[?]	item block 2
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
(!)   item block 1

(?)   item block 2
```
</details>

### Unlabeled displayed blocks

<details>
  <summary><b>nmm source:</b></summary>

```
By Pythagoras we have:

	a²+b² = c²
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
By Pythagoras we have:

      a²+b² = c²
```
</details>

### Automatically labeled displayed blocks

<details>
  <summary><b>nmm source:</b></summary>

```
By Pythagoras we have:

()	a²+b² = c²
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
By Pythagoras we have:

(a)   a²+b² = c²
```
</details>

### Manually labeled displayed blocks

<details>
  <summary><b>nmm source:</b></summary>

```
By Pythagoras we have:

(P)	a²+b² = c²
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
By Pythagoras we have:

(P)   a²+b² = c²
```
</details>

### Displayed block spanning more than one row

<details>
  <summary><b>nmm source:</b></summary>

```
()	1+(1+1)
	  = 1+1
	  = 2
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
(a)   1+(1+1)
        = 1+1
        = 2
```
</details>

### Verbatim blocks

<details>
  <summary><b>nmm source:</b></summary>

```
START	VERBATIM
This text is inside a verbatim block.

Here nothing needs escaping and nothing can be escaped. For each expression E:
⌜\E⌝ renders as ⌜\E⌝.
END	VERBATIM
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
This text is inside a verbatim block.

Here nothing needs escaping and nothing can be escaped. For each expression E:
⌜\E⌝ renders as ⌜\E⌝.
```
</details>

### Nested blocks

<details>
  <summary><b>nmm source:</b></summary>

```
[]	Pythagoras:

	()	a²+b² = c²

	What a remarkable discovery that was!

[]	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
	tempor incididunt ut labore et dolore magna aliqua.

	-	a bullet

	-	another bullet
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
(a)   Pythagoras:

      (1)   a²+b² = c²

      What a remarkable discovery that was!

(b)   Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
      do eiusmod tempor incididunt ut labore et dolore magna aliqua.

      ─     a bullet

      ─     another bullet
```
</details>

### Chapters, sections, appendices and paragraphs

<details>
  <summary><b>nmm source:</b></summary>

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
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
         CHAPTER 1
         This is this chapter's (optional) header
         ════════════════════════════════════════

§ 1.1    This is this section's (optional) header
         ────────────────────────────────────────

¶ 1.1.1  This is this paragraph's (optional) header  Lorem ipsum dolor sit
         amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
         ut labore et dolore magna aliqua:

               a²+b² = c²


¶ 1.1.2  This is another paragraph. It has no header. As mentioned above,
         section headers may also be omitted. This results in poor layout
         however, as the following section demonstrates.



§ 1.2

         This is a section without a header.



§ 1.A    An appendix
         ───────────

         This is an appendix. Neither a section nor an appendix must consist
         of paragraphs, as this text block demonstrates.

         An nmm source is made up of the following, in that order:

         ─     an optional p̲r̲e̲a̲m̲b̲l̲e̲ p̲a̲r̲t̲,

         ─     an optional t̲i̲t̲l̲e̲ p̲a̲r̲t̲,

         ─     an optional a̲u̲t̲h̲o̲r̲ p̲a̲r̲t̲,

         ─     an optional a̲b̲s̲t̲r̲a̲c̲t̲ p̲a̲r̲t̲,

         ─     a non-optional m̲a̲i̲n̲ p̲a̲r̲t̲, and

         ─     an optional r̲e̲f̲e̲r̲e̲n̲c̲e̲s̲ p̲a̲r̲t̲.

         ─     The main part must consist of either of:

               ─     chapters;

               ─     sections (appendices count as sections);

               ─     paragraphs;

               ─     blocks.

         ─     T̲h̲e̲ m̲a̲i̲n̲ p̲a̲r̲t̲ o̲f̲ a̲ c̲h̲a̲p̲t̲e̲r̲ must consist of either of:

               ─     sections (appendices count as sections);

               ─     paragraphs;

               ─     blocks.

         ─     T̲h̲e̲ m̲a̲i̲n̲ p̲a̲r̲t̲ o̲f̲ a̲ s̲e̲c̲t̲i̲o̲n̲, or o̲f̲ a̲n̲ a̲p̲p̲e̲n̲d̲i̲x̲, must consist of
               either of:

               ─     paragraphs;

               ─     blocks.

         ─     T̲h̲e̲ m̲a̲i̲n̲ p̲a̲r̲t̲ o̲f̲ a̲ p̲a̲r̲a̲g̲r̲a̲p̲h̲ must consist of blocks.




         CHAPTER 2
         ═════════

¶ 2.1    This chapter's header is omitted.
```
</details>

### Tags, names, IDs and cross-references

<details>
  <summary><b>nmm source:</b></summary>

```
[]	ITM:name
	This item block has the tag ‘ITM’ and the name ‘name’ and the ID
	‘ITM:name’.

[]	DEF:name
	This item block has the tag ‘DEF’ and the name ‘name’ and ID
	‘DEF:name’.

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
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
(a)   This item block has the tag ‘ITM’ and the name ‘name’ and the
      ID ‘ITM:name’.

(b)   This item block has the tag ‘DEF’ and the name ‘name’ and ID
      ‘DEF:name’.

(c)   Names need not be unique but IDs must be.

(d)   Neither tags nor names may include whitespace, which together
      with where they must be placed removes virtually any practical
      need for escaping valid tags or IDs.

(e)   Tags allow the semantics to have special treatment of blocks
      with certain tags.

This is a reference to the item block with ID ‘ITM:name’: (a). The
following displayed block has the ID ‘DSP:Q5’.

(f)   x+Sy = S(x+y)
```
</details>

### IDs with scope

<details>
  <summary><b>nmm source:</b></summary>

```
¶ PAR:intro

In LaTeX, for example, one may want to refer to something
“locally”---the label (LaTeX's incorrectly named version of ID) is
used for cross-references only in close proximity to where it is
defined. This typically leads to the introduction of
keysmashes[NTE:keysmashes:PAR].

*	NTE:keysmashes:PAR
	https://en.wikipedia.org/wiki/Keysmash

¶ PAR:workings

The ID of the note in the previous paragraph has the suffix ‘:PAR’.
This means that the ID has *paragraph scope*: one may only
“refer”[NTE:refer:PAR] to that note in the paragraph where it is
defined.

The ID of [PAR:intro] is ‘\[PAR:intro]’ and thus has no scope-defining
suffix. This means that [PAR:intro] has *global scope*: it may be
referred to (by using ‘[PAR:intro]’ anywhere in the nmm
source).

*	NTE:refer:PAR
	Scare quotes because ‘referring to a footnote/endnote’ sounds a
	bit weird to me.

*	NTE:gbl_scope:PAR
	One may explicitly indicate global scope by the ‘:GBL’ suffix.
	Thus in this example we could equivalently have used
	‘PAR:intro:GBL’.

¶

The scopes are:

[]	*global scope*---the default[NTE:gbl_scope:PAR];

[]	*chapter scope*---suffix ‘:CH’;

[]	*section scope*---suffix ‘:SEC’; equivalently *appendix
	scope*---suffix ‘:APP’;

[]	*paragraph scope*---suffix ‘:PAR’.

*	NTE:gbl_scope:PAR
	One may explicitly indicate global scope by the suffix ‘:GBL’.
	(This note has ID ‘NTE:gbl_scope:PAR’, just as the note in
	[PAR:workings] has. The duplication this ID is unproblematic
	since they occur in different scopes.
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
¶ 1  In LaTeX, for example, one may want to refer to something
     “locally”---the label (LaTeX's incorrectly named version of ID) is
     used for cross-references only in close proximity to where it is
     defined. This typically leads to the introduction of keysmashes¹.


¶ 2  The ID of the note in the previous paragraph has the suffix ‘:PAR’.
     This means that the ID has p̲a̲r̲a̲g̲r̲a̲p̲h̲ s̲c̲o̲p̲e̲: one may only “refer”² to
     that note in the paragraph where it is defined.

     The ID of ¶ 1 is ‘[PAR:intro]’ and thus has no scope-defining
     suffix. This means that ¶ 1 has g̲l̲o̲b̲a̲l̲ s̲c̲o̲p̲e̲: it may be referred to
     (by using ‘¶ 1’ anywhere in the nmm source).


¶ 3  The scopes are:

     (a)   g̲l̲o̲b̲a̲l̲ s̲c̲o̲p̲e̲---the default³;

     (b)   c̲h̲a̲p̲t̲e̲r̲ s̲c̲o̲p̲e̲---suffix ‘:CH’;

     (c)   s̲e̲c̲t̲i̲o̲n̲ s̲c̲o̲p̲e̲---suffix ‘:SEC’; equivalently a̲p̲p̲e̲n̲d̲i̲x̲
           s̲c̲o̲p̲e̲---suffix ‘:APP’;

     (d)   p̲a̲r̲a̲g̲r̲a̲p̲h̲ s̲c̲o̲p̲e̲---suffix ‘:PAR’.

─────────────────────────────────────────────────────────────────────────
¹  https://en.wikipedia.org/wiki/Keysmash

²  Scare quotes because ‘referring to a footnote/endnote’ sounds a bit
   weird to me.

³  One may explicitly indicate global scope by the suffix ‘:GBL’. (This
   note has ID ‘NTE:gbl_scope:PAR’, just as the note in ¶ 2 has. The
   duplication this ID is unproblematic since they occur in different
   scopes.
```
</details>

### Title, authors, abstract, references

<details>
  <summary><b>nmm source:</b></summary>

```
TITLE:
	Some chapters

AUTHOR:
	Donald Duck

AUTHOR:
	Mickey Mouse

ABSTRACT:
	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
	eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut
	enim ad minim veniam, quis nostrud exercitation ullamco laboris
	nisi ut aliquip ex ea commodo consequat.

	Duis aute irure dolor in reprehenderit in voluptate velit esse
	cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
	cupidatat non proident, sunt in culpa qui officia deserunt
	mollit anim id est laborum.

CH
First chapter

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est
laborum.

CH
Second chapter

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est
laborum.

§ REFS

-	Euler, Leonhard (1740): De summis serierum reciprocarum. In:
	Commentarii academiae scientiarum Petropolitanae, volume 7,
	pages 123–134

-	Tarski, Alfred, and Andrzej Mostowski, and Raphael M.
	Robinson (1953): Undecidable Theories; North-Holland Publishing
	Company; Amsterdam.
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
════════════════════════════════════════════════════════════════════
Some chapters
════════════════════════════════════════════════════════════════════

Donald Duck

Mickey Mouse


ABSTRACT
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
cupidatat non proident, sunt in culpa qui officia deserunt mollit
anim id est laborum.




CHAPTER 1
First chapter
═════════════

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
cupidatat non proident, sunt in culpa qui officia deserunt mollit
anim id est laborum.




CHAPTER 2
Second chapter
══════════════

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
cupidatat non proident, sunt in culpa qui officia deserunt mollit
anim id est laborum.




REFERENCES
══════════

─     Euler, Leonhard (1740): De summis serierum reciprocarum. In:
      Commentarii academiae scientiarum Petropolitanae, volume 7,
      pages 123–134

─     Tarski, Alfred, and Andrzej Mostowski, and Raphael M.
      Robinson (1953): Undecidable Theories; North-Holland
      Publishing Company; Amsterdam.
```
</details>

### Restating paragraphs

<details>
  <summary><b>nmm source:</b></summary>

```
¶ FCT:pythagoras

	a²+b² = c²


¶

I think what Pythagoras discovered is such a remarkable fact that I
want to state it again!


¶ rpt FCT:pythagoras
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
¶ 1  FACT

           a²+b² = c²


¶ 2  I think what Pythagoras discovered is such a remarkable fact that I
     want to state it again!


¶ 3  Fact 1 [restated]

           a²+b² = c²
```
</details>

### Footnotes/endnotes

<details>
  <summary><b>nmm source:</b></summary>

```
This is a sentence followed by a note reference.[NTE:f]

This is another sentence followed by a note reference.[NTE:f']

*	NTE:f
	A footnote/endnote.

*	NTE:f'
	A footnote/endnote.
	It spans multiple lines in the source.

	-	Actually the grammar allows any kind of blocks in a
		footnote; but

	-	implementations of the semantics have quite some freedom
		in how to handle footnotes going wild---for example by
		erroring out.
```
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
This is a sentence followed by a note reference.¹

This is another sentence followed by a note reference.²

────────────────────────────────────────────────────────────────────
¹  A footnote/endnote.

²  A footnote/endnote. It spans multiple lines in the source.

   ─     Actually the grammar allows any kind of blocks in a
         footnote; but

   ─     implementations of the semantics have quite some freedom in
         how to handle footnotes going wild---for example by
         erroring out.
```
</details>

### Under typical circumstances, no need for escape sequences

Even under most atypical circumstances there is no need:

<details>
  <summary><b>nmm source:</b></summary>

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
that in most scientific writing ‘\*’ should be reserved for footnotes.

-	Instead of using ‘*’ for multiplication one should use ‘×’. (One should
	not use the abonimation ‘⋅’!)

-	For denoting *the Kleene star operator* as ‘\*’, one may have to resort
	to escaping. As the No-Markup-Markup grammar uses ‘\*’ as the notation
	for this operator, this is somewhat ironic.

-	For including code snippets, which of course may unavoidably include ‘*’,
	support for verbatim input of files is planned.

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
</details>

<details>
  <summary><b>default raw text semantics</b></summary>

```
¶ 1  EXAMPLE  ¶ ← this is the paragraph symbol.

     While a line ‘¶’ (optional followed by tag or id, then optionally
     followed by a header and one or more empty lines) always marks the
     start of a paragraph, ‘¶ ← this’ does not. Thus no need for escaping
     in the preceeding text block.

     ¶ If one wants to, one may still escape any magic---as in used for
     markup---character.


¶ 2  One possible exception to the intended no need for escaping is the
     need for sometimes escaping the symbol ‘*’ (by writing ‘\*’). The
     creators of No-Markup-Markup acknowledges that this is unfortunate.
     However, they think that in most scientific writing ‘*’ should be
     reserved for footnotes.

     ─     Instead of using ‘*’ for multiplication one should use ‘×’.
           (One should not use the abonimation ‘⋅’!)

     ─     For denoting t̲h̲e̲ K̲l̲e̲e̲n̲e̲ s̲t̲a̲r̲ o̲p̲e̲r̲a̲t̲o̲r̲ as ‘*’, one may have to
           resort to escaping. As the No-Markup-Markup grammar uses ‘*’
           as the notation for this operator, this is somewhat ironic.

     ─     For including code snippets, which of course may unavoidably
           include ‘*’, support for verbatim input of files is planned.


¶ 3  At least theoretically there are situations where escaping of
     something other than ‘*’ is needed.

     ─     This is a reference to the first paragraph: Example 1. This is
           the markup that was used to produce that reference:
           ‘[EX:no_escape]’. (This is the markup that was used to produce
           ‘[EX:no_escape]’: ‘‘\[EX:no_escape]’’.)

     ─     But, for example, ‘[x,y,z]’ is not valid syntax for a
           cross-reference, and thus needs no escaping.
```
</details>

## Help out

TODO
