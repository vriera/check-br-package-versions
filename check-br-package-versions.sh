#!/bin/bash

usage() {
	echo "Usage:"
	echo "  BR_REPO=<repository full path> [BR_BRANCH=<branch name>] ./check-br-package-versions.sh [pkg list]"
	echo ""
	echo "Example:"
	echo "  BR_REPO=/home/user/buildroot BR_BRANCH=next ./check-br-package-versions.sh bash ncurses nfs-utils"
}

# Script directory
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Buildroot repository
if [ -z $BR_REPO ]; then
	usage
	exit 1
else
	br_repo=${BR_REPO}
fi

# Buildroot branch (default to master)
br_branch=${BR_BRANCH:-master}

pkg_list=""

# Check all packages if the user provides no arguments.
# Otherwise check only the packages provided by the user.
if [[ $# -eq 0 ]]; then
	pkg_list="$(for i in ${script_dir}/packages/*; do basename ${i/.sh/}; done)"
else
	for pkg in $@; do
		if [[ -f ${script_dir}/packages/${pkg}.sh ]]; then
			pkg_list="${pkg_list} ${pkg}"
		else
			echo "Sorry, we don't have an script to check ${pkg}'s version."
		fi
	done
fi

# Number of packages to check
num_packages=$(echo $pkg_list | wc -w)

# These 3 variables will hold the packages which have version changes
packages=""
br_versions=""
versions=""

# These function shows all packages with version changes
print_results() {
	local br_version=""
	local version=""
	local output="\n\n"

	for pkg in $packages; do
		# extract versions
		br_version=$(echo $br_versions | awk '{print $1}')
		version=$(echo $versions | awk '{print $1}')

		# remove versions from the lists
		br_versions=$(echo $br_versions | cut -d' ' -f2-)
		versions=$(echo $versions | cut -d' ' -f2-)

		output="${output}${pkg}: ${br_version} -> ${version}\n"
	done

	echo -e $output

	unset br_version
	unset version
	unset output
}

############################################
# START
############################################

# If there isn't any package to check, just exit
if [[ -z $pkg_list ]]; then
	echo "Nothing to check."
	exit 0
fi

cd $br_repo

# Quietly update the repository
git fetch --all > /dev/null 2>&1
git reset --hard origin/${br_branch} > /dev/null 2>&1

# For each package, check its version
count=0
for pkg in $pkg_list; do
	count=$((count + 1))
	printf "\r%-$(tput cols)s" "Checking package versions... (${count}/${num_packages}) [${pkg}]"
	source "${script_dir}/packages/${pkg}.sh"
	check_pkg_${pkg//-/_} ${pkg}
done
printf "\r%-$(tput cols)s" "Checking package versions... (${count}/${num_packages})"

# Print results
if [[ -z $packages ]]; then
	echo -e "\n\nAll packages are up to date."
else
	print_results
fi

exit 0
