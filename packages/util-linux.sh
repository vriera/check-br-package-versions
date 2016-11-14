check_pkg_util_linux() {
	local br_version_major=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION_MAJOR = " package/${1}/${1}.mk | awk '{print $3}')
	local br_version_minor=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | cut -d'.' -f2)

	if [[ "${br_version_minor}" =~ "_VERSION" ]]; then
		local br_version="${br_version_major}"
	else
		local br_version="${br_version_major}.${br_version_minor}"
	fi

	local version=$(wget -q -O - https://www.kernel.org/pub/linux/utils/util-linux/ | grep -o -E "v[0-9]+\.[0-9]+" | tail -n1 | sed 's/^v//')
	version=$(wget -q -O - https://www.kernel.org/pub/linux/utils/util-linux/v${version}/ | grep -o -E "${1}-${version}(\.[0-9]+)?\.tar\.(xz|gz|bz2)" | sort -V | tail -1 | grep -o -E "${version}(\.[0-9]+)?")
	
	if [[ "$br_version" != "$version" ]]; then
		if [[ "$br_version" != "" ]] && [[ "$version" != "" ]]; then
			packages="$packages $1"
			br_versions="$br_versions $br_version"
			versions="$versions $version"
		else
			echo "Warning: $1 code has a problem."
		fi
	fi

	unset br_version_major
	unset br_version_minor
	unset br_version
	unset version
}
