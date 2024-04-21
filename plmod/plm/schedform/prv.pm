# plm::schedform::prv.pm -- This file interprets the basic diredctives in a LiturgiScript script
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

package plm::schedform::prv;
use strict;
use File::Basename;
use plm::filnom;
use plm::filops;
use plm::schedform::condi;
use plm::schedform::dracs;
use plm::strops;


my $hash_fun_main = {
  'addtx' => \&acto_addtx_x,
  'capflit' => \&acto_capflit_x,
  'chvard' => \&plm::schedform::dracs::ac__chvard__x,
  'clear' => \&plm::schedform::dracs::ac__clear__x,
  'envset' => \&acto_envset_x,
  'exvar' => \&plm::schedform::dracs::ac__exvar__x,
  'fload' => \&plm::schedform::dracs::ac__fload__x,
  'lookup' => \&plm::schedform::dracs::ac__lookup__x,
  'show' => \&acto_show_x,
  'loadsmp' => \&acto_loadsmp_x,
  'loadvsmp' => \&acto_loadvsmp_x,
  'loadvvsmp' => \&acto_loadvvsmp_x,
  'local' => \&acto_local_x,
  'vardir' => \&plm::schedform::dracs::ac__vardir__x,
  'env' => \&acto_env_x,
  'sh' => \&acto_sh_x,
  'fi' => \&the_zen_fun,
  'label' => \&the_zen_fun,
  'subload' => \&acto_subload_x,
  'subvload' => \&acto_subvload_x, # Not yet with this idea ...
  'subrun' => \&acto_subrun_x,
  'cp' => \&acto_cp_x,
  'apnd' => \&acto_apnd_x,
  'if' => \&acto_if_x,
  'and' => \&acto_if_x,
  'else' => \&acto_else_x,
  'set' => \&acto_set_x,
  'cmset' => \&acto_cmset_x,
  'setp' => \&acto_setp_x,
  'lit' => \&acto_lit_x,
};

my $hash_condi_fun = &plm::schedform::condi::mthash();

my $hash_skipper_fun = {
  'if' => \&askip_if_x,
  'fi' => \&askip_fi_x,
  'else' => \&askip_else_x,
};

sub dfl
{
  my $self;
  my $lc_pres;
  my $lc_junk;
  my $lc_comd;
  my $lc_cont;
  
  $self = shift;
  $lc_pres = 'x' . $_[0];
  ($lc_junk,$lc_comd,$lc_cont) = split(quotemeta(':'),$lc_pres,3);
  
  if ( $lc_comd eq '-' )
  {
    $self->{'buf'} .= ( $lc_cont . "\n" );
    return;
  }
  
  if ( $lc_comd eq '**' )
  {
    my $lc2_a;
    my $lc2_b;
    my $lc2_c;
    my $lc2_d;
    $lc2_a = ( 'x' . ( scalar reverse $lc_cont ) );
    ($lc2_b,$lc2_c) = split(quotemeta(':'),$lc2_a,2);
    $lc2_d = ( scalar reverse $lc2_c );
    $self->{'buf'} .= $lc2_d;
    return;
  }
  
  if ( $lc_comd eq '*' )
  {
    $self->{'buf'} .= $lc_cont;
    return;
  }
  
  if ( exists($hash_fun_main->{$lc_comd}) )
  {
    my $lc2_a;
    $lc2_a = $hash_fun_main->{$lc_comd};
    &$lc2_a($self,$lc_cont);
    return;
  }
  
  #if ( $lc_comd eq 'show' )
  #{
  #  &acto_show_x($self,$lc_cont);
  #  return;
  #}
  
  if ( $lc_comd eq 'dbgshow' )
  {
    &acto_lit_x($self,$lc_cont);
    return;
  }
  
  #if ( $lc_comd eq 'env' )
  #{
  #  &acto_env_x($self,$lc_cont);
  #  return;
  #}
  
  #if ( $lc_comd eq 'sh' )
  #{
  #  &acto_sh_x($self,$lc_cont);
  #  return;
  #}
  
  if ( $lc_comd eq '' ) { return; }
  
  print STDERR "\nUnfamiliar directive: :" . $lc_comd . ":\n\n";
  sleep(1);
}

sub acto_env_x
{
  my $self;
  my $lc_varn;
  
  $self = shift;
  
  ($lc_varn) = split(quotemeta(':'),$_[0]);
  $self->{'buf'} .= $ENV{$lc_varn};
}

