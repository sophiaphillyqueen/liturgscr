# plm::schedform::prv_02.pm - Second major file of 'schedform' private parts.
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

package plm::schedform::prv_02;
use strict;


sub reverto {
  my $self;
  my $lc_loc;
  my $lc_lca;
  my $lc_lcv;
  my $lc_itm;
  
  $self = shift;
  $lc_loc = $self->{'x'}->{'local'};
  $lc_lca = $lc_loc->{'all'};
  $lc_lcv = $lc_loc->{'val'};
  foreach $lc_itm (@$lc_lca)
  {
    delete($self->{'dx'}->{$lc_itm});
    if ( exists($lc_lcv->{$lc_itm}) )
    {
      $self->{'dx'}->{$lc_itm} = $lc_lcv->{$lc_itm};
    }
  }
}

sub extrac {
  my $lc_field;
  my $lc_fullc;
  my $lc_primo;
  my $lc_extro;
  my $lc_fla;
  my $lc_flb;
  my $lc_optag;
  
  ($lc_field,$lc_fullc) = @_;
  $lc_optag = '<infra:' . $lc_field . '>';
  ($lc_primo,$lc_extro) = split(quotemeta($lc_optag),$lc_fullc);
  ($lc_fla) = split(quotemeta('</infra:'),$lc_extro);
  ($lc_flb) = split(quotemeta('</infra>'),$lc_fla);
  
  return $lc_flb;
}


1;
