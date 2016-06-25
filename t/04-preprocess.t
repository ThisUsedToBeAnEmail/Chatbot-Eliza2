#!perl

use strict;
use warnings;
use Chatbot::Eliza;
use Test::More 0.88;
use feature 'say';

BEGIN {
	use_ok( 'Chatbot::Eliza::Option' ) || print "Bail out!\n";
    use_ok( 'Chatbot::Eliza::Brain' ) || print "Bail out!\n";
}
# doesn't store memory so it's actually pretty useless

subtest 'say goodbye in multiple ways' => sub {
	goodbye_eliza({
		text => 'hello world',			
	    expected => 'hello world',			
    });
	goodbye_eliza({
		text => 'hello recolect',			
	    expected => 'hello recollect',			
    });
	goodbye_eliza({
		text => 'eliza goodbye',			
	    expected => 'eliza goodbye',			
    });
	goodbye_eliza({
		text => 'done certainle',			
	    expected => 'done certainly',			
    });
	goodbye_eliza({
		text => 'maybr',			
	    expected => 'maybe',			
    });
	goodbye_eliza({
		text => 'machynes',
        expected => 'machines',			
	});
};

done_testing();

sub goodbye_eliza {
	my $args = shift;

    my $options = Chatbot::Eliza::Option->new();
    my $eliza = Chatbot::Eliza::Brain->new(options => $options);
	my $reply = $eliza->preprocess($args->{text});
	# reply will always have a value
	ok($reply);
	is($reply, $args->{expected}, "we went through preprocess - $reply");
};

1;
