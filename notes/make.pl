#Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
#Dialogue: 0,0:00:07.52,0:00:08.68,Snomed Code,,0000,0000,0000,,Flow History

use strict;
use warnings;

use DateTime;

sub makeLine {
    my ($dt, $code, $desc) = @_;

    my $enddt = $dt->clone();
    $enddt = $enddt->add(seconds => 2);

    return "Dialogue: " . join(",",
        0, #layer
        formatDateTime($dt),
        formatDateTime($enddt),
        "Snomed Code", # Style
        "", # Name
        "0000", # MarginL
        "0000", # MarginR
        "0000", # MarginV
        "", # Effect
        "$code - $desc");
}

sub formatDateTime {
    my ($dt) = @_;
    return sprintf("%02d:%02d:%02d.00", $dt->hour, $dt->minute, $dt->second);
}

sub parse {
    my ($line) = @_;
    if ($line =~ m{(\d+):(\d+):(\d+),[ ]*(\d+),([^,\r]+)}) {
        my $dt = DateTime->new(
            year => 0,
            hour => $1,
            minute => $2,
            second => $3,
        );
        return ($dt, $4, $5);
    } else {
        return ();
    }
}

foreach my $line (<STDIN>) {
    chomp($line);
    my @result = parse($line);
    if (@result) {
        print makeLine(@result)."\n";
    } else {
        print STDERR "$line\n";
    }
}

