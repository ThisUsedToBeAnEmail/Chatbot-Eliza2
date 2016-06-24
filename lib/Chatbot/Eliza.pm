package Chatbot::Eliza;

use v5.24;
use strict;
use warnings;

use Moo;

use experimental qw[
	signatures
	lexical_subs
];

has 'options' => (
	is => 'rw',
	lazy => 1,
	default => sub {
		return Chatbot::Eliza::Option->new();
	}
);

has 'eliza' => (
	is 	=> 'rw',
	lazy => 1,
	default => sub { 
		Chatbot::Eliza::Brain->new(options => $self->options);	
	}
);

sub command_interface {

}

sub interact {

}

1; # End of Chatbot::Eliza2
