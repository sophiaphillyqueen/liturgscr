# plm::strops.pm -- Some string operations for LiturgiScript shell commands
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

package plm::strops;
use strict;

sub adcolon {
  my $lc_a;
  my $lc_b;
  my $lc_c;
  my $lc_d;
  
  $lc_a = scalar reverse $_[0];
  ($lc_b,$lc_c) = split('\:',$lc_a,2);
  $lc_d = scalar reverse $lc_c;
  
  return $lc_d;
}

1;

