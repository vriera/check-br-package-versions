check_pkg_samba4() {
	local br_version=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - https://download.samba.org/pub/samba/stable/ | grep -o -E "samba-[0-9]+\.[0-9]+\.[0-9]+[a-z]?\.tar\.(gz|xz|bz2)" | tail -n1 | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+[a-z]?")
	
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
