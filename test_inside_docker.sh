#!/bin/bash -xe

OS_VERSION=$1

echo 'travis_fold:start:yum'
yum -y install git mock rpm-build ed sudo
echo 'travis_fold:end:yum'

# add our repos to the mock configuration
ed <<"EOF" /etc/mock/default.cfg
$i

[copr-be.cloud.fedoraproject.org_results_managerforlustre_manager-for-lustre_epel-7-x86_64_]
name=added from: https://copr-be.cloud.fedoraproject.org/results/managerforlustre/manager-for-lustre/epel-7-x86_64/
baseurl=https://copr-be.cloud.fedoraproject.org/results/managerforlustre/manager-for-lustre/epel-7-x86_64/
enabled=1

[lustre-client]
name=Lustre Client
baseurl=https://downloads.whamcloud.com/public/lustre/lustre-2.10.6/el7/client/
enabled=1
gpgcheck=0
.
w
q
EOF

eval $(grep -e "^changed_dirs=" /manager-for-lustre-dependencies/env)

groupadd --gid $(stat -c '%g' /manager-for-lustre-dependencies) mocker
useradd --uid $(stat -c '%u' /manager-for-lustre-dependencies) --gid $(stat -c '%g' /manager-for-lustre-dependencies) mocker
usermod -a -G mock mocker


rc=0
for SUBDIR in $changed_dirs; do
    if ! su - mocker <<EOF; then
set -xe
cd /manager-for-lustre-dependencies/$SUBDIR
rpmbuild -bs --define epel\ 1 --define _srcrpmdir\ \$PWD --define _sourcedir\ \$PWD *.spec
echo "travis_fold:start:mock"
mock \$PWD/*.src.rpm
echo "travis_fold:end:mock"
EOF
        let rc+=1
    fi
done

exit $rc
