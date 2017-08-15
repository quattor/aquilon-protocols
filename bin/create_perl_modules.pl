#!/ms/dist/perl5/bin/perl5.14

use warnings;
use strict;

use MSDW::Version
  'Class-Accessor'     => '0.34',
  'Parse-RecDescent'   => '1.967009',
  'Google-ProtocolBuffers' => '0.12',
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
    print "Usage: " . basename($0) . " --spec <protocol buffer spec> --directory <target directory> --proto_path <proto path> || --help\n";
    exit($exit_code);
}

my %opt;
GetOptions(\%opt, qw(spec=s directory=s proto_path=s@ help)) || usage(1, "Can't process options");
if ($opt{help}) {
    usage(0, undef);
}
if (! $opt{spec}) {
    die "--spec option is mandatory\n";
}
if (! -f $opt{spec}) {
    die "Can't find protocol buffer spec file '$opt{spec} (--spec)'\n";
}
my $pbname = basename($opt{spec});
$pbname =~ s/\b([a-z])/\u$1/g;
$pbname =~ s/proto/pm/i;
my %options = (
    generate_code => $opt{directory} . "/" . $pbname,
);
if ($opt{proto_path}) {
    $options{include_dir} = $opt{proto_path};
}
Google::ProtocolBuffers->parsefile($opt{spec}, \%options);
