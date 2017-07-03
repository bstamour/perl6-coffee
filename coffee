#!/usr/bin/env perl6
#-------------------------------------------------------------------------------
#
# AMAZING COFFEE GROUNDS CALCULATOR
#
# Helps you make the perfect pot every time.
#
#-------------------------------------------------------------------------------

use v6;

# Coffee brews are functions on the number of servings. According to
# US customs, a single serving of coffee in a cup is 6 oz, but the
# typical mug holds two servings. So if you want to make 3 cups of
# coffee, put in 6 as the serving number. The result of each function
# is the number of tablespoons of grounds to use.
my %brews = (
  # Maxwell House recommends the following: For one serving (6
  # oz), use 1 tablespoon of grounds.  For 10 servings, use 8
  # tbsp. Therefore by interpolation, we arive at the below
  # linear function.
  maxwell-house => -> $x {
    $x < 1 ?? $x !! 7 / 9 * $x + 2 / 9
  },
  # Folgers uses (according to their online calculator) a 1-to-1
  # mapping between servings and tablespoons of grounds. Nice
  # and easy.
  folgers => -> $x {
    $x
  },
  # Also given on the folgers website is their recommendation for
  # strong coffee.
  folgers-strong => -> $x {
    2 * $x
  },
  # 10 grams for one serving. A tablespoon is approximately 15 grams.
  starbucks-yukon => -> $x {
    10 / 15 * $x
  },
  # From lifehacker (of all places). Maybe try this out with some
  # regular old coffee and see how it tastes.
  generic => -> $x {
    2 * $x
  }
);

# Some handy subtypes so that we don't have to do any manual checking
# for parameter correctness.
subset Positive of Numeric where * > 0;
subset Brand    of Any     where { %brews{$_}:exists };
subset Strength of Str     where * eq 'strong' | 'weak' | 'normal' | 'raw';

sub MAIN(Positive $servings, Brand :$brand = 'maxwell-house',
	 Strength :$strength = 'normal') {
  my $amount = %brews{$brand}($servings);

  $amount = do given $strength {
    when 'strong' { ceiling $amount }
    when 'weak'   { floor $amount }
    when 'normal' { (round(4 * $amount) / 4) }
    default       { $amount }
  }

  say "$amount tbsp";
}

sub USAGE {
  say "Usage:";
  say "  coffee [--brand=brand] [--strength=(weak|strong|normal)] <serving>";
  say '';
  say "Computes the optimal amount of coffee grounds for brewing the number ";
  say "of servings requested. Brand defaults to maxwell-house. Strength ";
  say "defaults to strong. Serving must be a positive real number.";
  say '';
  say "Supported coffee brands:";
  for %brews.kv -> $k, $ { say $k }
}
