check_pkg_dbus() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local major_version=$(wget -q -O - https://www.freedesktop.org/wiki/Software/dbus/ | grep -E "current.*stable" | head -1 | grep -o -E "D-Bus [0-9]+(\.[0-9]+)*" | cut -d' ' -f2)
	local version=$(wget -q -O - "https://cgit.freedesktop.org/dbus/dbus/tree/NEWS?h=dbus-${major_version}" | grep -E "D-Bus [0-9]+(\.[0-9]+)*" | grep -v "UNRELEASED" | head -1 | grep -o -E "D-Bus [0-9]+(\.[0-9]+)*" | cut -d' ' -f2)
	
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
