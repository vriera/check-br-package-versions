check_pkg_linux() {
	local br_version=$(grep -E "default .* BR2_LINUX_KERNEL_LATEST_VERSION" linux/Config.in | grep -o -E "[0-9]+\.[0-9]+(\.[0-9]+)?")
	local version=$(wget -q -O - https://www.kernel.org/ | grep -A 1 "latest_button" | grep -o -E "[0-9]+\.[0-9]+(\.[0-9]+)?" | head -n1)
	
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
