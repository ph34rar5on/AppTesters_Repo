#!/bin/bash

# Repository details
owner="apptesters-org"
repo="Repo"

# GitHub personal access token
token="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"

# Define the date pattern according to month
date_pattern="-03-2024"

# Function to fetch all release tags
fetch_releases() {
  page=1
  per_page=100
  releases=()

  while true; do
    response=$(curl -s -H "Authorization: token $token" \
      "https://api.github.com/repos/$owner/$repo/releases?per_page=$per_page&page=$page")

    tags=$(echo $response | jq -r '.[].tag_name')

    if [ -z "$tags" ]; then
      break
    fi

    releases+=($tags)
    page=$((page + 1))
  done

  echo "${releases[@]}"
}

# Fetch all releases
all_releases=$(fetch_releases)

# Debugging: print all fetched release tags
echo "Fetched release tags:"
echo "${all_releases[@]}"
echo ""

# Loop through each release tag and delete those matching the date pattern
for release in ${all_releases[@]}
do
  # Debugging: print the current release being processed
  echo "Processing release: $release"

  if [[ $release == *"$date_pattern" ]]; then
    gh release delete $release --repo $owner/$repo --yes
    echo "Deleted release $release"
  fi
done
