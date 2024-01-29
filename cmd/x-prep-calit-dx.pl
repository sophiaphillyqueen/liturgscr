# x-prep-calit-dx.pl -- A command to gather information on how many entries there are in a LiturgiScript resource-content file
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
use plm::rgx;

while ( &plm::rgx::remain() )
{
  my $lc_rg;
  my $lc_cm;
  my $lc_raw;
  my @lc_ray;
  my $lc_sum;
  
  $lc_rg = &plm::rgx::rgget();
  
  # First we load the contents of the file
  # into a variable.
  $lc_cm = 'cat' . &plm::rgx::rgadd($lc_rg);
  $lc_raw = `$lc_cm`;
  $lc_raw = 'x' . $lc_raw;
  
  @lc_ray = split(quotemeta("<cycle>"),$lc_raw);
  shift(@lc_ray);
  
  $lc_sum = @lc_ray;
  print ':' . $lc_rg . ':' . $lc_sum . ":\n";
}
