# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright © 2019 Damien Flament
# This file is part of CMake Modules.

#[=======================================================================[.rst:
DBusInstallDirs
---------------

Define D-Bus standard installation directories.

Result Variables
^^^^^^^^^^^^^^^^

Inclusion of this module defines the following variables:

``DBUS_INSTALL_<dir>``

  Destination for files of a given type.  This value may be passed to
  the ``DESTINATION`` options of :command:`install` commands for the
  corresponding file type.

where ``<dir>`` is one of:

``INTERFACES_DIR``
  interface files (``DATADIR/dbus-1/interfaces``)
``SYSTEM_SERVICES_DIR``
  system service files (``DATADIR/dbus-1/system-services``)
``SESSION_SERVICES_DIR``
  session service files (``DATADIR/dbus-1/services``)
``SYSTEM_POLICIES_DIR``
  system security policies (``DATADIR/dbus-1/systemd.d``)
``SESSION_POLICIES_DIR``
  session security policies (``DATADIR/dbus-1/session.d``)

#]=======================================================================]

include_guard(GLOBAL)

include(GNUInstallDirs)

set(DBUS_INSTALL_INTERFACES_DIR "${CMAKE_INSTALL_DATADIR}/dbus-1/interfaces"
  CACHE PATH "D-Bus interfaces directory (DATADIR/dbus-1/interfaces)")

set(DBUS_INSTALL_SYSTEM_SERVICES_DIR "${CMAKE_INSTALL_DATADIR}/dbus-1/system-services"
  CACHE PATH "D-Bus system services directory (DATADIR/dbus-1/system-services)")

set(DBUS_INSTALL_SESSION_SERVICES_DIR "${CMAKE_INSTALL_DATADIR}/dbus-1/services"
  CACHE PATH "D-Bus session services directory (DATADIR/dbus-1/services)")

set(DBUS_INSTALL_SYSTEM_POLICIES_DIR "${CMAKE_INSTALL_DATADIR}/dbus-1/system.d"
  CACHE PATH "D-Bus system security policies directory (DATADIR/dbus-1/system.d)")

set(DBUS_INSTALL_SESSION_POLICIES_DIR "${CMAKE_INSTALL_DATADIR}/dbus-1/session.d"
  CACHE PATH "D-Bus session security policies directory (DATADIR/dbus-1/session.d)")

  mark_as_advanced(
    DBUS_INSTALL_INTERFACES_DIR
    DBUS_INSTALL_SYSTEM_SERVICES_DIR
    DBUS_INSTALL_SESSION_SERVICES_DIR
    DBUS_INSTALL_SYSTEM_POLICIES_DIR
    DBUS_INSTALL_SESSION_POLICIES_DIR
  )
