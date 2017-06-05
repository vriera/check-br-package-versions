check_pkg_gqrx() {
	local github_user="csete"
	local github_project="$1"
	local remove_v=false
	local br_version=$(grep -E "^$(echo ${1^^} | sed 's/-/_/g')_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - https://github.com/${github_user}/${github_project}/releases/latest | grep -o -E "/${github_user}/${github_project}/releases/tag/([^\"])*" | head -1 | awk -F "/" '{print $NF}')
	
	if $remove_v; then
		version=$(echo $version | sed 's/^v//')
	fi

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
