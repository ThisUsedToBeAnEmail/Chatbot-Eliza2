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
    my @orig_words = split / /, $string;
   
    # lets use CPAN this may b slow
    # Decides String::Trigram is wank
    # tbc - compare the tests 

    return join ' ', @orig_words;
}

=head2 postprocess

    $string = postprocess($string);

postprocess() applies simple substitution rules to the reassembly rule.
This is where all the "I"'s and "you"'s are exchanged. postprocess() is
called from within the transform() function.

It uses the attribute C<%post>, created during the parse of the script.

=cut

sub postprocess ($self, $string) {
    my @orig_words = split / /, $string;
   
    # wonders what he was trying to do - perhaps I'm not passing the correct data -_-

    return join ' ', @orig_words;   
}

=head2 _test_quit
    
     $self->_test_quit($user_input) ) { } 

_test_quit detects words like "bye" and "quit" and returns true if it 
finds one of them as the first word in the sentence.

Thes words are listed in the script, under the keyword "quit".

=cut

sub _test_quit ($self, $string) {
    foreach my $quitword ($self->options->data->quit->@*) {
        return 1 if $string =~ m{$quitword}xms;
    }
}

=head2 _debug_memory

    $self->_debug_memory

_debug_memory is a special function hwihc returns the contents of Eliza's memory stack.

=cut

sub _debug_memory ($self) {
    my @memory = $self->options->memory->@*;
    my $string = sprintf("%s item(s) in memory stack:\n", scalar @memory);
    foreach my $msg (@memory) {
        $string .= sprintf("\t\t->%s\n", $msg);
    }
    return $string;
}

sub transform {

}

1; # End of Chatbot::Eliza2
