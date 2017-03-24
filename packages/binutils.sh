check_pkg_binutils() {
	local br_version=$(grep -E "default.*if BR2_$(echo ${1^^} | sed 's/-/_/g')_VERSION" package/${1}/Config.in.host | sort -V | tail -1 | grep -o -E "[0-9]+(\.[0-9]+)*" | head -1)
	local version=$(wget -q -O - https://www.gnu.org/software/${1}/ | grep -E "latest release" | grep -o -E "[0-9]+(\.[0-9]+)*")
	
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
