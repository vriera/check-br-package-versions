check_pkg_cmake() {
	local br_version_major=$(grep -E "^${1^^}_VERSION_MAJOR = " package/${1}/${1}.mk | awk '{print $3}')
	local br_version_minor=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | cut -d'.' -f2)
	local br_version="${br_version_major}.${br_version_minor}"
	local version=$(wget -q -O - https://cmake.org/download/ | grep "Latest Release" | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+" | head -n1)
	
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
