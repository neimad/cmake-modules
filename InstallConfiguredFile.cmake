# Copyright © 2019 Damien Flament
#
# This file is part of CMake Modules.
#
# CMake Modules is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# CMake Modules is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with CMake Modules.  If not, see <https://www.gnu.org/licenses/>.

#[=======================================================================[.rst:
InstallConfiguredFile
---------------------

This module provides a function to install a file after substituing variable
values.

.. command:: install_configured_file

  install_configured_file(<input> <ouput>
                          DESTINATION <dir> [...])


#]=======================================================================]

include_guard(GLOBAL)

function(install_configured_file input output)
  cmake_parse_arguments(PARSE_ARGV 0 ""
    ""
    ""
    "DESTINATION"
  )

  configure_file(${input} ${output})

  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${output}
          DESTINATION ${_DESTINATION})
endfunction()
