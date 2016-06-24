package Chatbot::Eliza::ScriptParser;

use v5.24;

use Moo;

has 'script_file' => (
	is => 'ro',
	default => q{},
)

has [ qw(entry_type entry key value this_key this_de_comp) ] => (
	id => 'ro',
	default => q{},
);

sub parse_script_data ($self, $script_file) {
	my @script_lines = $self->_open_script_file($script_file);
	
	# Examine each line of the script data
	for my $line (@scriptlines) {
		
		# Skip comments and lines with only whitespace
		next if $line =~ /^\s*#|\s*$/;
	}
}

sub _open_script_file ($self, $script_file) {	
	if ($script_file) {
		# If we have an external script file, open it
		open (my $fh, "<", $scriptfile)
			or die "Could not read from file $scriptfile : $!\n";
		
		@script_lines = <$fh>;
		close ($fh);

		$self->script_file($scriptfile);
	}
	else {
		# Otherwise, read in the data from the bottom of this file.
		# This data might be read several times, so we save the offset pointer
		my $where = tell(DATA);
		@script_lines = <DATA>;
		
		# and reset it when we're done.
		seek(DATA, $where, 0);
		$self->script_file('none');
	}
}

1; # End of Chatbot::Eliza2
