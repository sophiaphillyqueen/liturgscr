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

1;
