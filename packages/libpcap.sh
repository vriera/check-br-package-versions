check_pkg_libpcap() {
	local br_version=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - http://www.tcpdump.org/ | grep -o -E "libpcap-([0-9]+\.){3}tar\.(gz|xz|bz2)" | sort | tail -n1 | grep -o -E "([0-9]+\.){2}[0-9]+")
	
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
