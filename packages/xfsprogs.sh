check_pkg_xfsprogs() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/ | grep 'Tag' -A 1 | grep -o -E 'v[0-9]+(\.[0-9]+)*' | head -1 | sed 's/^v//')
	
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
