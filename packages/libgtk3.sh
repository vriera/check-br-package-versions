check_pkg_libgtk3() {
	local br_version_major=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION_MAJOR = " package/${1}/${1}.mk | awk '{print $3}')
	local br_version_minor=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | cut -d'.' -f2-)
	local br_version="${br_version_major}.${br_version_minor}"
	local version_major=$(wget -q -O - https://www.gtk.org/download/linux.php | grep -o -E "gtk\+/3\.[0-9]+" | head -n1 | grep -o -E "3\.[0-9]+")
	local version=$(wget -q -O - http://ftp.gnome.org/pub/gnome/sources/gtk+/${version_major}/ | grep -o -E "LATEST-IS-${version_major}\.[0-9]+" | head -n1 | grep -o -E "3\.[0-9]+\.[0-9]+")
	
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
