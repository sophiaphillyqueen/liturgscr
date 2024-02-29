# liturgscr-lookup -- Command-line access to LigurgiScript's preference lookup
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

use strict;
use plm::lookup;
use plm::rgx;

my $reto;

$reto = &plm::rgx::rgget();

while ( &plm::rgx::remain() )
{
  my $lc_a;
  $lc_a = &plm::rgx::rgget();
  $reto = &plm::lookup::main($reto,$lc_a);
}

print $reto . "\n";


