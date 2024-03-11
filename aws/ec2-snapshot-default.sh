#!/bin/bash

TIMESTAMP="$(date +%Y%M%d_%H%M%S)"

# if [[ ${1} == "" ]]; then
# 	echo "Usage: ${0} qemu|vbox"
# 	exit 1
# else
# 	BUILDER=${1}
# fi

BUILDER="vbox"

BUCKET="ec2-vm-import-alephoo"
IMAGE="$(ls -1tr ../output-${BUILDER}/ | tail -n1)"

echo "Copy image to S3 Bucket ..."
aws s3 cp ../output-${BUILDER}/${IMAGE} s3://${BUCKET}/${IMAGE}

#IMAGEFORMAT="$(echo ${IMAGE} | rev | cut -d "." -f1 | rev)"
extension="${IMAGE##*.}"
IMAGEFORMAT="${extension#.}"
IMPORTSNAPSHOT="import-snapshot_${TIMESTAMP}.json"

cp import-snapshot.json ${IMPORTSNAPSHOT}
sed -i s/FORMAT_PLACEHODLER/${IMAGEFORMAT}/g ${IMPORTSNAPSHOT}
sed -i s/BUCKET_PLACEHODLER/${BUCKET}/g ${IMPORTSNAPSHOT}
sed -i s/IMAGE_PLACEHODLER/${IMAGE}/g ${IMPORTSNAPSHOT}

echo "Import image as EC2 snapshot ..."
# print output to stdout, capture ImporTaskId
IMPORTTASKID=$(aws ec2 import-snapshot --disk-container file://${IMPORTSNAPSHOT} | tee /dev/tty | grep ImportTaskId | cut -d \" -f 4)

# print command for following snapshot import status
echo aws ec2 describe-import-snapshot-tasks --import-task-id ${IMPORTTASKID}

rm ${IMPORTSNAPSHOT}

#examples:
#aws ec2 import-snapshot --disk-container file://containers.json 
#aws ec2 describe-import-snapshot-tasks --import-task-id import-snap-XXXX
