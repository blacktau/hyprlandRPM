%global major_version 5.5
%global upstream_version 5.5.0
%global srcname        lua

# Fedora 45+ ships Lua 5.5 as the system lua (lua-libs provides the same
# liblua-5.5.so). There we build a file-less shim instead: it upgrades the
# fc44 parallel-install packages away without file conflicts and keeps
# pkgconfig(lua5.5) working by pointing it at the system lua.pc.
%if 0%{?fedora} >= 45
%global shim 1
%global debug_package %{nil}
%else
%global shim 0
%endif

Name:           lua5.5
Version:        %{upstream_version}
Release:        2%{?dist}
Summary:        Powerful light-weight programming language (parallel-installable 5.5)
License:        MIT
URL:            https://www.lua.org/
Source0:        https://www.lua.org/ftp/%{srcname}-%{version}.tar.gz
Source1:        lua5.5.pc.in

# Fedora rawhide patches (lua.spec, branch rawhide)
Patch0:         lua-5.5.0-autotoolize.patch
Patch1:         lua-5.4.6-idsize.patch
Patch3:         lua-5.2.2-configure-linux.patch
Patch10:        lua-5.5.0-bug1.patch
Patch11:        lua-5.5.0-bug2.patch

%if %{shim}
Requires:       lua%{?_isa} >= %{major_version}
%else
BuildRequires:  automake autoconf libtool
BuildRequires:  readline-devel ncurses-devel
BuildRequires:  make gcc

# Coexists with stock lua-5.4 — does not provide lua/lua-libs/lua-devel
Provides:       lua(abi) = %{major_version}
%endif

Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description
Standalone Lua %{major_version} package, installed in parallel to Fedora's
default lua-5.4. Binaries are suffixed (lua5.5, luac5.5), shared lib is
liblua-5.5.so, headers live under /usr/include/lua5.5/, pkg-config name
is lua5.5.

%package libs
Summary:        Shared libraries for %{name}

%if %{shim}
Requires:       lua-libs%{?_isa} >= %{major_version}
%endif

%description libs
Shared libraries for Lua %{major_version}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}
Requires:       pkgconfig
%if %{shim}
Requires:       lua-devel%{?_isa} >= %{major_version}
%endif

%description devel
Headers and pkg-config file (lua5.5.pc) for Lua %{major_version}.

%prep
%if ! %{shim}
%setup -q -n %{srcname}-%{version}
mv src/luaconf.h src/luaconf.h.template.in
%patch -P0 -p1 -E -z .autoxxx
%patch -P1 -p1 -z .idsize
%patch -P3 -p1 -z .configure-linux
%patch -P10 -p1 -b .bug1
%patch -P11 -p1 -b .bug2

sed -i 's|5.5.0|%{version}|g' configure.ac
autoreconf -ifv
%endif

%build
%if ! %{shim}
%configure --with-readline --libdir=%{_libdir}
sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool
sed -i 's|@pkgdatadir@|%{_datadir}|g' src/luaconf.h.template

%make_build LIBS="-lm -ldl"
%endif

%install
%if %{shim}
mkdir -p %{buildroot}%{_libdir}/pkgconfig
cat > %{buildroot}%{_libdir}/pkgconfig/lua%{major_version}.pc <<'PC'
Name: Lua
Description: Lua %{major_version} (compat shim over the system lua)
Version: %{version}
Requires: lua >= %{major_version}
Libs:
Cflags:
PC
%else
%make_install

# Drop libtool/static artefacts and the unversioned libtool symlink
# (we ship only the versioned liblua-5.5.so to coexist with stock lua)
rm -f %{buildroot}%{_libdir}/*.la
rm -f %{buildroot}%{_libdir}/liblua.a
rm -f %{buildroot}%{_libdir}/liblua.so

# Rename binaries: lua → lua5.5, luac → luac5.5
mv %{buildroot}%{_bindir}/lua  %{buildroot}%{_bindir}/lua%{major_version}
mv %{buildroot}%{_bindir}/luac %{buildroot}%{_bindir}/luac%{major_version}

# Drop stock-named pkgconfig (we ship our own)
rm -f %{buildroot}%{_libdir}/pkgconfig/lua.pc

# Move headers into versioned dir to avoid clash with stock lua-devel
mkdir -p %{buildroot}%{_includedir}/lua%{major_version}
mv %{buildroot}%{_includedir}/lua.h     %{buildroot}%{_includedir}/lua%{major_version}/
mv %{buildroot}%{_includedir}/lualib.h  %{buildroot}%{_includedir}/lua%{major_version}/
mv %{buildroot}%{_includedir}/lauxlib.h %{buildroot}%{_includedir}/lua%{major_version}/
mv %{buildroot}%{_includedir}/luaconf.h %{buildroot}%{_includedir}/lua%{major_version}/
mv %{buildroot}%{_includedir}/lua.hpp   %{buildroot}%{_includedir}/lua%{major_version}/ 2>/dev/null || :

# Drop man page to avoid clash with stock lua
rm -rf %{buildroot}%{_mandir}

# Drop stock module dirs (we don't ship 5.5 lua modules in this RPM set)
rm -rf %{buildroot}%{_libdir}/lua %{buildroot}%{_datadir}/lua

# Install our pkg-config
mkdir -p %{buildroot}%{_libdir}/pkgconfig
sed -e 's|@VERSION@|%{version}|g' -e 's|@LIBDIR@|%{_lib}|g' \
    %{SOURCE1} > %{buildroot}%{_libdir}/pkgconfig/lua%{major_version}.pc

%endif

%if %{shim}
%files

%files libs

%files devel
%{_libdir}/pkgconfig/lua%{major_version}.pc
%else
%files
%license doc/readme.html
%doc README doc/*.html doc/*.css doc/*.png
%{_bindir}/lua%{major_version}
%{_bindir}/luac%{major_version}

%files libs
%{_libdir}/liblua-%{major_version}.so

%files devel
%dir %{_includedir}/lua%{major_version}
%{_includedir}/lua%{major_version}/*
%{_libdir}/pkgconfig/lua%{major_version}.pc

%endif

%changelog
* Sat Nov 07 2026 Sean Garrett <sean+claude@blacktau.com> - 5.5.0-2
- Fedora 45+: build a file-less shim over the system Lua 5.5 (lua-libs
  now ships liblua-5.5.so, which conflicted with lua5.5-libs).

* Mon May 25 2026 Sean Garrett <sean+claude@blacktau.com> - 5.5.0-1
- Initial parallel-installable Lua 5.5 package for COPR.
- Required by Hyprland >= 0.55.0 (Lua-based config).
