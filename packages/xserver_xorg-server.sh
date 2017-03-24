check_pkg_xserver_xorg_server() {
	local br_version=$(grep -E "default.*if BR2_PACKAGE_$(echo ${1^^} | sed 's/-/_/g')_V_" package/x11r7/${1}/Config.in | sort -V | tail -1 | grep -o -E "[0-9]+(\.[0-9]+)*" | head -1)
	local version="$(wget -q -O - https://www.x.org/releases/individual/xserver/ | grep -o -E "xorg-server-[0-9]+(\.[0-9]+)*\.tar\.(gz|xz|bz2)" | sort -V | tail -1 | grep -o -E "[0-9]+(\.[0-9]+)*")"
	
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
