package Chatbot::Eliza;

use v5.24;
use strict;
use warnings;

use Moo;

use experimental qw[
	signatures
	lexical_subs
];

my @user_options = qw(name scriptfile debug prompts_on memory_on myrand);
foreach my $field (@user_options) {
	has $field => (
		is => 'rw',
		default => undef,
	);
}

has 'options' => (
	is => 'rw',
	lazy => 1,
	builder => '_build_options',
	default => sub {
		return Chatbot::Eliza::Option->new();
	}
);

sub _build_options ($self) {
	my $options = Chatbot::Eliza::Option->new();
	foreach my $field (@user_options) {
		if (my $val = $self->$field) {
			$options->$field($val);
		}
	}
	return $options;
}

has 'eliza' => (
	is 	=> 'rw',
	lazy => 1,
	builder => '_build_eliza'
);

sub _build_eliza ($self) {
	return Chatbot::Eliza::Brain->new(options => $self->options);
}

sub command_interface {

}

sub interact {

}

1; # End of Chatbot::Eliza2
