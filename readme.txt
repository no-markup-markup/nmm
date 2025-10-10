The syntax of the No-Markup-Markup (nmm) markup language

Anders Lundstedt

============================================================================
§ 1   Introduction
============================================================================

¶ 1.1 Here is simple example of a no-markup-markup source, and of a
      possible raw text semantics for it. Below, ‘⇥’, optional followed by
      “filler” dots ‘⋅’, denotes a tab.

      ─     Source:

                  │TITLE:
                  │⇥⋅⋅⋅⋅⋅A simple example
                  │
                  │AUTHOR:
                  │⇥⋅⋅⋅⋅⋅Donald Duck
                  │
                  │¶ PAR:motivation
                  │
                  │Consider:
                  │
                  │⇥⋅⋅⋅⋅⋅1       = 1²
                  │⇥⋅⋅⋅⋅⋅1+3     = 4  = 2²
                  │⇥⋅⋅⋅⋅⋅1+3+5   = 9  = 3²
                  │⇥⋅⋅⋅⋅⋅1+3+5+7 = 16 = 4².
                  │⇥⋅⋅⋅⋅⋅        ⋮    ⋮
                  │
                  │¶ CONJ:conjecture
                  │
                  │Let
                  │
                  │⇥⋅⋅⋅⋅⋅   Σ : ℕ → ℕ
                  │⇥⋅⋅⋅⋅⋅Σ(n) ≔
                  │⇥⋅⋅⋅⋅⋅  the sum of the n first odd natural numbers.
                  │
                  │Then for each natural number n:
                  │
                  │⇥⋅⋅⋅⋅⋅Σ(n) = n².
                  │
                  │¶
                  │
                  │The motivation for [CONJ:conjecture] is in
                  │[PAR:motivation].

            Above I used ‘⇥’ followed by dots to indicate a tab, which I
            will continue to do. In this README, I use a tab length of 6.

      ─     A resonable raw text semantics:

                  │A simple example
                  │━━━━━━━━━━━━━━━━
                  │
                  │Donald Duck
                  │
                  │
                  │
                  │¶ 1   Consider:
                  │
                  │            1       = 1²
                  │            1+3     = 4  = 2²
                  │            1+3+5   = 9  = 3²
                  │            1+3+5+7 = 16 = 4²
                  │                    ⋮    ⋮
                  │
                  │
                  │¶ 2   CONJECTURE Let
                  │
                  │               Σ : ℕ → ℕ
                  │            Σ(n) ≔
                  │              the sum of the n first odd natural numbers.
                  │
                  │      Then for each natural number n:
                  │
                  │            Σ(n) = n².
                  │
                  │
                  │¶ 3   The motivation for Conjecture 2 is in ¶ 1.

============================================================================
§ 2   Syntax
============================================================================

¶ 2.1 An nmm source is made up of the following, in that order:

      ─     an optional p̱ṟe̱a̱m̱ḇḻe̱ ̱p̱a̱ṟṯ,

      ─     an optional ṯi̱ṯḻe̱ ̱p̱a̱ṟṯ,

      ─     an optional a̱u̱ṯẖo̱ṟ ̱p̱a̱ṟṯ,

      ─     an optional a̱ḇs̱ṯṟa̱c̱ṯ ̱p̱a̱ṟṯ,

      ─     a non-optional m̱a̱i̱ṉ ̱p̱a̱ṟṯ, and

      ─     an optional ṟe̱f̱e̱ṟe̱ṉc̱e̱s̱ ̱p̱a̱ṟṯ.

¶ 2.2 ─     The syntax for the optional preamble part has not yet been
            implemented.

      ─     The syntax for the optional title part is:

                  TITLE:
                  ⇥⋅⋅⋅⋅⋅⌜EXPR⌝.

            The syntax for the optional author part is:

                  AUTHOR:
                  ⇥⋅⋅⋅⋅⋅⌜EXPR⌝.

            For both the syntax for the optional title part, and for the
            syntax for the optional author part, the expression EXPR may
            span multiple (non-empty) lines, each intended one tab.

            Above I used ‘⇥’ followed by dots to indicate a tab, which I
            will continue to do. In this README, I use a tab length of 6.

            Thus the nmm source to this README starts with, modulo line
            breaks and empty lines:

                  TITLE:
                  ⇥⋅⋅⋅⋅⋅The syntax of the No-Markup-Markup (nmm) markup
                  ⇥⋅⋅⋅⋅⋅language

                  AUTHOR:
                  ⇥⋅⋅⋅⋅⋅Anders Lundstedt

¶ 2.3 The non-optional main part is made up of either

      ─     c̱ẖa̱p̱ṯe̱ṟs̱, or of

      ─     s̱e̱c̱ṯi̱o̱ṉs̱, or of

      ─     p̱a̱ṟa̱g̱ṟa̱p̱ẖs̱, or of

      ─     ḇḻo̱c̱ḵs̱.

¶ 2.4 ─     A chapter is made up of sections, or of paragraphs, or of
            blocks.

      ─     A section is made up of paragraphs or of blocks.

      ─     A paragraph is made up of blocks.

