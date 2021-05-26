REPO=myrepo
aws ecr list-images \
  --repository-name $REPO | \
jq -r ' .imageIds[] | [ .imageDigest ] | @tsv ' | \
  while IFS=$'\t' read -r imageDigest; do 
    aws ecr batch-delete-image \
      --repository-name $REPO \
      --image-ids imageDigest=$imageDigest
  done
