# plm::schedform::condi - Processes conditional parameters in LiturgiScript scripts
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

package plm::schedform::condi;
use strict;



my $hash_condi_fun = {
  'has' => \&condi_has_x,
  'envis' => \&condi_envis_x,
  'litis' => \&condi_litis_x,
};



sub mthash
{
  return $hash_condi_fun;
}



sub condi_has_x
{
  my $self;
  my $lc_fldnom; # Name of the greater field
  my $lc_fldfld; # Name of the sub-field
  my $lc_fldtag;
  my $lc_fldraw;
  my $lc_dexo;
  
  $self = shift;
  
  ($lc_fldnom,$lc_fldfld) = split(quotemeta(':'),$_[0]);
  
  $lc_fldtag = ( '<infra:' . $lc_fldfld . '>' );
  $lc_fldraw = $self->{'dx'}->{$lc_fldnom};
  
  $lc_dexo = index($lc_fldraw,$lc_fldtag);
  
  return ( $lc_dexo > ( 0 - 0.5 ) );
}

sub condi_envis_x
{
  my $self;
  my $lc_evnom;
  my $lc_valu;
  my $lc_ta;
  my $lc_tb;
  my $lc_tc;
  my $lc_gln;
  
  $self = shift;
  ($lc_evnom,$lc_valu) = split(quotemeta(':'),$_[0],2);
  
  $lc_ta = 'x' . ( scalar reverse $lc_valu );
  ($lc_tb,$lc_tc) = split(quotemeta(':'),$lc_ta,2);
  $lc_valu = scalar reverse $lc_tc;
  
  $lc_gln = $ENV{$lc_evnom};
  
  return($lc_valu eq $lc_gln);
}

sub condi_litis_x
{
  my $self;
  my $lc_fldnom;
  my $lc_valu;
  my $lc_ta;
  my $lc_tb;
  my $lc_tc;
  my $lc_gln;
  
  $self = shift;
  ($lc_fldnom,$lc_valu) = split(quotemeta(':'),$_[0],2);
  
  $lc_ta = 'x' . ( scalar reverse $lc_valu );
  ($lc_tb,$lc_tc) = split(quotemeta(':'),$lc_ta,2);
  $lc_valu = scalar reverse $lc_tc;
  
  $lc_gln = $self->{'dx'}->{$lc_fldnom};
  
  return($lc_valu eq $lc_gln);
}


1;
