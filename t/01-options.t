#!perl -T

use strict;
use warnings;
use Test::More;
use feature 'say';

use experimental qw[
	signatures
];

BEGIN {
	use_ok( 'Chatbot::Eliza::Option' ) || print "Bail out!\n";
}

subtest 'attributes exist' => sub {
	test_da_attributes({
		att => 'name',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'script_file',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'debug',
		value => '1'
	});
	test_da_attributes({
		att => 'debug_text',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'transform_text',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'prompts_on',
		value => '1'
	});
	test_da_attributes({
		att => 'memory_on',
		value => '1'
	});
	test_da_attributes({
		att => 'botprompt',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'userprompt',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'myrand',
		value => '0.1'
	});
	test_da_attributes({
		att => 'keyranks',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'decomplist',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'reasmblist',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'reasmblist_for_memory',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'pre',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'post',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'synon',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'initial',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'final',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'quit',
		value => 'Lnation'
	});
	test_da_attributes({
		att => 'max_memory_size',
		value => '10'
	});
	test_da_attributes({
		att => 'likelihood_of_using_memory',
		value => '1'
	});
	test_da_attributes({
		att => 'memory',
		value => 'Lnation'
	});
};

done_testing();

sub test_da_attributes($args) {
	my $fields = Chatbot::Eliza::Option->new();
	my $att = $args->{att};
	
	# set the attribute
	ok($fields->$att($args->{value}));
	# check its value
	is($fields->$att, $args->{value}, "$att set with correct value");
}
