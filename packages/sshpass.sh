check_pkg_sshpass() {
	local br_version=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - https://sourceforge.net/projects/${1}/files/${1}/ | grep -o -E "${1}-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.(gz|xz|bz2)" | head -n1 | grep -o -E "[0-9]+\.[0-9]+(\.[0-9]+)?")
	
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
