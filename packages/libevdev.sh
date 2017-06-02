check_pkg_libevdev() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - https://cgit.freedesktop.org/libevdev | grep "Tag" -A 8 | grep -o -E "libevdev-[0-9]+(\.[0-9]+)*" | sort -V | tail -1 | grep -o -E "[0-9]+(\.[0-9]+)*")
	
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
