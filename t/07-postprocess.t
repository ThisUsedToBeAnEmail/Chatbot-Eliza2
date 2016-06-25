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

subtest 'test_postprocess' => sub {
	test_postprocess({
		text => 'hello world',			
	    expected => 'hello world',			
    });
	test_postprocess({
		text => 'hello recolect',			
	    expected => 'hello recollect',			
    });
	test_postprocess({
		text => 'eliza goodbye',			
	    expected => 'eliza goodbye',			
    });
	test_postprocess({
		text => 'done certainle',			
	    expected => 'done certainly',			
    });
	test_postprocess({
		text => 'maybr',			
	    expected => 'maybe',			
    });
	test_postprocess({
		text => 'machynes',
        expected => 'machines',			
	});
};

done_testing();

sub test_postprocess {
	my $args = shift;

    my $options = Chatbot::Eliza::Option->new();
    my $eliza = Chatbot::Eliza::Brain->new(options => $options);
	ok(my $reply = $eliza->postprocess($args->{text}));
	# reply will always have a value
	is($reply, $args->{expected}, "we went through preprocess - $reply");
};

1;
