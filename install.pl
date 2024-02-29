#! /usr/bin/perl

# install.pl -- Main installation script for the LiturgiScript package
# Copyright (C) 2024  Sophia Elizabeth Shapira
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

use strict;
use Cwd 'abs_path', 'getcwd';
use File::Basename;

my $perlloc;
my $thiscrip;
my $scrip_dir;
my $scrip_bas;
my $homeworld;
my $nexblank = 0;
my $destiny;
my $suc_dir;

$destiny = dirname($0);
$suc_dir = chdir($destiny);
if ( $suc_dir < 0.5 )
{
  my $lc_dn;
  
  $lc_dn = "\nFATAL ERROR: Could Not Change Directory:\n";
  $lc_dn .= "  From: " . getcwd() . " :\n";
  $lc_dn .= "    To: " . $destiny . " :\n";
  $lc_dn .= "\n";
  
  die $lc_dn;
}

$homeworld = $ENV{'HOME'};
if ( $homeworld eq '' )
{
  my $lc_a;
  $lc_a = `( cd && pwd )`;
  chomp($lc_a);
  $homeworld = $lc_a;
}

$perlloc = `which perl`; chomp($perlloc);

$thiscrip = abs_path($0);
$scrip_dir = abs_path(dirname($thiscrip));
$scrip_bas = basename($thiscrip);

print ": " . $scrip_dir . " : " . $scrip_bas . " :\n";
print ": " . $homeworld . " :\n";
system('pwd');

sub prestall {
  my $lc_dest;
  
  $lc_dest = $homeworld . '/bin/' . $_[0];
  system('rm','-rf',$lc_dest);
  if ( $nexblank > 0.5 )
  {
    $nexblank = int($nexblank - 0.8);
    return;
  }
  
  open STORK, ("| cat > " . $lc_dest);
  
  print STORK "#! " . $perlloc . "\n";
  print STORK "\nexec('perl','-I";
  print STORK $scrip_dir . "/plmod'";
  print STORK ",'" . $scrip_dir . "/cmd/" . $_[1] . ".pl'";
  print STORK ",'" . $scrip_dir . "'";
  print STORK ',@ARGV';
  #print STORK "\n\n\n";
  print STORK ");\n";
  
  close STORK;
  system('chmod','755',$lc_dest);
  
  return;
  system("echo","\n\n -- $lc_dest --\n");
  system('cat',$lc_dest);
  system('echo');
}


# The following command-names were already deprecated
# by the time this package was first made into a GIT
# repository.
#$nexblank = 1;
#&prestall('hello','x-hello');
#$nexblank = 2;
#&prestall('generit','x-generit');
#&prestall('prep-calit-dx','x-prep-calit-dx');

&prestall('liturgscr-gener','x-generit');
&prestall('liturgscr-prep','x-prep-calit-dx');
&prestall('liturgscr-lookup','x-lookup');



