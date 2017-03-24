check_pkg_ntp() {
	local br_version_major=$(grep -E "^${1^^}_VERSION_MAJOR = " package/${1}/${1}.mk | awk '{print $3}')
	local br_version_minor=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | cut -d'.' -f2-)
	local br_version="${br_version_major}.${br_version_minor}"
	local version=$(wget -q -O - http://www.${1}.org/ | grep -o -E "Stable:.*[0-9]+(\.[0-9]+)*(p[0-9]+)?" | grep -o -E "[0-9]+(\.[0-9]+)*(p[0-9]+)?")
	
	if [[ "$br_version" != "$version" ]]; then
		if [[ "$br_version" != "" ]] && [[ "$version" != "" ]]; then
			packages="$packages $1"
			br_versions="$br_versions $br_version"
			versions="$versions $version"
		else
			echo "Warning: $1 code has a problem."
		fi
	fi

	unset br_version
	unset version
}
