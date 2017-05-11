check_pkg_network_manager() {
	local br_version_major=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION_MAJOR = " package/${1}/${1}.mk | awk '{print $3}')
	local br_version_minor=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | cut -d'.' -f2-)
	local br_version="${br_version_major}.${br_version_minor}"
	local version=$(wget -q -O - https://wiki.gnome.org/Projects/NetworkManager | grep 'Stable' -m 1 -A 2 | tail -1 | grep -o -E 'NetworkManager-[0-9]+(\.[0-9]+)*\.tar\.(gz|bz2|xz)' | head -1 | grep -o -E '[0-9]+(\.[0-9]+)*')
	
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
