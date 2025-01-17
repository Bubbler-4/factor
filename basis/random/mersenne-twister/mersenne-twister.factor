! Copyright (C) 2005, 2008 Doug Coleman.
! See https://factorcode.org/license.txt for BSD license.
! mersenne twister based on
! https://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/MT2002/CODES/mt19937ar.c
USING: accessors alien.c-types alien.data fry init kernel math
math.bitwise namespaces random sequences sequences.private
specialized-arrays system ;
SPECIALIZED-ARRAY: uint
IN: random.mersenne-twister

<PRIVATE

TUPLE: mersenne-twister { seq uint-array } { i fixnum } ;

CONSTANT: n 624
CONSTANT: m 397
CONSTANT: a uint-array{ 0 0x9908b0df }

: mt-step ( k+m k+1 k seq -- )
    [
        [ nth-unsafe ] curry tri@
        [ 31 bits ] [ 31 mask-bit ] bi* bitor
        [ 2/ ] [ 1 bitand a nth ] bi bitxor bitxor
    ] 2keep set-nth-unsafe ; inline

: mt-steps ( k+m k+1 k n seq -- )
    [ mt-step ] curry [ 3keep [ 1 + ] tri@ ] curry times 3drop ; inline

: mt-generate ( mt -- )
    [
        seq>>
        [ [ m 1 0 n m - ] dip mt-steps ]
        [ [ 0 n m - 1 + n m - m 1 - ] dip mt-steps ]
        [ [ m 1 - 0 n 1 - ] dip mt-step ]
        tri
    ] [ 0 >>i drop ] bi ; inline

: init-mt-formula ( i seq -- f(seq[i]) )
    dupd nth dup -30 shift bitxor 1812433253 * + 1 w+ ; inline

: init-mt-rest ( seq -- )
    n 1 - swap '[
        _ [ init-mt-formula ] [ [ 1 + ] dip set-nth ] 2bi
    ] each-integer ; inline

: init-mt-seq ( seed -- seq )
    32 bits n uint <c-array>
    [ set-first ] [ init-mt-rest ] [ ] tri ; inline

: mt-temper ( y -- yt )
    dup -11 shift bitxor
    dup 7 shift 0x9d2c5680 bitand bitxor
    dup 15 shift 0xefc60000 bitand bitxor
    dup -18 shift bitxor ; inline

: next-index  ( mt -- i )
    dup i>> dup n < [ nip ] [ drop mt-generate 0 ] if ; inline

PRIVATE>

: <mersenne-twister> ( seed -- obj )
    init-mt-seq 0 mersenne-twister boa
    dup mt-generate ;

M: mersenne-twister seed-random
    init-mt-seq >>seq
    dup mt-generate ;

M: mersenne-twister random-32*
    [ next-index ]
    [ seq>> nth-unsafe mt-temper ]
    [ [ 1 + ] change-i drop ] tri ;

: default-mersenne-twister ( -- mersenne-twister )
    nano-count <mersenne-twister> ;

STARTUP-HOOK: [
    default-mersenne-twister random-generator set-global
]
