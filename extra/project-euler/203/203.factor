! Copyright (c) 2008 Eric Mertens.
! See https://factorcode.org/license.txt for BSD license.
USING: kernel math math.primes.factors math.vectors sequences sets
project-euler.common ;
IN: project-euler.203

! https://projecteuler.net/index.php?section=problems&id=203

! DESCRIPTION
! -----------

! The binomial coefficients nCk can be arranged in triangular form, Pascal's
! triangle, like this:

!                   1
!                 1   1
!               1   2   1
!             1   3   3   1
!           1   4   6   4   1
!         1   5  10  10   5   1
!       1   6  15  20  15   6   1
!     1   7  21  35  35  21   7   1
!               .........

! It can be seen that the first eight rows of Pascal's triangle contain twelve
! distinct numbers: 1, 2, 3, 4, 5, 6, 7, 10, 15, 20, 21 and 35.

! A positive integer n is called squarefree if no square of a prime divides n.
! Of the twelve distinct numbers in the first eight rows of Pascal's triangle,
! all except 4 and 20 are squarefree. The sum of the distinct squarefree numbers
! in the first eight rows is 105.

! Find the sum of the distinct squarefree numbers in the first 51 rows of
! Pascal's triangle.


! SOLUTION
! --------

<PRIVATE

: iterate ( n initial quot -- results )
    swapd '[ @ dup ] replicate nip ; inline

: (generate) ( seq -- seq )
    [ 0 prefix ] [ 0 suffix ] bi v+ ;

: generate ( n -- seq )
    1 - { 1 } [ (generate) ] iterate union-all ;

: squarefree ( n -- ? )
    factors all-unique? ;

: solve ( n -- n )
    generate [ squarefree ] filter sum ;

PRIVATE>

: euler203 ( -- n )
    51 solve ;

! [ euler203 ] 100 ave-time
! 12 ms ave run time - 1.6 SD (100 trials)

SOLUTION: euler203
