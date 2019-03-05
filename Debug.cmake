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
Debug
-----

This module provides convenient commands to debug CMake scripts.
#]=======================================================================]

include_guard(GLOBAL)

#[=======================================================================[.rst:
.. command:debug_variables

  Prints the value of available variables grouped by prefix. ::

    debug_variables([CMAKE] [PRIVATE])

  The default behavior is to ignore CMake and private variables as it often
  clutters the output. Here CMake variables are those prefixed with `CMAKE_`,
  regardless of the way they are defined (by the user or not). Private variables
  are those prefixed with at least one underscore `_`.

  When the ``CMAKE`` option is given, the CMake variables are also listed.

  When the ``PRIVATE`` option is given, the private variables are also listed.
#]=======================================================================]
function(debug_variables)
  # FIXME Prevent ARGC and ARGV pollution
  get_cmake_property(variables VARIABLES)

  set(ignored_variables ARGC ARGN ARGV)
  set(cmake_variables)
  set(ungrouped_variables)
  set(private_variables)

  cmake_parse_arguments(PARSE_ARGV 0 ""
    "CMAKE;PRIVATE"
    ""
    ""
  )

  # Group variables by prefix
  foreach(variable ${variables})
    if(variable IN_LIST ignored_variables OR variable MATCHES "^ARGV[0-9]+")
      continue()
    endif()

    if(variable MATCHES "^_+.+$")
      list(APPEND private_variables "${variable}")

      continue()
    endif()

    if(variable MATCHES "^([^_]+)_.+$")
      set(group ${CMAKE_MATCH_1})

      if (group STREQUAL "CMAKE")
        list(APPEND cmake_variables "${variable}")

        continue()
      endif()

      if(NOT group IN_LIST groups)
        list(APPEND groups "${group}")
      endif()

      list(APPEND group_${group}_variables "${variable}")

      continue()
    endif()

    list(APPEND ungrouped_variables "${variable}")
  endforeach()

  # Handle single group variables as ungrouped
  foreach(group in ${groups})
    list(LENGTH group_${group}_variables group_length)

    if (NOT group_length GREATER "1")
      list(APPEND ungrouped_variables ${group_${group}_variables})
      unset(group_${group}_variables)
      list(REMOVE_ITEM groups ${group})

      continue()
    endif()

    list(SORT group_${group}_variables)
  endforeach()

  # Sort groups and variables
  list(SORT groups)
  list(SORT cmake_variables)
  list(SORT private_variables)
  list(SORT ungrouped_variables)

  # Print variables
  function(print_variables label variables)
    message("\n  ${label} variables")
    message("  ------------------------------\n")

    foreach(variable ${variables})
      message("    ${variable} = ${${variable}}")
    endforeach()
  endfunction()

  message("\n## Debugging variables in ${CMAKE_CURRENT_LIST_FILE} at line ${CMAKE_CURRENT_LIST_LINE}")

  foreach (group ${groups})
    print_variables("`${group}`" "${group_${group}_variables}")
  endforeach()

  if (_CMAKE)
    print_variables("CMake" "${cmake_variables}")
  endif()

  if (_PRIVATE)
    print_variables("Private" "${private_variables}")
  endif()

  print_variables("Ungrouped" "${ungrouped_variables}")

  message("\n## Debugging variables done\n")
endfunction()
