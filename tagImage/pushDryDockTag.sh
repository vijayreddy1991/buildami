#!/bin/bash -e

export VERSION=""
export DOCKERHUB_ORG=drydock

export CURR_JOB=push-dry-tag
export RES_VER=ship-ver
export RES_DOCKERHUB_INTEGRATION=shipimg-dockerhub

# since resources here have dashes Shippable replaces them and UPPER cases them
export RES_VER_UP=$(echo ${RES_VER//-/} | awk '{print toupper($0)}')

# get dockerhub EN string
export RES_DH=$(echo ${RES_DOCKERHUB_INTEGRATION//-/} | awk '{print toupper($0)}')
export DH_STRING=$RES_DH"_INTEGRATION"

set_context() {
  export VERSION=$(eval echo "$"$RES_VER_UP"_VERSIONNAME")
  export DH_USERNAME=$(eval echo "$"$DH_STRING"_USERNAME")
  export DH_PASSWORD=$(eval echo "$"$DH_STRING"_PASSWORD")
  export DH_EMAIL=$(eval echo "$"$DH_STRING"_EMAIL")

  echo "VERSION=$VERSION"
  echo "DH_USERNAME=$DH_USERNAME"
  echo "DH_PASSWORD=${#DH_PASSWORD}" #show only count
  echo "DH_EMAIL=$DH_EMAIL"

  export IMAGE_NAMES="drydock/u14:tip \
  drydock/u16:tip "

  # create a state file so that next job can pick it up
  echo "versionName=$VERSION" > /build/state/$CURR_JOB.env #adding version state
  echo "IMAGE_NAMES=$IMAGE_NAMES" >> /build/state/$CURR_JOB.env

}

dockerhub_login() {
  echo "Logging in to Dockerhub"
  echo "----------------------------------------------"
  sudo docker login -u $DH_USERNAME -p $DH_PASSWORD -e $DH_EMAIL
}

pull_tag_push_images() {
  for image in $IMAGE_NAMES; do
    echo "Pulling -------------------> $image"
    __pull_tag_push_image $image
  done
}

__pull_tag_push_image() {
  if [[ -z "$1" ]]; then
    return 0
  fi

  image=$1
  full_name=$(echo $image | cut -d ':' -f 1)
  push_name=$full_name:$VERSION

  echo "pulling image $image"
  sudo docker pull $image
  sudo docker tag -f $image $push_name
  sudo docker push $push_name
}

main() {
  set_context
  dockerhub_login
  #pull_tag_push_images
}

main