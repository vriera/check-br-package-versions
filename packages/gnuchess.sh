check_pkg_gnuchess() {
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - http://ftp.gnu.org/gnu/chess/ |grep -o -E "gnuchess-[0-9]+\.[0-9]+\.[0-9]+\.tar\.(gz|xz|bz2)" | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+" | tail -n1)
	
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
