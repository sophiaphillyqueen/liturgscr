# filnom.pm -- Filename operations for LiturgiScript command-line tools
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

package plm::filnom;
use strict;
use Cwd 'abs_path';
use File::Basename;


sub reltod
{
  my $lc_sdir;
  my $lc_relf;
  my $lc_exch; # For EXamined CHaracter
  
  ($lc_sdir,$lc_relf) = @_;
  $lc_exch = substr($lc_relf,0,1);
  if ( $lc_exch eq '/' ) { return $lc_relf; }
  
  return abs_path($lc_sdir . '/' . $lc_relf);
}

sub reltof {
  my $lc_subfil;
  my $lc_relfil;
  my $lc_sdir;
  
  ($lc_subfil,$lc_relfil) = @_;
  
  $lc_sdir = dirname($lc_subfil);
  
  return &reltod($lc_sdir,$lc_relfil);
}



1;


