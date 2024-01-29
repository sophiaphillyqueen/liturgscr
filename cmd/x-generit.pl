# x-generit.pl -- The LiturgiScript command for executing a LiturgiScript file
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
use Cwd 'abs_path';
use plm::rgx;
use plm::dates;
use plm::schedform;

my $retval;

# Initialize the path to search for schedule file.
my @sched_file_path = ();

# Initialize that date that we are generating the page for.
my $date_of_concern = plm::dates->new();

# This option appends a file to the schedule-file path. In
# the end, the selected schedule-file will be the first one
# on the path that exists but whose block-file does not.
&plm::rgx::setopt('-scf',\&optm__scf__x);
sub optm__scf__x
{
  if ( &plm::rgx::remain() )
  {
    @sched_file_path = (@sched_file_path, &plm::rgx::rgget() );
  }
}

&plm::rgx::setopt('-date',\&optm__date__x);
sub optm__date__x
{
  my $lc_year;
  my $lc_month;
  my $lc_dayom;
  my $lc_remc;
  my $lc_hld;
  
  # The default (if insufficient arguments are specified) is the
  # previously established date.
  $lc_year = $date_of_concern->{'year'};
  $lc_month = $date_of_concern->{'month'};
  $lc_dayom = $date_of_concern->{'dayom'};
  
  # Now we see what elements of a new date are in fact provided.
  $lc_remc = &plm::rgx::remc();
  if ( $lc_remc > 0.5 )
  {
    $lc_hld = &plm::rgx::rgget();
    if ( $lc_hld ne 'x' ) { $lc_year = $lc_hld; }
  }
  if ( $lc_remc > 1.5 )
  {
    $lc_hld = &plm::rgx::rgget();
    if ( $lc_hld ne 'x' ) { $lc_month = $lc_hld; }
  }
  if ( $lc_remc > 2.5 )
  {
    $lc_hld = &plm::rgx::rgget();
    if ( $lc_hld ne 'x' ) { $lc_dayom = $lc_hld; }
  }
  
  # And finally, we save all the newly determined information
  # to the active date-of-concern.
  $date_of_concern = plm::dates->new({'date' => [$lc_year,$lc_month,$lc_dayom] });
}

# Now with all that established -- let us run the command-line scanner.
&plm::rgx::runopts();


# Now we begin looking for the formatting file:
my $sk_file_found = 0;
my $found_sk_file;
&hunt_for_sk_file();
sub hunt_for_sk_file
{
  my $lc_each;
  my $lc_ret;
  
  foreach $lc_each (@sched_file_path)
  {
    $lc_ret = &hunt_on_sk_file($lc_each);
    if ( $lc_ret > 5 )
    {
      $sk_file_found = 10;
      $found_sk_file = abs_path($lc_each);
      return;
    }
  }
}

sub hunt_on_sk_file {
  my $lc_tr;
  $lc_tr = $_[0];
  if ( !(-f $lc_tr) ) { return 0; }
  if ( -d $lc_tr ) { return 0; }
  $lc_tr .= '.blk';
  if ( -f $lc_tr ) { return 0; }
  return 10;
}

if ( $sk_file_found < 5 )
{
  die "\nCould not locate schedule-and-format file:\n\n";
}


my $fil_alrgorim = plm::schedform->new($found_sk_file);
$fil_alrgorim->instance($date_of_concern);

$retval = $fil_alrgorim->out();

chomp($retval);
print $retval;
print "\n";





