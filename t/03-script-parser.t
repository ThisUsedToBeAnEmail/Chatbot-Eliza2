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
	update_options({
		options => {
			name => 'Lnation'
		},
		att => 'name',
		value => 'Lnation'
	});
};

done_testing();

sub update_options ($args) {
	my $parser = Chatbot::Eliza::ScriptParser->new();
	my $data = $parser->parse_script_data;
	# check its value
}
