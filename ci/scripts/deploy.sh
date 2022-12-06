#!/usr/bin/env sh

. ./.env

read -p "Choose environment to deploy (staging or production): " environment
case $environment in
  staging)
    echo "Deploying in staging environment"
    user=$STAGING_SSH_USER
    host=$STAGING_HOST
    path=$STAGING_PATH
    tmppath=$STAGING_TMP_PATH
    branch=staging
    break
    ;;
  production)
    echo "Deploying in production environment"
    user=$PRODUCTION_SSH_USER
    host=$PRODUCTION_HOST
    path=$PRODUCTION_PATH
    tmppath=$PRODUCTION_TMP_PATH
    branch=master
    break
    ;;
  *)
    echo "invalid environment $environment"
    exit 1
    ;;
esac

deployer=$GITLAB_DEPLOY_USER
token=$GITLAB_DEPLOY_TOKEN
frontdeployer=$GITLAB_FRONT_DEPLOY_USER
fronttoken=$GITLAB_FRONT_DEPLOY_TOKEN

echo "\n- Login to docker for platform project\n"
ssh $user@$host "sudo docker login -u $deployer -p $token git.thecodingmachine.com:444"

echo "\n- Pulling platform image\n"
ssh $user@$host "cd $path && sudo docker pull git.thecodingmachine.com:444/tcm-projects/ccpm-classification/platform:$branch"

echo "\n- Login to docker for frontend project\n"
ssh $user@$host "sudo docker login -u $frontdeployer -p $fronttoken git.thecodingmachine.com:444"

echo "\n- Pulling frontend image\n"
ssh $user@$host "cd $path && sudo docker pull git.thecodingmachine.com:444/tcm-projects/ccpm-classification-front/front:$branch"

echo "\n- Downing containers\n"
ssh $user@$host "cd $path && sudo docker-compose down"

echo "\n- Creating temporary files and folders\n"
ssh $user@$host "cd $tmppath && mkdir -p ccpm"
ssh $user@$host "cd $tmppath/ccpm && mkdir -p containers"

echo "\n- Copying temporary docker-compose file\n"
scp ../../docker-compose.yml $user@$host:$tmppath/ccpm/docker-compose.yml

echo "\n- Copying temporary containers files\n"
scp -pqr ../../containers/* $user@$host:$tmppath/ccpm/containers/

echo "\n- Moving temporary files to application path\n"
ssh $user@$host "sudo rm $path/docker-compose.yml"
ssh $user@$host "sudo rm -r $path/containers/*"
ssh $user@$host "sudo mv $tmppath/ccpm/* $path/"
ssh $user@$host "sudo chown -R root:root $path/"

echo "\n- Removing temporary files\n"
ssh $user@$host "rm -r $tmppath/ccpm"

echo "\n- Starting containers\n"
ssh $user@$host "cd $path && sudo docker-compose up -d"

