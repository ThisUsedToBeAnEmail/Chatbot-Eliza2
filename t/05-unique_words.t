#!perl -T

use strict;
use warnings;
use Test::More;
use feature 'say';

use experimental qw[
	signatures
];

BEGIN {
	use_ok( 'Chatbot::Eliza::ScriptParser' ) || print "Bail out!\n";
}

subtest 'attributes exist' => sub {
	unique_words({
		att => 'name',
		value => 'Lnation'
	});
};

done_testing();

sub unique_words ($args) {
	my $parser = Chatbot::Eliza::ScriptParser->new();
	my @data = $parser->_unique_words("hello hello world's blah1");
	use Data::Dumper;
    
    warn Dumper $parser->unique_words; 
    # check its value
}
