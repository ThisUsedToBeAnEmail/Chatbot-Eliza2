package Chatbot::Eliza::Option;

use v5.24;

use Moo;
use Chatbot::Eliza::ScriptParser;

use experimental qw[
    signatures
];

my %fields = (
    name => 'Eliza',
    script_file => '',
    debug => 0,
    debug_text => '',
    transform_text => '',
    prompts_on => 1,
    memory_on => 1,
    botprompt => '',
    userprompt => '',
    myrand => sub { my $N = defined $_[0] ? $_[0] : 1; rand($N); },
    max_memory_size => 5,
    likelihood_of_using_memory => 1,
    memory => sub { [ ] },
);

while ( my( $key, $value ) = each %fields ) {
    has $key => (
        is => 'rw',
        lazy => 1,
        default => $value,
    );
}

has 'data' => (
    is => 'ro',
    lazy => 1,
    builder => 'build_data'
);

sub build_data ($self) {
    my $parser = Chatbot::Eliza::ScriptParser->new(script_file => $self->script_file);
    $parser->parse_script_data;
    return $parser;
}

1; # End of Chatbot::Eliza2
