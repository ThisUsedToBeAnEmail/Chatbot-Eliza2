package Chatbot::Eliza::Fields;

use v5.24;

use Moo;

my %fields = (
	name => 'Eliza',
	scriptfile => '',
	debug => 0,
	debug_text => '',
	transform_text => '',
	prompts_on => 1,
	memory_on => 1,
	botprompt => '',
	userprompt => '',
	myrand => sub { my $N = defined $_[0] ? $_[0] : 1; rand($N); },
	keyranks => undef,
	decomplist => undef,
	reasmblist => undef,
	reasmblist_for_memory => undef,
	pre => undef,
	post => undef,
	synon => undef,
	initial => undef,
	final => undef,
	quit => undef,
	max_memory_size => 5,
	likelihood_of_using_memory => 1,
	memory => undef,
);

while ( my( $key, $value ) = each %fields ) {
	has $key => (
		is => 'rw',
		lazy => 1,
		default => $value,
	);
}

1; # End of Chatbot::Eliza2
