#!/ms/dist/perl5/bin/perl5.8

use warnings;
use strict;

use MSDW::Version
  'Class-Accessor'     => '0.31', 
  'Parse-RecDescent'   => '1.963',
  'Google-ProtocolBuffers' => '0.08',
;
use Google::ProtocolBuffers;
use Getopt::Long;
use File::Basename;

sub usage {
    my ($exit_code, $message) = @_;
    if (! defined($exit_code)) {
	$exit_code = 0;
    }
    if ($message) {
	print "$message\n";
    }
    print "Usage: " . basename($0) . " --spec <protocol buffer spec> --directory <target directory> || --help\n";
    exit($exit_code);
}

my %opt;
GetOptions(\%opt, qw(spec=s directory=s help)) || usage(1, "Can't process options");
if (! -f $opt{spec}) {
    die "Can't find protocol buffer spec file '$opt{spec} (--spec)'\n";
}
my $pbname = basename($opt{spec});
$pbname =~ s/\b([a-z])/\u$1/g;
$pbname =~ s/proto/pm/i;
my $target_module = $opt{directory} . "/" . $pbname;
Google::ProtocolBuffers->parsefile($opt{spec}, { generate_code => $target_module } );
