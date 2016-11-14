check_pkg_redis() {
	local br_version=$(grep -E "^${1^^}_VERSION = " package/${1}/${1}.mk | awk '{print $3}')
	local version=$(wget -q -O - http://download.redis.io/releases/ | grep -o -E "redis-[0-9]+\.[0-9]+(\.[0-9]+)?" | tail -n1 | sed 's/^redis-//')
	
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
