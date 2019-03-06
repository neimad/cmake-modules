# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright © 2019 Damien Flament
# This file is part of CMake Modules.

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
