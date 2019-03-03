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
