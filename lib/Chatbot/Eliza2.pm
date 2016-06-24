package Chatbot::Eliza;

use v5.24;
use strict;
use warnings;

use Moo;

use experimental qw[
	signatures
	lexical_subs
];

## Soon I wont need to be setting all of these
has 'fields' => (
	is => 'rw',
	lazy => 1,
	default => sub {
		return (
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
	}
);

has 'build_eliza' => (
	is 	=> 'rw',
	lazy => 1,
	builder => 'build_eliza',
);

sub build_eliza ($self) {
	return Chatbot::Eliza::Build->new($self->bot_args);
}

1; # End of Chatbot::Eliza2
