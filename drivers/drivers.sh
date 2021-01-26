#!/usr/bin/env bash
#
# Copyright (C) 2019 Rama Bondan Prakoso (rama982)
#
# Scripts to merge / upstream kernel drivers (wifi and audio)
#
# for msm-4.4+
#
# Kanged from gist.github.com/nathanchance/072a16428f592b76e7f025ccd1bb01ae

while ((${#})); do
	case ${1} in
	"-a" | "--audio") AUDIO=true ;;
	"-i" | "--init") INIT=true ;;
	"-p" | "--prima") PRIMA=true ;;
	"-t" | "--tag")
		shift
		TAG=${1}
		;;
	"-u" | "--update") UPDATE=true ;;
	esac
	shift
done

[[ -n ${INIT} && -n ${UPDATE} ]] && {
	echo "Both init and update were specified!"
	exit
}

[[ -z ${TAG} ]] && {
	echo "No tag was specified!"
	exit
}

SUBFOLDER_WLAN=drivers/staging
if [[ -z ${PRIMA} ]]; then
	REPOS_WLAN=("fw-api" "qcacld-3.0" "qca-wifi-host-cmn")
else
	REPOS_WLAN=("prima")
fi

URL_WLAN=https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/

for REPO in "${REPOS_WLAN[@]}"; do
	echo "${REPO}"
	if ! git ls-remote --exit-code "${REPO}" &>/dev/null; then
		git remote add "${REPO}" "${URL_WLAN}${REPO}"
	fi
	git fetch "${REPO}" "${TAG}"
	if [[ -n ${INIT} ]]; then
		git merge --allow-unrelated-histories -s ours --no-commit FETCH_HEAD
		git read-tree --prefix="${SUBFOLDER_WLAN}/${REPO}" -u FETCH_HEAD
		git commit --no-edit -m "staging: ${REPO}: Checkout at ${TAG}" -s
	elif [[ -n ${UPDATE} ]]; then
		git merge --no-edit -m "staging: ${REPO}: Merge tag '${TAG}' into $(git rev-parse --abbrev-ref HEAD)" \
			-m "$(git log --oneline --no-merges $(git branch | grep "\*" | sed 's/\* //')..FETCH_HEAD)" \
			-X subtree="${SUBFOLDER_WLAN}/${REPO}" --signoff FETCH_HEAD --signoff
	fi
done

[[ -z ${AUDIO} ]] && { exit; }

SUBFOLDER_AUDIO=techpack/audio
REPOS_AUDIO=("audio-kernel")
URL_AUDIO=https://source.codeaurora.org/quic/la/platform/vendor/opensource/

for REPO in "${REPOS_AUDIO[@]}"; do
	echo "${REPO}"
	if ! git ls-remote --exit-code "${REPO}" &>/dev/null; then
		git remote add "${REPO}" "${URL_AUDIO}${REPO}"
	fi
	git fetch "${REPO}" "${TAG}"
	if [[ -n ${INIT} ]]; then
		git merge --allow-unrelated-histories -s ours --no-commit FETCH_HEAD
		git read-tree --prefix="${SUBFOLDER_AUDIO}" -u FETCH_HEAD
		git commit --no-edit -m "techpack: ${REPO}: Checkout at ${TAG}" -s
	elif [[ -n ${UPDATE} ]]; then
		git merge --no-edit -m "techpack: ${REPO}: Merge tag '${TAG}' into $(git rev-parse --abbrev-ref HEAD)" \
			-m "$(git log --oneline --no-merges $(git branch | grep "\*" | sed 's/\* //')..FETCH_HEAD)" \
			-X subtree="${SUBFOLDER_AUDIO}" FETCH_HEAD --signoff
	fi
done
