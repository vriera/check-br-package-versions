check_pkg_gnutls() {
	local br_version_major=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION_MAJOR = " package/${1}/${1}.mk | awk '{print $3}')
	local br_version_minor=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | cut -d'.' -f2-)
	local br_version="${br_version_major}.${br_version_minor}"
	local version_major=$(wget -q -O - http://${1}.org/download.html | grep "Current stable" | grep -o -E "[0-9]+\.[0-9]+")
	local version=$(wget -q -O - https://www.gnupg.org/ftp/gcrypt/gnutls/v${version_major}/ | grep -o -E "gnutls-[0-9]+(\.[0-9]+)*" | sort -V | tail -1 | cut -d- -f2)
	
	if [[ "$br_version" != "$version" ]]; then
		if [[ "$br_version" != "" ]] && [[ "$version" != "" ]]; then
			packages="$packages $1"
			br_versions="$br_versions $br_version"
			versions="$versions $version"
		else
			echo "Warning: $1 code has a problem."
		fi
	fi

	unset br_version_major
	unset br_version_minor
	unset br_version
	unset version
}
