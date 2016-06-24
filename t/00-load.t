#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Chatbot::Eliza2' ) || print "Bail out!\n";
}

diag( "Testing Chatbot::Eliza2 $Chatbot::Eliza2::VERSION, Perl $], $^X" );
