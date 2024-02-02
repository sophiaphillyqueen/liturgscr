# plm::lookup.pm -- Allows for lookup operations on value-config files
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

package plm::lookup;
use strict;
use plm::filops;
use plm::strops;

my $linetypes = {
  'env' => \&lt__env__x,
  'lit' => \&lt__lit__x,
};

sub main
{
  my $lc_filsrc;
  my $lc_varnom;
  my @lc_filcons;
  
  ($lc_filsrc,$lc_varnom) = @_;
  {
    my $lc2_a;
    $lc2_a = &plm::filops::loadraw($lc_filsrc);
    @lc_filcons = split(/\n/,$lc2_a);
  }
  return &subsid_aa($lc_filsrc,$lc_varnom,[@lc_filcons]);
}

sub subsid_aa
{
  my $lc_filsrc;
  my $lc_varnom;
  my $lc_filpat;
  my @lc_filcons;
  my $lc_spc;
  my $lc_larg;
  my $lc_lact;
  my $lc_ltyp;
  my $lc_lvnom;
  my $lc_itm;
  
  $lc_filsrc = $_[0];
  $lc_varnom = $_[1];
  $lc_filpat = $_[2];
  @lc_filcons = @$lc_filpat;
  
  $lc_spc = {
      'ret' => '',
      'filsrc' => $lc_filsrc,
      'varnom' => $lc_varnom,
      'filc' => $lc_filpat,
  };
  foreach $lc_itm (@lc_filcons)
  {
    my $lc2_a;
    my $lc2_b;
    $lc2_a = 'x' . &plm::strops::adcolon($lc_itm);
    ($lc2_b,$lc_lvnom,$lc_ltyp,$lc_larg) = split('\:',$lc2_a,4);
    if ( $lc_lvnom eq $lc_varnom )
    {
      if ( !exists($linetypes->{$lc_ltyp}) )
      {
        die ( "\n"
            . "FATAL ERROR: Unrecognized lookup-file line-type:\n"
            . "      File: " . $lc_filsrc . " :\n"
            . "  Linetype: " . $lc_ltyp . " :\n"
        . "\n" );
      }
      $lc_lact = $linetypes->{$lc_ltyp};
      &$lc_lact($lc_spc,$lc_larg);
    }
  }
  
  return ($lc_spc->{'ret'});
}

sub lt__env__x {
  $_[0]->{'ret'} .= $ENV{$_[1]};
}

sub lt__lit__x {
  $_[0]->{'ret'} .= $_[1];
}

1;
