# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright © 2019 Damien Flament
# This file is part of CMake Modules.

#[=======================================================================[.rst:
TargetModules
-------------

This module allows to declare required modules using the
:command:`require_module` command and define modules required by a target using
the :command:`target_required_modules` command.

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
.. command:: target_required_modules

  Specify include directories, compile options and link flags needed to compile
  and link the ``target`` using the specified modules. ::

    target_required_modules(<target>
                            <INTERFACE|PUBLIC|PRIVATE> <module> [module...]
                            [<INTERFACE|PUBLIC|PRIVATE> <module> [module...] ...])

  When specifying the ``module``, no version specification is allowed as it
  needs to be done using :command:`require_module`.

#]=======================================================================]
function(target_required_modules target)
  cmake_parse_arguments(PARSE_ARGV 0 ""
    ""
    ""
    "INTERFACE;PUBLIC;PRIVATE"
  )

  if(NOT(_INTERFACE OR _PUBLIC OR _PRIVATE))
    message(FATAL_ERROR "The required modules must be specified.")
  endif()

  foreach(scope INTERFACE PUBLIC PRIVATE)
    foreach(module ${_${scope}})
      if(NOT DEFINED _TargetModules_${module}_FOUND)
        message(FATAL_ERROR "The module `${module}` has not been required.")
      endif()

      if(NOT _TargetModules_${module}_FOUND)
        message(FATAL_ERROR "The module `${module}` has not been found.")
      endif()

      target_include_directories(${target} ${scope} ${_TargetModules_${module}_INCLUDE_DIRS})
      target_compile_options(${target} ${scope} ${_TargetModules_${module}_CFLAGS})
      target_link_libraries(${target} ${_TargetModules_${module}_LIBRARIES})
    endforeach(module)
  endforeach()

endfunction()
