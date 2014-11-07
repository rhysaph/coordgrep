#!/usr/bin/perl -w
use strict;

# Before using, may need
#  setenv PERL5LIB /usr/local/lib/perl5/site_perl/
#
#
# test with eg
# ./coordgrep.pl 20 00 00 54 00 00 1827+00_ha-r_mosaic.fit
# or
# ./coordgrep.pl 18 55 00 13 00 00 1850+14_ha-r_mosaic.fit
#

#use Astro::FITS::CFITSIO;
#use Astro::FITS::CFITSIO qw( :longnames );

#use Astro::WCS::LibWCS;                  # export nothing by default
use Astro::WCS::LibWCS qw( :functions ); # export function names
use Astro::WCS::LibWCS qw( :constants ); # export constant names


if ($#ARGV < 6){
print "program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

#print "ARGV[1] is ",$ARGV[0],"\n";

# Check RA hours input number formats
if ($ARGV[0] < 0 || $ARGV[0] > 24){
print "Check RA hours. Program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

# Check RA minutes input number formats
if ($ARGV[1] < 0 || $ARGV[1] > 60){
print "Check RA minutes. Program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

# Check RA seconds input number formats
if ($ARGV[2] < 0 || $ARGV[2] > 60){
print "Check RA seconds. Program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

# Check Dec degrees input number formats
if ($ARGV[3] < -90 || $ARGV[3] > 90){
print "Check Dec degrees. Program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

# Check Dec minutes input number formats
if ($ARGV[4] < 0 || $ARGV[4] > 60){
print "Check Dec minutes. Program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

# Check Dec seconds input number formats
if ($ARGV[5] < 0 || $ARGV[5] > 60){
print "Check Dec seconds. Program usage\n";
print "coordgrep  HH mm ss\.s dd mm ss\.s \<regex\>\n";
exit;
}

print "\nInput coords appear to be valid\n\n";

#print "usage: ./filelooper.pl hh mm ss.s dd mm ss filenames \n";

my @infiles = ();

my $fname=" ";
my $i = 0;
my $nfiles = $#ARGV +1 -6;

#print "nfiles is $nfiles \n\n";

foreach $i (0..$nfiles-1){
$infiles[$i] = $ARGV[$i+6];
}

print "Checking the following files for input coordinates \n";
map { print "$_\n" } @infiles;
print "\n";

#my $item = 0;
#print "contents of array using foreach \n";

my $filename = " ";
my $header_length=0;
my $bytes_before_data=0;

#my $rastr = " ";
my $wcs = " ";
my $fitsheader = " ";

# Concatenate ARGV strings to make ra string
my $rastr = $ARGV[0]." ".$ARGV[1]." ".$ARGV[2];

# Concatenate ARGV strings to make dec string
my $decstr = $ARGV[3]." ".$ARGV[4]." ".$ARGV[5];

#print "ra string is $rastr and dec string is $decstr\n";

# Convert ra and dec strings to angles
my $ra = str2ra($rastr);
my $dec = str2dec($decstr);

#print "ra angle is $ra and dec angle is $dec\n";

foreach $i (0..$nfiles-1){
    $filename = $infiles[$i];
#    print "opening $filename \n";

    $fitsheader = " ";
    $fitsheader = fitsrhead($filename, $header_length, $bytes_before_data);

# got header?
#    print "got header \n";

    $wcs=" ";
    $wcs = wcsinitn ($fitsheader, 0);
 
#    print "Got wcs \n";
    
    my $retval=0;
    my $xpixpos = 0;
    my $ypixpos = 0;
    my $offscl=0;

    $retval=wcs2pix($wcs,$ra,$dec,$xpixpos,$ypixpos,$offscl);

# offscl should be zero if we're within the bounds of the image
#    print "offscl is ",$offscl,"\n";

    if ($offscl == 0) {
	print "Coordinates $rastr $decstr are in $filename\n";
    }



}

print "\n";
print "\n";
exit;



exit;
