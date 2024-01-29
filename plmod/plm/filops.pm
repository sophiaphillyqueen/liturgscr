# filops.pm - File operations for LiturgiScript shell-commands
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

package plm::filops;
use strict;
use Cwd 'abs_path';
use plm::rgx;

sub loadraw
{
  my $lc_cm;
  my $lc_cont;
  
  $lc_cm = 'cat' . &plm::rgx::rgadd(abs_path($_[0]));
  $lc_cont = `$lc_cm`;
  
  return $lc_cont;
}

sub glomp {
  my $lc_raw;
  my @lc_iray;
  my @lc_oray;
  my $lc_trow;
  my $lc_mthod;
  my $lc_okay;
  my $lc_item;
  
  $lc_raw = &loadraw($_[0]);
  @lc_iray = split(/\n/,$lc_raw);
  @lc_oray = ();
  $lc_mthod = $_[1];
  foreach $lc_trow (@lc_iray)
  {
    ($lc_okay,$lc_item) = &$lc_mthod($lc_trow);
    if ( $lc_okay )
    {
      @lc_oray = (@lc_oray,$lc_item);
    }
  }
  
  return @lc_oray;
}



1;



