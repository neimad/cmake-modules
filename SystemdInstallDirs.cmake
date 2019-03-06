# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright © 2019 Damien Flament
# This file is part of CMake Modules.

#[=======================================================================[.rst:
SystemdInstallDirs
------------------

Define Systemd standard installation directories.

Result Variables
^^^^^^^^^^^^^^^^

Inclusion of this module defines the following variables:

``SYSTEMD_INSTALL_<dir>``

  Destination for files of a given type.  This value may be passed to
  the ``DESTINATION`` options of :command:`install` commands for the
  corresponding file type.

where ``<dir>`` is one of:

``SYSTEM_UNITS_DIR``
  system units (``LIBDIR/systemd/system``)
``USER_UNITS_DIR``
  user units (``LIBDIR/systemd/user``)

#]=======================================================================]

include_guard(GLOBAL)

include(GNUInstallDirs)

set(SYSTEMD_INSTALL_SYSTEM_UNITS_DIR "${CMAKE_INSTALL_LIBDIR}/systemd/system"
  CACHE PATH "Systemd system units directory (LIBDIR/systemd/system)")

set(SYSTEMD_INSTALL_USER_UNITS_DIR "${CMAKE_INSTALL_LIBDIR}/systemd/user"
  CACHE PATH "Systemd user units directory (LIBDIR/systemd/user)")

mark_as_advanced(
  SYSTEMD_INSTALL_SYSTEM_UNITS_DIR
  SYSTEMD_INSTALL_USER_UNITS_DIR
)
