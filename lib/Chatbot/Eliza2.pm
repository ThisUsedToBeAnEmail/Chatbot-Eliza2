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
		return Chatbot::Eliza::Fields->new();
	}
);

has 'data' => (
	is => 'rw',
	lazy => 1,
	default => 'data.data',
);

has 'build_eliza' => (
	is 	=> 'rw',
	lazy => 1,
	builder => 'build_eliza',
);

sub build_eliza ($self) {
	return Chatbot::Eliza::Build->new($self->fields);
}

1; # End of Chatbot::Eliza2