sub acto_envset_x
{
  my $self;
  my $lc_varn;
  my $lc_evarn;
  
  $self = shift;
  
  ($lc_varn,$lc_evarn) = split(quotemeta(':'),$_[0]);
  $self->{'dx'}->{$lc_varn} = $ENV{$lc_evarn};
}

sub acto_sh_x
{
  my $self;
  my $lc_cm;
  my $lc_out;
  
  $self = shift;
  $lc_cm = $_[0];
  $lc_out = `$lc_cm`;
  $self->{'buf'} .= $lc_out;
}

sub d__row_of_idx
{
  my $lc_prsp;
  my @lc_ray;
  my $lc_tly;
  my @lc_ret;
  
  $lc_prsp = 'x' . $_[0] . 'x';
  
  @lc_ray = split(quotemeta(':'), $lc_prsp);
  shift(@lc_ray);
  pop(@lc_ray);
  
  $lc_tly = @lc_ray;
  @lc_ret = ( ($lc_tly > 1.5), [@lc_ray] );
  
  return @lc_ret;
}

sub acto_loadsmp_x
{
  my $self;
  my $lc_fldn; # Field name
  my $lc_sdate; # Start date of cycle
  my $lc_stpd; # Steps per day
  my $lc_start; # Start position of cycle (zero inclusive)
  my $lc_rlidx; # Relative location of resource index
  my $lc_abidx; # Absolute filename of resource index.
  my @lc_idxrows;
  my $lc_idxsize; # The number of steps in the resource's cycle
  my $lc_dtstart; # Date object for the day the cycle started;
  my $lc_diffdate; # Today's offset from the cycle start date.
  my $lc_calc; # Today's position in the rotation. (Zero inclusive)
  my $lc_indivf; # Individual resource file
  my $lc_rxinf; # place-number of entry in file
  my $lc_resrcc;
  my $lc_er; # For the printing of error messages:
  
  $self = shift;
  ($lc_fldn,$lc_sdate,$lc_stpd,$lc_start,$lc_rlidx) = split(quotemeta(':'), $_[0]);
  
  # First come, first serve.
  if ( exists($self->{'dx'}->{$lc_fldn})) { return; }
  
  # Don't mess with cycles that start in the future.
  $lc_dtstart = $self->{'date'}->fromdash($lc_sdate);
  $lc_diffdate = $self->{'date'}->xdeltan($lc_dtstart);
  if ( $lc_diffdate < ( 0 - 0.5 ) ) { return; }
  
  # Get absolute filename of resource index.
  $lc_abidx = &plm::filnom::reltod($self->{'x'}->{'drec'}, $lc_rlidx);
  
  # Error if the file is not found:
  if ( ! ( -f $lc_abidx ) )
  {
    $lc_er = "NO SUCH INDEX FILE:\n";
    $lc_er .= "   Mentioned as: " . $lc_rlidx . " :\n"; 
    $lc_er .= "  Referenced at: " . $self->{'x'}->{'file'};
    $lc_er .= " : Line " . $self->{'x'}->{'ptr'} . " :\n";
    
    print STDERR $lc_er;
    return;
  }
  
  # Get the contents of the file.
  @lc_idxrows = &plm::filops::glomp($lc_abidx,\&d__row_of_idx);
  
  # Calculate the length of a cycle.
  $lc_idxsize = &d__siz_of_idx(\@lc_idxrows);
  
  # Don't do any modulus by zero:
  if ( $lc_idxsize < 0.5 ) { return; }
  
  # Find today's position in the rotation.
  $lc_calc = ( $lc_diffdate % $lc_idxsize );
  $lc_calc = int ( ( $lc_calc * $lc_stpd ) + 0.2 );
  $lc_calc = int ( $lc_calc + $lc_start + 0.2 );
  $lc_calc = ( $lc_calc % $lc_idxsize );
  
  ($lc_indivf, $lc_rxinf) = &d__pick_row($lc_calc,\@lc_idxrows);
  $lc_indivf = &plm::filnom::reltof($lc_abidx,$lc_indivf);
  
  $lc_resrcc = &d__extract_ntr($lc_indivf,$lc_rxinf);
  $self->{'dx'}->{$lc_fldn} = $lc_resrcc;
}

# The :loadvsmp: directive is just like the :loadsmp: one
# except that the last parameter, the one that specifies
# the location of the resource index file, does by naming
# a deck-variable that contains the literal contents rather
# than by _itself_ providing the literal contents.
sub acto_loadvsmp_x
{
  my $self;
  my $lc_fldn;
  my $lc_sdate;
  my $lc_stpd;
  my $lc_start;
  my $lc_rldvar;
  my $lc_rlidx;
  my $lc_passon;

  $self = shift;
  ($lc_fldn,$lc_sdate,$lc_stpd,$lc_start,$lc_rldvar) = split(quotemeta(':'), $_[0]);
  $lc_rlidx = $self->{'dx'}->{$lc_rldvar};
  
  $lc_passon = $lc_fldn . ':' . $lc_sdate . ':' . $lc_stpd . ':' . $lc_start . ':' . $lc_rlidx . ':';
  
  
  &acto_loadsmp_x($self,$lc_passon);
}

