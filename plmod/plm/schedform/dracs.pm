# plm::schedform::dracs.pm -- Some overflow of the LiturgiScript directives
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

package plm::schedform::dracs;
use strict;
use File::Basename;
use plm::schedform::prv_02;
use plm::filnom;
use plm::filops;
use plm::strops;
use plm::lookup;

sub ac__chvard__x
{
  my $self;
  my $lc_srcv;
  my $lc_chnv;
  my $lc_olddir;
  
  $self = shift;
  ($lc_srcv,$lc_chnv) = split('\:',$_[0]);
  $lc_olddir = $self->{'dx'}->{$lc_srcv};
  $self->{'dx'}->{$lc_srcv} =
      &plm::filnom::reltod($lc_olddir,$self->{'dx'}->{$lc_chnv})
  ;
}

sub ac__clear__x
{
  my $self;
  my $lc_argfld;
  my @lc_argray;
  my $lc_argitm;
  
  $self = shift;
  $lc_argfld = &plm::strops::adcolon($_[0]);
  @lc_argray = split('\:',$lc_argfld);
  foreach $lc_argitm (@lc_argray)
  {
    delete($self->{'dx'}->{$lc_argitm});
  }
}

sub ac__exvar__x
{
  my $self;
  my $lc_srcv;
  my $lc_src_v;
  my $lc_fldn;
  my $lc_optag;
  my $lc_dstv;
  
  $self = shift;
  ($lc_srcv,$lc_fldn,$lc_dstv) = split('\:',$_[0]);
  
  $lc_src_v = $self->{'dx'}->{$lc_srcv};
  $lc_optag = '<infra:' . $lc_fldn . '>';
  if ( index($lc_src_v,$lc_optag) < ( 0 - 0.5 ) ) { return; }
  
  $self->{'dx'}->{$lc_dstv} =
      &plm::schedform::prv_02::extrac($lc_fldn,$lc_src_v)
  ;
}

sub ac__fload__x
{
  my $self;
  my $lc_rgfld;
  my $lc_dstvar;
  my $lc_filrel;
  my $lc_filact;
  my $lc_cont;
  
  $self = shift;
  $lc_rgfld =  &plm::strops::adcolon($_[0]);
  ($lc_dstvar,$lc_filrel) = split('\:',$lc_rgfld,2);
  $lc_filact =
      &plm::filnom::reltod($self->{'x'}->{'drec'}
      ,$self->{'dx'}->{$lc_filrel})
  ;
  $lc_cont = &plm::filops::loadraw($lc_filact);
  
  $self->{'dx'}->{$lc_dstvar} = $lc_cont;
}

sub ac__lookup__x
{
  my $self;
  my $lc_varn;
  my $lc_rgfl;
  my @lc_rgray;
  my $lc_curvl;
  my $lc_itm;
  
  $self = shift;
  ($lc_varn,$lc_rgfl) = split('\:',&plm::strops::adcolon($_[0]),2);
  @lc_rgray = split('\:',$lc_rgfl);
  $lc_curvl =
      &plm::filnom::reltod($self->{'x'}->{'drec'}
      ,$self->{'dx'}->{$lc_varn})
  ;
  if ( !( -f $lc_curvl ) )
  {
    die("\nFATAL ERROR: No such file:\n"
        . "  File: " . $lc_curvl . " :\n"
    . "\n" );
  }
  foreach $lc_itm (@lc_rgray)
  {
    $lc_curvl = &plm::lookup::main($lc_curvl,$lc_itm);
  }
  $self->{'dx'}->{$lc_varn} = $lc_curvl;
}

sub ac__vardir__x
{
  my $self;
  my $lc_srcv;
  my $lc_olddir;
  
  $self = shift;
  ($lc_srcv) = split('\:',$_[0]);
  $lc_olddir = $self->{'dx'}->{$lc_srcv};
  $self->{'dx'}->{$lc_srcv} = dirname($lc_olddir);
}

1;
