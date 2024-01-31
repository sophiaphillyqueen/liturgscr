# schedform.pm - The main resource file for LiturgiScript's SchedForm objects
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

package plm::schedform;
use strict;
use Cwd 'abs_path';
use File::Basename;
use plm::schedform::prv;
use plm::schedform::prv_02;
use plm::rgx;


sub new
{
  my $class;
  my $lc_neo;
  my $lc_file;
  my $lc_drec;
  my $lc_siz;
  
  $class = shift;
  $lc_neo = {};
  
  # The file and directory of this resource must be known.
  $lc_file = abs_path($_[0]);
  $lc_drec = abs_path(dirname($lc_file));
  $lc_neo->{'x'} = {};
  $lc_neo->{'x'}->{'file'} = $lc_file;
  $lc_neo->{'x'}->{'drec'} = $lc_drec;
  
  # And clearly, the output must start out empty.
  $lc_neo->{'buf'} = '';
  
  # And we need a hash in which to store dates other than
  # the static, dominant one.
  $lc_neo->{'dtx'} = {};
  
  return bless $lc_neo, $class;
}

sub instance
{
  my $self;
  my $lc_cm;
  my $lc_raw;
  my @lc_ray;
  my $lc_lin;
  my $lc_siz;
  
  $self = shift;
  $self->{'x'}->{'afn'} = \&plm::schedform::prv::dfl;
  $self->{'dx'} = {}; # This is where selected resources are stored.
  $self->{'date'} = $_[0];
  
  $lc_cm = 'cat' . &plm::rgx::rgadd($self->{'x'}->{'file'});
  $lc_raw = `$lc_cm`;
  @lc_ray = split(/\n/,$lc_raw);
  # INSERTIARY STARTS HERE:
  $lc_siz = @lc_ray;
  
  $self->{'x'}->{'alg'} = [ @lc_ray ];
  $self->{'x'}->{'siz'} = $lc_siz;
  $self->{'x'}->{'ptr'} = 0;
  $self->{'sbr'} = {};
  
  while ( $self->{'x'}->{'ptr'} < ( $self->{'x'}->{'siz'} + 2.5 ) )
  {
    my $lc2_a;
    my $lc2_fp;
    
    $lc2_a = $self->{'x'}->{'ptr'};
    $lc_lin = $self->{'x'}->{'alg'}->[$lc2_a];
    $lc2_a = int ( $lc2_a + 1.2 );
    $self->{'x'}->{'ptr'} = $lc2_a;
    
    $lc2_fp = $self->{'x'}->{'afn'};
    #print STDERR $lc2_a . ": " . $lc_lin . "\n";; # DEBUG
    &$lc2_fp($self,$lc_lin);
    if ( $self->{'x'}->{'ptr'} > ( $self->{'x'}->{'siz'} + 1.5 ) )
    {
      my $lc3_a;
      if ( exists($self->{'x'}->{'local'}) )
      {
        &plm::schedform::prv_02::reverto($self);
      }
      if ( exists($self->{'x'}->{'nx'}) )
      {
        $lc3_a = $self->{'x'}->{'nx'};
        $self->{'x'} = $lc3_a;
      }
    }
  }
}

sub clrout {
  my $self;
  my $lc_out;
  $self = shift;
  $lc_out = $self->{'buf'};
  $self->{'buf'} = '';
  return $lc_out;
}

sub out {
  my $self;
  $self = shift;
  return($self->{'buf'});
}




1;