# The :loadvvsmp: directive is of the same mindset as :loadvsmp:
# except it takes it one step further. While :loadvsmp: only
# bases the source filename on a variable, :loadvvsmp: also does
# that with the launch-date of a cycle, how many steps a day
# the cycle takes, and how many steps in the cycle starts at.
sub acto_loadvvsmp_x
{
  my $self;
  my $lc_fldn;
  my $lc_sdate;
  my $lc_stpd;
  my $lc_start;
  my $lc_rldvar;
  my $lc_rlidx;
  my $lc_passon;

  $self = shift;
  ($lc_fldn,$lc_sdate,$lc_stpd,$lc_start,$lc_rldvar) = split(quotemeta(':'), $_[0]);
  $lc_rlidx = $self->{'dx'}->{$lc_rldvar};
  
  $lc_passon = $lc_fldn . ':'
      . $self->{'dx'}->{$lc_sdate} . ':'
      . $self->{'dx'}->{$lc_stpd} . ':'
      . $self->{'dx'}->{$lc_start} . ':'
      . $lc_rlidx . ':'
  ;
  
  
  &acto_loadsmp_x($self,$lc_passon);
}

sub acto_local_x {
  my $self;
  my $lc_rgfl;
  my @lc_nvar;
  my @lc_olvar;
  my $lc_ahash;
  my $lc_item;
  
  $self = shift;
  $lc_rgfl = &plm::strops::adcolon($_[0]);
  @lc_nvar = split('\:',$lc_rgfl);
  @lc_olvar = ();
  $lc_ahash = {};
  if ( exists($self->{'x'}->{'local'}) )
  {
    my $lc2_a;
    $lc2_a = $self->{'x'}->{'local'}->{'all'};
    @lc_olvar = @$lc2_a;
    $lc_ahash = $self->{'x'}->{'local'}->{'val'}
  }
  foreach $lc_item (@lc_nvar)
  {
    if ( exists($self->{'dx'}->{$lc_item}) )
    {
      $lc_ahash->{$lc_item} = $self->{'dx'}->{$lc_item};
    }
  }
  $self->{'x'}->{'local'} = {
      'all' => [@lc_nvar,@lc_olvar],
      'val' => $lc_ahash,
  };
}

sub acto_show_x
{
  my $self;
  my $lc_varn;
  my $lc_seg;
  my $lc_optag;
  my $lc_fldval;
  
  $self = shift;
  ($lc_varn,$lc_seg) = split(quotemeta(':'),$_[0]);
  
  $lc_optag = '<infra:' . $lc_seg . '>';
  {
    my $lc2_a;
    my @lc2_b;
    my $lc2_c;
    my $lc2_d;
    
    $lc2_a = $self->{'dx'}->{$lc_varn};
    @lc2_b = split(quotemeta($lc_optag),$lc2_a);
    $lc2_c = $lc2_b[1];
    ($lc2_d) = split(quotemeta('</infra:'),$lc2_c);
    ($lc_fldval) = split(quotemeta('</infra>'),$lc2_d);
  }
  
  $self->{'buf'} .= $lc_fldval;
}

sub acto_set_x
{
  my $self;
  my $lc_varn;
  my $lc_cont;
  
  $self = shift;
  ($lc_varn,$lc_cont) = split('\:',$_[0],2);
  $lc_cont = &plm::strops::adcolon($lc_cont);
  
  $self->{'dx'}->{$lc_varn} = $lc_cont;
}

sub acto_cmset_x
{
  my $self;
  my $lc_varn;
  my $lc_cmd;
  my $lc_cont;
  
  $self = shift;
  ($lc_varn,$lc_cmd) = split('\:',$_[0],2);
  $lc_cmd = &plm::strops::adcolon($lc_cmd);
  
  $lc_cont = `$lc_cmd`; chomp($lc_cont);
  $self->{'dx'}->{$lc_varn} = $lc_cont;
}

sub acto_setp_x
{
  my $self;
  my $lc_varn;
  my $lc_cont;
  
  $self = shift;
  ($lc_varn,$lc_cont) = split('\:',$_[0],2);
  $lc_cont = &plm::strops::adcolon($lc_cont);
  
  $self->{'dx'}->{$lc_varn} .= $lc_cont;
}

