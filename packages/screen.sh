check_pkg_screen() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - http://ftp.gnu.org/gnu/${1}/ | grep -o -E "${1}-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.(gz|xz|bz2)" | tail -n1 | grep -o -E "[0-9]+\.[0-9]+(\.[0-9]+)?")
	
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
