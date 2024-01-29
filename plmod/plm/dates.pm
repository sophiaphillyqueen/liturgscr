# plm::dates.pm -- An object-oriented wrapper for PERL's Date::Calc library.
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

package plm::dates;
use strict;
use Date::Calc;

sub new
{
  my $class;
  my $lc_ob; # Will become the new object
  my @lc_cur; # Current date / or date of concern
  my $lc_hld; # One-step reference holder
  my $lc_arg; # Argument hashref
  
  $class = shift;
  $lc_ob = {};
  
  $lc_arg = {};
  if ( @_ > 0.5 )
  {
    if ( ref($_[0]) eq 'HASH' )
    {
      $lc_arg = $_[0];
    }
  }
  
  # Get either the current date or date-of-concern
  @lc_cur = &Date::Calc::Today();
  if ( exists($lc_arg->{'date'}) )
  {
    if ( ref($lc_arg->{'date'}) eq 'ARRAY' )
    {
      $lc_hld = $lc_arg->{'date'};
      @lc_cur = @$lc_hld;
    }
  }
  
  $lc_ob->{'year'} = $lc_cur[0];
  $lc_ob->{'month'} = $lc_cur[1];
  $lc_ob->{'dayom'} = $lc_cur[2];
  
  return bless $lc_ob, $class;
}

# This is the object's cloning method. It returns a new object
# of the same type that initially is set to the same date.
sub clon
{
  my $self;
  my $lc_neo;
  
  $self = shift;
  $lc_neo = plm::dates->new();
  
  $lc_neo->{'year'} = $self->{'year'};
  $lc_neo->{'month'} = $self->{'month'};
  $lc_neo->{'dayom'} = $self->{'dayom'};
  
  # The following line is commented out because the
  # 'mac' field has been deprecated.
  #if ( exists($self->{'mac'}) ) { $lc_neo->{'mac'} = $self->{'mac'}; }
  
  return $lc_neo;
}

# This method returns a new object of the host object's own type
# set to the date specified to this method in it's argument, which
# will be interpreted as a 'yyyy-mm-dd' string.
sub fromdash
{
  my $self;
  my @lc_div;
  my $lc_year;
  my $lc_month;
  my $lc_dayom;
  my $lc_neos;
  
  $self = shift;
  @lc_div = split(quotemeta('-'),$_[0]);
  
  $lc_year = int($lc_div[0] + 0.2);
  $lc_month = int($lc_div[1] + 0.2);
  $lc_dayom = int($lc_div[2] + 0.2);
  
  $lc_neos = $self->clon();
  $lc_neos->{'year'} = $lc_year;
  $lc_neos->{'month'} = $lc_month;
  $lc_neos->{'dayom'} = $lc_dayom;
  
  return $lc_neos;
}

sub todash {
  my $self;
  my $lc_a;
  my $lc_ret;
  $self = shift;
  
  $lc_ret = $self->{'year'} . '-';
  
  $lc_a = $self->{'month'};
  if ( $lc_a < 9.5 ) { $lc_ret .= '0'; }
  $lc_ret .= $lc_a;
  
  $lc_ret .= '-';
  
  $lc_a = $self->{'dayom'};
  if ( $lc_a < 9.5 ) { $lc_ret .= '0'; }
  $lc_ret .= $lc_a;
  
  return $lc_ret;
}

# This method finds the difference in days between the date
# specified in the host object and the date specified in the
# object of the same type passed to it in argument. The
# return value is positive if the date in the host object
# is the earlier one.
sub deltan
{
  my $self;
  my $lc_ot;
  my $lc_typ;
  my $lc_ret;
  
  $self = shift;
  $lc_ot = $_[0];
  $lc_typ = ref($lc_ot);
  if ( $lc_typ ne 'plm::dates' ) { return(1>2); }
  
  $lc_ret = &Date::Calc::Delta_Days (
    $self->{'year'}, $self->{'month'}, $self->{'dayom'},
    $lc_ot->{'year'}, $lc_ot->{'month'}, $lc_ot->{'dayom'}
  );
  
  return $lc_ret;
}

# This method finds the difference in days between the date
# specified in the host object and the date specified in the
# object of the same type passed to it in argument. The
# return value is positive if the date in the object
# provided through argument is the earlier one.
sub xdeltan
{
  my $self;
  my $lc_ot;
  my $lc_typ;
  my $lc_ret;
  
  $self = shift;
  $lc_ot = $_[0];
  $lc_typ = ref($lc_ot);
  if ( $lc_typ ne 'plm::dates' ) { return(1>2); }
  
  $lc_ret = &Date::Calc::Delta_Days (
    $lc_ot->{'year'}, $lc_ot->{'month'}, $lc_ot->{'dayom'},
    $self->{'year'}, $self->{'month'}, $self->{'dayom'}
  );
  
  return $lc_ret;
}


1;