sub acto_lit_x
{
  my $self;
  my $lc_varn;
  #my $lc_seg;
  #my $lc_optag;
  #my $lc_fldval;
  
  $self = shift;
  ($lc_varn) = split(quotemeta(':'),$_[0]);
  
  $self->{'buf'} .= $self->{'dx'}->{$lc_varn};
}

sub acto_capflit_x
{
  my $self;
  my $lc_varn;
  my $lc_capo;
  
  $self = shift;
  ($lc_varn) = split(quotemeta(':'),$_[0]);
  
  $lc_capo = $self->{'dx'}->{$lc_varn};
  $lc_capo =~ s/^([a-z])/\U$1/;
  $self->{'buf'} .= $lc_capo;
}

sub d__siz_of_idx
{
  my $lc_rref;
  my @lc_ray;
  my $lc_tly;
  my $lc_itm;
  
  $lc_rref = $_[0];
  @lc_ray = @$lc_rref;
  $lc_tly = 0;
  
  foreach $lc_itm (@lc_ray)
  {
    $lc_tly = int($lc_tly + 0.2 + $lc_itm->[1]);
  }
  
  return $lc_tly;
}

sub d__pick_row
{
  my $lc_calc;
  my $lc_rref;
  my @lc_ray;
  my $lc_row;
  my @lc_ret;
  
  ($lc_calc,$lc_rref) = @_;
  @lc_ray = (@$lc_rref, @$lc_rref);
  
  foreach $lc_row (@lc_ray)
  {
    if ( ( $lc_calc + 0.5 ) < $lc_row->[1] )
    {
      @lc_ret = ( $lc_row->[0], $lc_calc );
      return @lc_ret;
    }
    $lc_calc = int(($lc_calc - $lc_row->[1] ) + 0.2);
  }
}

sub d__extract_ntr
{
  my $lc_filloc;
  my $lc_ntrid;
  my $lc_rawcont;
  my @lc_ray;
  my $lc_ret;
  
  ($lc_filloc,$lc_ntrid) = @_;
  $lc_rawcont = &plm::filops::loadraw($lc_filloc);
  
  @lc_ray = split(quotemeta('<cycle>'),$lc_rawcont);
  shift @lc_ray;
  
  $lc_ret = $lc_ray[$lc_ntrid];
  return $lc_ret;
}

sub acto_cp_x
{
  my $self;
  my $lc_srcnom;
  my $lc_dstnom;
  
  $self = shift;
  ( $lc_srcnom, $lc_dstnom ) = split(quotemeta(':'),$_[0]);
  
  $self->{'dx'}->{$lc_dstnom} = $self->{'dx'}->{$lc_srcnom};
}

sub acto_apnd_x
{
  my $self;
  my $lc_srcnom;
  my $lc_dstnom;
  
  $self = shift;
  ( $lc_srcnom, $lc_dstnom ) = split(quotemeta(':'),$_[0]);
  
  $self->{'dx'}->{$lc_dstnom} .= $self->{'dx'}->{$lc_srcnom};
}

sub acto_addtx_x
{
  my $self;
  my $lc_valu;
  my $lc_cvalu;
  my $lc_dstnom;
  
  $self = shift;
  ( $lc_dstnom, $lc_cvalu ) = split(quotemeta(':'),$_[0],2);
  $lc_valu = &plm::strops::adcolon($lc_cvalu);
  
  $self->{'dx'}->{$lc_dstnom} .= $lc_valu;
}

sub the_zen_fun { } # A very short function, indeed.

sub acto_subvload_x
{
  my $self;
  my $lc_sbnom;
  my $lc_filvar;
  my $lc_filarg;
  
  $self = shift;
  # Get the function's basic parameters
  ($lc_sbnom,$lc_filvar) = split(quotemeta(':'),$_[0]);
  if ( !exists($self->{'dx'}->{$lc_filvar}) )
  {
    die "\nNo such variable: " . $lc_filvar . " :\n\n";
  }
  $lc_filarg = $self->{'dx'}->{$lc_filvar};
  &inr_acto_subload_x_01($self,$lc_sbnom,$lc_filarg);
}

sub acto_subload_x
{
  my $self;
  my $lc_sbnom;
  my $lc_filarg;
  
  $self = shift;
  # Get the function's basic parameters
  ($lc_sbnom,$lc_filarg) = split(quotemeta(':'),$_[0]);
  &inr_acto_subload_x_01($self,$lc_sbnom,$lc_filarg);
}

