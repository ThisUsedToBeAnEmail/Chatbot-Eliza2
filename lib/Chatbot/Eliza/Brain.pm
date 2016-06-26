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
    my @converted_words;
    foreach my $word ( @orig_words ) {
        push @converted_words, $word =~ s{[?!,]}{.}g;
    }

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

=head2 transform

    $reply = $chatterbot->transform( $string, $use_memory );

transform applies transformation rules to the user input string.
It invokes preprocess(), does transformations, then invokes postprocess.
It returns the transformed output string, called C<$reasmb>

The algorithm embedded in the transfrom method has three main parts:

=item 1

Searn the input string for a keyword.

=item 2

If we find a keyword, use the list of demoposition rules for that keyword. and pattern-match
the input string against each rule.

=item 3

If the input string matches any of the decomposition rules, then randomly select one of the 
reassembly rules for that decomposition rule, and use it to construct the reply.

transform takes two parameters. The first is the string we want to transform. The second
is a flag which indicates where this string came from. If the flag is set, then the string
has been pulled from memory, and we should use reassemble rules appropriate for that. If
the flag is not set then the string is the most recent user input, and we can use the ordinary reassembly rules.

The memory flag is only set when the transform function is called recursively. The mechanism 
for setting this parameter is embedded in he transform method itself. If the flag is set inappropriately, it is ignored.

=cut

