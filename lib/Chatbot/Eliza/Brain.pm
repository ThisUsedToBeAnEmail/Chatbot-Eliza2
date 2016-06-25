package Chatbot::Eliza::Brain;

use v5.24;

use Moo;

use experimental qw[
    signatures
];

has 'options' => (
	is => 'rw',
	lazy => 1,
);

=head2 preprocess

    $string = preprocess($string);

preprocess() applies simple substitution rules to the input string.
Mostly this is to catch varieties in spelling, misspellings, contractions
and the like.

preprocess() is called from within the transform() method.
It is applied to user-input text, BEFORE any processing,
and before a reassebly statement has been selected.

It uses the array C<%pre>, which is created during the parse of the script.

=cut

sub preprocess ($self, $string) {
    my @words = split / /, $string;
   
    # lets use CPAN
    my $data = $self->options->data;
    my @unique_words = $data->unique_words;
    use Data::Dumper;
    warn Dumper @unique_words;
    
    return join ' ', @words;
}

sub postprocess {

}

sub _testquit {

}

sub _debug_memory {

}

sub transform {

}

1; # End of Chatbot::Eliza2
