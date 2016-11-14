check_pkg_systemd() {
	local br_version=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - https://github.com/${1}/${1}/releases | grep -o -E "v[0-9]{3}" | head -n1 | sed "s/^v//")
	
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
