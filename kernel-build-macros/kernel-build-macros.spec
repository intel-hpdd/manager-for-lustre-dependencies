Name:		kernel-build-macros
Version:	1
Release:	3%{?dist}
Summary:	RPM macros to build a kernel SRPM

License:	MIT
URL:		https://copr.fedorainfracloud.org/coprs/managerforlustre/

%description
%{summary}

%prep
%autosetup -c -D -T

%build
# Nothing to do

%install
mkdir -p %{buildroot}/%{_rpmconfigdir}/macros.d/
cat <<EOF  > %{buildroot}/%{_rpmconfigdir}/macros.d/macros.kernel-build
%_with_kabichk 0
%_without_kabichk 1
%_buildid _lustre
EOF

%files
%{_rpmconfigdir}/macros.d/macros.kernel-build

%changelog
* Fri Jun 30 2017 Brian J. Murrell <brian.murrell@intel.com> 1-3
- add buildid macro set to _lustre

* Fri Jun 30 2017 Brian J. Murrell <brian.murrell@intel.com> 1-2
- add %_without_kabichk: 1

* Fri Jun 30 2017 Brian J. Murrell <brian.murrell@intel.com> 1-1
- Initial package