sub inr_acto_subload_x_01
{
  my $self;
  my $lc_sbnom;
  my $lc_filarg;
  my $lc_filloc;
  my $lc_fildir;
  my $lc_rawcont;
  my @lc_algo;
  my $lc_algsz;
  my $lc_neo;
  
  $self = shift;
  # Get the function's basic parameters
  #($lc_sbnom,$lc_filarg) = split(quotemeta(':'),$_[0]);
  $lc_sbnom = $_[0];
  $lc_filarg = $_[1];
  
  # Find where the subroutine is in the system's filesystem
  $lc_filloc = &plm::filnom::reltod($self->{'x'}->{'drec'},$lc_filarg);
  $lc_fildir = dirname($lc_filloc);
  
  $lc_rawcont = &plm::filops::loadraw($lc_filloc);
  @lc_algo = split(/\n/,$lc_rawcont);
  $lc_algsz = @lc_algo;
  
  $lc_neo = {
    'file' => $lc_filloc,
    'drec' => $lc_fildir,
    'alg' => [ @lc_algo ],
    'siz' => $lc_algsz,
  };
  
  $self->{'sbr'}->{$lc_sbnom} = $lc_neo;
}

sub acto_subrun_x
{
  my $self;
  my $lc_lgnom;
  my $lc_lgres;
  my $lc_neo;
  
  $self = shift;
  ($lc_lgnom) = split(quotemeta(':'),$_[0]);
  
  if ( !exists($self->{'sbr'}->{$lc_lgnom}) )
  {
    die("\nNo such soubroutine: " . $lc_lgnom . " :\n\n");
  }
  $lc_lgres = $self->{'sbr'}->{$lc_lgnom};
  
  $lc_neo = {
    'file' => $lc_lgres->{'file'},
    'drec' => $lc_lgres->{'drec'},
    'alg' => $lc_lgres->{'alg'},
    'siz' => $lc_lgres->{'siz'},
    'afn' => \&dfl,
    'nx' => $self->{'x'},
    'ptr' => 0,
  };
  
  $self->{'x'} = $lc_neo;
}

sub acto_if_x
{
  my $self;
  my $lc_condi; # Condition's name
  my $lc_pram; # Condition's parameters
  my $lc_condm; # Condition's evaluation method
  
  $self = shift;
  ($lc_condi, $lc_pram) = split(quotemeta(':'),$_[0],2);
  
  if ( !exists($hash_condi_fun->{$lc_condi}) )
  {
    die("\nNo such condition: " . $lc_condi . " :\n\n");
  }
  $lc_condm = $hash_condi_fun->{$lc_condi};
  
  if ( &$lc_condm($self,$lc_pram) ) { return; }
  
  # Turn off program flow (That is - go into skip mode)
  $self->{'x'}->{'off'} = 1;
  $self->{'x'}->{'afn'} = \&mthod_skip;
}

sub mthod_skip
{
  my $self;
  my $lc_raw;
  my $lc_trash;
  my $lc_mthnm;
  my $lc_mthpr;
  my $lc_mthod;
  
  $self = shift;

  $lc_raw = 'x' . $_[0];
  ($lc_trash,$lc_mthnm,$lc_mthpr) = split(quotemeta(':'),$_[0],3);
  
  if ( !exists($hash_skipper_fun->{$lc_mthnm}) ) { return; }
  
  $lc_mthod = $hash_skipper_fun->{$lc_mthnm};
  
  &$lc_mthod($self,$lc_mthpr);
}

sub askip_if_x
{
  my $self;
  my $lc_nest;
  
  $self = shift;
  
  $lc_nest = int($self->{'x'}->{'off'} + 1.2);
  $self->{'x'}->{'off'} = $lc_nest;
}

sub askip_fi_x
{
  my $self;
  my $lc_nest;
  
  my $self = shift;
  
  $lc_nest = int($self->{'x'}->{'off'} - 0.8);
  $self->{'x'}->{'off'} = $lc_nest;
  
  if ( $lc_nest < 0.5 )
  {
    $self->{'x'}->{'afn'} = \&dfl;
  }
}

sub askip_else_x
{
  my $self;
  
  $self = shift;
  
  if ( $self->{'x'}->{'off'} < 1.5 )
  {
    $self->{'x'}->{'off'} = 0;
    $self->{'x'}->{'afn'} = \&dfl;
  }
}

sub acto_else_x
{
  my $self;
  
  $self = shift;
  $self->{'x'}->{'off'} = 1;
  $self->{'x'}->{'afn'} = \&mthod_skip;
}


1;
















