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
FindGDBusCodegen
----------------

``gdbus-codegen`` is a D-Bus interface C code generation tool provided
by GLib.

This module finds the ``gdbus-codegen`` executable and add the
:command:`gdbus_generate_code` command.

Result Variables
^^^^^^^^^^^^^^^^

The following variable will also be set:

..variable:: GDBUS_CODEGEN_FOUND

  True if the ``gdbus-codegen`` executable was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variable may also be set:

.. variable:: GDBUS_CODEGEN_EXECUTABLE

  The path to the ``gdbus-codegen`` executable.

#]=======================================================================]

include_guard(GLOBAL)

include(FindPackageHandleStandardArgs)

find_program(GDBUS_CODEGEN_EXECUTABLE
  NAMES gdbus-codegen
  DOC "gdbus-codegen executable"
)
mark_as_advanced(GDBUS_CODEGEN_EXECUTABLE)

find_package_handle_standard_args(GDBUS_CODEGEN DEFAULT_MSG
  GDBUS_CODEGEN_EXECUTABLE)

#[=======================================================================[.rst:
.. command:: gdbus_generate_code

  Generates C code for a D-Bus interface introspection ``file``. ::

    gdbus_generate_code(<file>
                        [PREFIX <prefix>]
                        [NAMESPACE <namespace]
                        [HEADER_ONLY | BODY_ONLY]
                        [PRAGMA_ONCE])

  When the ``PREFIX`` argument is given, the specified ``prefix`` is stripped
  from the D-Bus interface name when computing the type name and the generated
  filenames.

  When the ``NAMESPACE`` argument is given, the specified ``namespace`` is used
  for generated identifier and is also prepended to the generated filenames.

  When the ``HEADER_ONLY`` or ``BODY_ONLY`` options are given, only one C code
  file is generated (respectively the header file or the body file).

  When the ``PRAGMA_ONCE`` options is given and the ``BODY_ONLY`` is not, the
  ``#pragma once`` directive is used instead of include guards.

  The generated file name is ``<namespace><name>.<ext>`` with:

  ``<namespace>``
    the namespace given though the ``NAMESPACE`` arguments
  ``<name>``
    the name computed by stripping the given ``prefix`` then converting
    to _CamelCase_
  ``<ext>``
    the file extension: `h` for the header and `c` for the body

  Examples
  """"""""

  .. code-block:: cmake

    gdbus_generate_code(org.example.foo1.Bar.xml)

  The ``OrgExampleFoo1Bar.h`` and ``OrgExampleFoo1Bar.c`` files will be
  generated.

  .. code-block:: cmake

    gdbus_generate_code(org.example.foo1.Bar.xml
                        PREFIX org.example.foo1
                        NAMESPACE Foo)

  The ``FooBar.h`` and ``FooBar.c`` files will be generated.

  .. code-block:: cmake

    gdbus_generate_code(org.example.foo1.Bar.xml
                        PREFIX org.example.foo1
                        NAMESPACE Foo
                        HEADER_ONLY
                        PRAGMA_ONCE)

  The ``FooBar.h`` header file will be generated using the ``#pragma once``
  preprocessor directive instead of include guards.

  A more complete example
  """""""""""""""""""""""

  .. code-blocks:: cmake

    find_package(PkgConfig REQUIRED)
    find_package(GDBusCodegen REQUIRED)

    set(target foo)

    pkg_check_modules(GLIB REQUIRED glib-2.0 gio-2.0)

    gdbus_generate_code(org.example.foo1.Bar.xml
                        PREFIX org.example.foo1
                        NAMESPACE Foo
                        PRAGMA_ONCE)

    add_executable(${target} main.c FooBar.c)
    target_include_directories(${target} PUBLIC GLIB_INCLUDE_DIRS})
    target_compile_options(${target} PUBLIC GLIB_CFLAGS})
    target_link_libraries(${target} GLIB_LIBRARIES})


#]=======================================================================]
function(gdbus_generate_code file)
  cmake_parse_arguments(PARSE_ARGV 0 ""
    "HEADER_ONLY;BODY_ONLY;PRAGMA_ONCE"
    "PREFIX;NAMESPACE"
    ""
  )

  # Check options
  if (_HEADER_ONLY AND _BODY_ONLY)
    message(FATAL_ERROR "HEADER_ONLY and BODY_ONLY options can not be both given.")
  endif()

  if (_PRAGMA_ONCE AND _BODY_ONLY)
    message(FATAL_ERROR "PRAGMA_ONCE and BODY_ONLY options can not be both given.")
  endif()

  # Compute command flags
  set(body_flags)

  if (_PREFIX)
    list(APPEND body_flags "--interface-prefix" "${_PREFIX}")
  endif()

  if (_NAMESPACE)
    list(APPEND body_flags "--c-namespace" "${_NAMESPACE}")
  endif()

  set(header_flags ${body_flags})

  if (_PRAGMA_ONCE)
    list(APPEND header_flags "--pragma-once")
  endif()

  # Compute filenames
  get_filename_component(filename "${file}" NAME) # TODO Use WLE component when CMake 3.14 is out

  if(NOT ${filename} MATCHES "^(.+)\\\.xml$")
    message(FATAL_ERROR "Failed to strip extension `.xml` from filename `${filename}`.")
  endif()

  set(basename ${CMAKE_MATCH_1})

  if(_PREFIX)
    if(_PREFIX STREQUAL basename)
      message(FATAL_ERROR "The prefix `${_PREFIX}` can not be the basename of `${filename}`.")
    endif()

    if(NOT ${basename} MATCHES "^${_PREFIX}\\\.(.+)$")
      message(FATAL_ERROR "Failed to strip prefix `${_PREFIX}` from basename `${basename}`.")
    endif()

    set(basename ${CMAKE_MATCH_1})
  endif()

  string(REPLACE "." ";" basename_components "${basename}")

  foreach(word ${basename_components})
    string(SUBSTRING "${word}" 0 1 first_letter)
    string(TOUPPER "${first_letter}" first_letter)
    string(REGEX REPLACE "^.(.*)$" "${first_letter}\\1" word "${word}")

    list(APPEND name_components ${word})
  endforeach()

  list(JOIN name_components "" name)

  set(header "${_NAMESPACE}${name}.h")
  set(body "${_NAMESPACE}${name}.c")

  # Compute body dependency
  set(body_dependency ${header})

  if (_BODY_ONLY)
    set(body_dependency ${file})
  endif()

  # Add commands to generate header and/or body files
  if (NOT _BODY_ONLY)
    add_custom_command(OUTPUT "${header}"
      COMMAND ${GDBUS_CODEGEN_EXECUTABLE} --header ${header_flags} --output "${header}" "${file}"
      MAIN_DEPENDENCY "${file}"
      COMMENT "Generating D-Bus interface header ${header}"
    )
  endif()

  if (NOT _HEADER_ONLY)
    add_custom_command(OUTPUT "${body}"
      COMMAND ${GDBUS_CODEGEN_EXECUTABLE} --body ${body_flags} --output "${body}" "${file}"
      MAIN_DEPENDENCY "${body_dependency}"
      COMMENT "Generating D-Bus interface body ${body}")
  endif()
endfunction()