sub transform ($self, $string, $use_memory ) {
	# Initialize the debugging text buffer.
	$self->options->debug_text('');

	$self->options->debug_text(sprintf "\t[Pulling string \"$string\" from memory.]\n")
		if $use_memory;

	my ($i, @string_parts, $string_part, $rank, $goto, $reasmb, $keyword, 
		$decomp, $this_decomp, $reasmbkey, @these_reasmbs,
		@decomp_matches, $synonyms, $synonym_index);

	# Default to a really low rank. 
	$rank   = -2;
	$reasmb = "";
	$goto   = "";

	# First run the string through the preprocessor.  
	$string = $self->preprocess( $string );

	# Convert punctuation to periods.  We will assume that commas
	# and certain conjunctions separate distinct thoughts/sentences.  
	$string =~ s/[?!,]/./g;
	$string =~ s/but/./g;   #   Yikes!  This is English-specific. 

	# Split the string by periods into an array
	@string_parts = split /\./, $string ;

	# Examine each part of the input string in turn.
	STRING_PARTS: foreach $string_part (@string_parts) {

	# Run through the whole list of keywords.  
	KEYWORD: foreach $keyword (keys $self->options->data->decomp->%*) {

		# Check to see if the input string contains a keyword
		# which outranks any we have found previously
		# (On first loop, rank is set to -2.)
		if ( ($string_part =~ /\b$keyword\b/i or $keyword eq $goto) 
		     and 
		     $rank < $self->options->data->key->{$keyword}  
		   ) 
		{
			# If we find one, then set $rank to equal 
			# the rank of that keyword. 
			$rank = $self->options->data->key->{$keyword};

			$self->options->debug_text($self->options->debug_text . sprintf "\t$rank> $keyword");

			# Now let's check all the decomposition rules for that keyword. 
			DECOMP: foreach $decomp ($self->options->data->decomp->{$keyword}->@*) {

				# Change '*' to '\b(.*)\b' in this decomposition rule,
				# so we can use it for regular expressions.  Later, 
				# we will want to isolate individual matches to each wildcard. 
				($this_decomp = $decomp) =~ s/\s*\*\s*/\\b\(\.\*\)\\b/g;

				# If this docomposition rule contains a word which begins with '@', 
				# then the script also contained some synonyms for that word.  
				# Find them all using %synon and generate a regular expression 
				# containing all of them. 
				if ($this_decomp =~ /\@/ ) {
					($synonym_index = $this_decomp) =~ s/.*\@(\w*).*/$1/i ;
					$synonyms = join ('|', $self->options->data->synon->{$synonym_index}->@* );
					$this_decomp =~ s/(.*)\@$synonym_index(.*)/$1($synonym_index\|$synonyms)$2/g;
				}

				$self->options->debug_text($self->options->debug_text .  sprintf "\n\t\t: $decomp");

				# Using the regular expression we just generated, 
				# match against the input string.  Use empty "()"'s to 
				# eliminate warnings about uninitialized variables. 
				if ($string_part =~ /$this_decomp()()()()()()()()()()/i) {

					# If this decomp rule matched the string, 
					# then create an array, so that we can refer to matches
					# to individual wildcards.  Use '0' as a placeholder
					# (we don't want to refer to any "zeroth" wildcard).
					@decomp_matches = ("0", $1, $2, $3, $4, $5, $6, $7, $8, $9); 
					$self->options->debug_text(
                        $self->options->debug_text . sprintf " : @decomp_matches\n"
                    );

					# Using the keyword and the decomposition rule,
					# reconstruct a key for the list of reassamble rules.
					$reasmbkey = join ($;,$keyword,$decomp);
					# Get the list of possible reassembly rules for this key. 
	    			# Get the list of possible reassembly rules for this key. 
					#
					if (defined $use_memory and $#{ $self->options->data->reasmb_for_memory->{$reasmbkey} } >= 0) {

						# If this transform function was invoked with the memory flag, 
						# and there are in fact reassembly rules which are appropriate
						# for pulling out of memory, then include them.  
						@these_reasmbs = $self->options->data->reasmb_for_memory->{$reasmbkey}->@*;


					} else {

						# Otherwise, just use the plain reassembly rules.
						# (This is what normally happens.)
						@these_reasmbs = $self->options->data->reasmb->{$reasmbkey}->@*;
					}

					# Pick out a reassembly rule at random. 
                    $reasmb = $these_reasmbs[ $self->options->myrand( scalar @these_reasmbs ) ];
					$self->options->debug_text($self->options->debug_text . sprintf "\t\t-->  $reasmb\n");

					# If the reassembly rule we picked contains the word "goto",
					# then we start over with a new keyword.  Set $keyword to equal
					# that word, and start the whole loop over. 
					if ($reasmb =~ m/^goto\s(\w*).*/i) {
						$self->options->debug_text($self->options->debug_text . sprintf "\$1 = $1\n");
						$goto = $keyword = $1;
						$rank = -2;
						redo KEYWORD;
					}

					# Otherwise, using the matches to wildcards which we stored above,
					# insert words from the input string back into the reassembly rule. 
					# [THANKS to Gidon Wise for submitting a bugfix here]
					for ($i=1; $i <= $#decomp_matches; $i++) {
						$decomp_matches[$i] = $self->postprocess( $decomp_matches[$i] );
						$decomp_matches[$i] =~ s/([,;?!]|\.*)$//;
						$reasmb =~ s/\($i\)/$decomp_matches[$i]/g;
					}

					# Move on to the next keyword.  If no other keywords match,
					# then we'll end up actually using the $reasmb string 
					# we just generated above.
					next KEYWORD ;

				}  # End if ($string_part =~ /$this_decomp/i) 

				$self->options->debug_text($self->options->debug_text . sprintf "\n");

			} # End DECOMP: foreach $decomp (@{ $self->{decomplist}->{$keyword} }) 

		} # End if ( ($string_part =~ /\b$keyword\b/i or $keyword eq $goto) 

	} # End KEYWORD: foreach $keyword (keys %{ $self->{decomplist})
	
	} # End STRING_PARTS: foreach $string_part (@string_parts) {

	if ($reasmb eq "") {

		# If all else fails, call this method recursively 
		# and make sure that it has something to parse. 
		# Use a string from memory if anything is available. 
		#
		# $self-likelihood_of_using_memory should be some number
		# between 1 and 0;  it defaults to 1. 
		#
		if (
			$#{ $self->options->memory } >= 0 
			and 
			&{$self->options->myrand}(1) >= 1 - $self->options->likelihood_of_using_memory
		) {

			$reasmb =  $self->transform( shift $self->options->memory->@*, "use memory" );

		} else {
			$reasmb =  $self->transform("xnone", "");
		}

	} elsif ($self->options->memory_on) {   

		# If memory is switched on, then we handle memory. 

		# Now that we have successfully transformed this string, 
		# push it onto the end of the memory stack... unless, of course,
		# that's where we got it from in the first place, or if the rank
		# is not the kind we remember.
		#
		if (
				$#{ $self->options->data->reasmb_for_memory->{$reasmbkey} } >= 0
				and
				not defined $use_memory
		) {

			push  $self->options->memory->@*, $string;
		}

		# Shift out the least-recent item from the bottom 
		# of the memory stack if the stack exceeds the max size. 
		shift $self->options->memory->@* if $#{ $self->options->memory } >= $self->options->max_memory_size;

		$self->options->debug_text($self->options->debug_text 
			. sprintf("\t%d item(s) in memory.\n", $#{ $self->options->memory } + 1 ) ) ;

	} # End if ($reasmb eq "")

	$reasmb =~ tr/ / /s;       # Eliminate any duplicate space characters. 
	$reasmb =~ s/[ ][?]$/?/;   # Eliminate any spaces before the question mark. 

	# Save the return string so that forgetful calling programs
	# can ask the bot what the last reply was. 
	$self->options->transform_text($reasmb);

	return $reasmb;
}

1; # End of Chatbot::Eliza2
