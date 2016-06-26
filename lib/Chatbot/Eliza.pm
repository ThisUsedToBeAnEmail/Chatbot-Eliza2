package Chatbot::Eliza;

use v5.24;
use strict;
use warnings;

use Moo;

use experimental qw[
    signatures
];

my @user_options = qw(name script_file debug prompts_on memory_on);
foreach my $field (@user_options) {
    has $field => (
        is => 'rw',
        default => undef,
    );
}

has 'brain' => (
    is => 'rw',
    lazy => 1,
    builder => '_build_brain',
);

sub _build_brain ($self) {
    my $options = Chatbot::Eliza::Option->new();
    foreach my $field (@user_options) {
        if (my $val = $self->$field) {
            $options->$field($val);
        }
    }
    return Chatbot::Eliza::Brain->new(options => $options);
}

sub command_interface ($self) {
    my ($reply, $previous_user_input, $user_input) = "";
    
    my $options = $self->brain->options;
    $options->botprompt($self->name . ":\t");
    $options->userprompt("you:\t");

    # Seed the rand number generator.
    srand( time() ^ ($$ + ($$ << 15)) );

    # print the Eliza prompt
    print $options->botprompt if $options->prompts_on;

    # print an initial greeting
    print "$self->{initial}->[ $options->myrand( scalar $options->initial ) ]\n";

    while (1) {

        print $options->userprompt if $options->prompts_on;
    
        $previous_user_input = $user_input;
        chomp( $user_input = <STDIN> );

        # If the user wants to quit,
        if ($self->brain->_testquit($user_input) ) {
            $reply = $options->data->final->[ $options->myrand(scalar $options->data->final->@*)];
            print $self->botprompt if $self->prompts_on;
            print "$reply\n";
            last;
        }

        # If the user enters the work "debug",
        # the toggle on/off Eliza's debug output.
        if ($user_input eq "debug") {
            $options->debug( ! $options->debug );
            $user_input = $previous_user_input;
        }

        # If the user enters the word "memory"
        # then use the _debug_memory method to dump out
        # the current contents of Eliza's memory
        if ($user_input eq "memory" || $user_input eq "debug memory") {
            print $self->brain->_debug_memory();
            redo;
        }

        # If the user enters the word "debug that" 
        # the dump out the debugging of the most recent 
        # call to transform
        if ($user_input eq "debug that") {
            print $options->debug_text;
            redo;
        }

        # Invoke the transform method to generate a reply
        $reply = $self->transform($user_input, '');

        # Print out the debugging text if debugging is set to on.
        # This variable should have been set by the transform method
        print $options->debug_text if $self->debug;

        # print the actual reply
        print $options->botprompt if $options->prompts_on;
        print "$reply\n";
   }
}

sub instance ($self, $user_input) {
    my $reply;
    my $brain = $self->brain;
    if ($brain->_test_quit($user_input)) {
        my @final = $brain->options->data->final->@*;
        $reply = $final[ $brain->options->myrand( scalar @final ) ]; 
    }
    else {
        $reply = $brain->transform($user_input, '');
    }
    return $reply;
}

1; # End of Chatbot::Eliza2
