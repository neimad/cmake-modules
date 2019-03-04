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
TargetModules
-------------

This module allows to declare required modules using the
:command:`require_module` command and define modules required by a target using
the :command:`target_require_modules` command.

The implementation rely on the availability of the ``pkg-config`` tool.
#]=======================================================================]

include_guard(GLOBAL)

#[=======================================================================[.rst:
.. command:: require_module

  Checks if a ``module`` is available using pkg-config. ::

    require_module(<module>
                   [MINIMUM <version>])

  When the ``MINIMUM`` argument is given, module will match only if its
  version is from ``version`` or later.
#]=======================================================================]
function(require_module module)
  find_package(PkgConfig REQUIRED)

  cmake_parse_arguments(PARSE_ARGV 0 ""
    ""
    "MINIMUM"
    ""
  )

  set(specification "${module}")

  if (_MINIMUM)
    string(APPEND specification ">=" ${_MINIMUM})
  endif()

  pkg_check_modules(_TargetModules_${module} REQUIRED ${specification})
endfunction()

#[=======================================================================[.rst:
.. command:: target_require_modules

  Specify include directories, compile options and link flags needed to compile
  and link the ``target`` using the specified modules. ::

    target_require_modules(<target> MODULES <module> [<module>...])

  When specifying the ``module``, no version specification is allowed as it
  needs to be done using :command:`require_module`.

#]=======================================================================]
function(target_require_modules target)
  cmake_parse_arguments(PARSE_ARGV 0 ""
    ""
    ""
    "MODULES"
  )

  foreach(module ${_MODULES})
    target_include_directories(${target} PUBLIC ${_TargetModules_${module}_INCLUDE_DIRS})
    target_compile_options(${target} PUBLIC ${_TargetModules_${module}_CFLAGS})
    target_link_libraries(${target} ${_TargetModules_${module}_LIBRARIES})
  endforeach(module)
endfunction()
