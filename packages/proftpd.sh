check_pkg_proftpd() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local maintenance_version=$(wget -q -O - http://www.proftpd.org/ | grep "Maintenance" | grep -o -E "[0-9]+(\.[0-9]+)*([a-z])?" | head -1)
	local stable_version=$(wget -q -O - http://www.proftpd.org/ | grep "Stable" | grep -o -E "[0-9]+(\.[0-9]+)*([a-z])?" | head -1)
	local version=$(sort -V <(cat <(echo $maintenance_version) <(echo $stable_version) ) | tail -1)

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
