check_pkg_xenomai() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = [0-9]+\.[0-9]+\.[0-9]+" package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - http://${1}.org/downloads/${1}/stable/latest/ | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	
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
